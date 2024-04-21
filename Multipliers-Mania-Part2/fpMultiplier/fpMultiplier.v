module fpMultiplier (
    input [31:0] A,
    input [31:0] B,
    output [31:0] result,
    output overflow
);

wire SR,zeroFlag;

wire [8:0] ER;
wire [23:0] MA,MB;
wire [47:0] mantissasProduct,mantissaProductNormalized;
wire [22:0] MR;

assign zeroFlag = (A == 32'b0) || (B == 32'b0);
assign SR = zeroFlag ? 0 : (A[31] ^ B[31]);
assign MA[23:0] = (A[30:23] == 8'b0) ? {1'b0,A[22:0]} : {1'b1,A[22:0]};          
assign MB[23:0] = (B[30:23] == 8'b0) ? {1'b0,B[22:0]} : {1'b1,B[22:0]};         
assign mantissasProduct = MA * MB;                      
assign mantissaProductNormalized = mantissasProduct[47] ?  mantissasProduct : (mantissasProduct << 1);         
assign MR = zeroFlag ? 0 : mantissaProductNormalized[46:24];      
assign ER = zeroFlag ? 0 : (A[30:23] + B[30:23] - 8'b01111111 + mantissasProduct[47]); 
assign overflow = (ER[8]) & !(zeroFlag); //exponent > 255
assign result = { SR,ER[7:0],MR }; 


endmodule

module genericRegister #(parameter N = 32) (
    input clk,reset,enable,
    input signed [N-1:0] in,
	output  reg signed[N-1:0] out
);
	always @(posedge clk)
		begin
			if (reset) 
				out <= 0;
			else if(enable)
				out <= in;
		end
endmodule

module registeredFPM #(parameter N = 32 ) (
    input clk,reset,enable,
    input signed [N-1:0] A, B,
    output signed [N-1:0] result,
    output overflow
);
wire [2*N-1:0] regAB;
wire [N-1:0] regOut;
wire regOverflow;

genericRegister #(64) AB (clk,reset,enable,{A,B}, regAB);
fpMultiplier fpMult (regAB[63:32], regAB[31:0], regOut, regOverflow);
genericRegister #(33) finalOutput (clk, reset, enable, {regOut, regOverflow}, {result, overflow});

endmodule