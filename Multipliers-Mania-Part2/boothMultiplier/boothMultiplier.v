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

module boothMultiplier(
    input signed [31:0] multiplicand,
    input signed [31:0] multiplier,
    output signed [63:0] result
);
    reg [64:0] Acc;
    integer i;
    reg [31:0] multiplicand_temp;

    always @(*) begin  
        Acc = 65'b0;
        Acc[32:1] = multiplier;
        multiplicand_temp = multiplicand;
        for (i = 0; i < 32; i = i + 1) begin
            if (Acc[0] == 1'b1 && Acc[1] == 1'b0)
                Acc[64:33] = Acc[64:33] + multiplicand_temp;
            else if (Acc[0] == 1'b0 && Acc[1] == 1'b1)
            begin
                Acc[64:33] = Acc[64:33] - multiplicand_temp;
            end

            Acc = {Acc[64], Acc[64:1]};
        end
        end

    assign  result = Acc[64:1];
 endmodule
 
module registeredBooth #(parameter N = 32 ) (
    input clk,reset,enable,
    input signed [N-1:0] A, B,
    output signed [2*N-1:0] result
);
wire [2*N-1:0] regAB,regOut;

genericRegister #(64) AB (clk,reset,enable,{A,B}, regAB);
boothMultiplier boothMult (regAB[63:32], regAB[31:0], regOut);
genericRegister #(64) finalOutput (clk, reset, enable, {regOut}, {result});

endmodule