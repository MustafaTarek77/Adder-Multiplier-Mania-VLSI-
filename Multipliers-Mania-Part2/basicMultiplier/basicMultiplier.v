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

module basicMultiplier(
    input signed [31:0] multiplicand,
    input signed [31:0] multiplier,
    output reg signed [63:0] result
);

    always @ (multiplicand or multiplier)
    begin
        result = multiplicand * multiplier;
    end

endmodule

module registeredBasic #(parameter N = 32 ) (
    input clk,reset,enable,
    input signed [N-1:0] A, B,
    output signed [2*N-1:0] result
);
wire [2*N-1:0] regAB,regOut;

genericRegister #(64) AB (clk,reset,enable,{A,B}, regAB);
basicMultiplier basicMult (regAB[63:32], regAB[31:0], regOut);
genericRegister #(64) finalOutput (clk, reset, enable, {regOut}, {result});

endmodule

