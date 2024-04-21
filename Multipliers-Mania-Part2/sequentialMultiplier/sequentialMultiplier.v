module sequentialMultiplier(
    input clk,
    input [31:0] A,
    input [31:0] B,
    output reg [63:0] out
);
    reg [64:0] accumulator;
    reg[31:0] in1;
    reg[31:0] in2;
    reg sign;
    integer count=0;
    
    initial begin
            if(A[31]==0&&B[31]==0)
            begin
                sign=0;
                in1=A;
                in2=B;
            end
        else if(A[31]==1&&B[31]==1)
            begin
                sign=0;
                in1= (~ A)+1;
                in2= (~ B)+1;
            end
        else if(A[31]==0&&B[31]==1)
            begin
                sign=1;
                in1=A;
                in2= (~ B)+1;
            end
        else
            begin
                sign=1;
                in1= (~ A)+1;
                in2=B;
            end
        accumulator={32'b0,in2};
        count=0;
    end

    always @(posedge clk) begin
        if(accumulator[0]==0)
            begin
                accumulator=accumulator>>1;
            end
        else
            begin
                accumulator[64:32]= accumulator[64:32]+in1;
                accumulator=accumulator>>1;
            end

        if (count==31)
            begin
                if(sign==0)
                    begin
                        out=accumulator[63:0];
                    end
                else
                    begin
                        out=(~ accumulator[63:0])+1;
                    end
                if(A[31]==0&&B[31]==0)
                    begin
                        sign=0;
                        in1=A;
                        in2=B;
                    end
                else if(A[31]==1&&B[31]==1)
                    begin
                        sign=0;
                        in1= (~ A)+1;
                        in2= (~ B)+1;
                    end
                else if(A[31]==0&&B[31]==1)
                    begin
                        sign=1;
                        in1=A;
                        in2= (~ B)+1;
                    end
                else
                    begin
                        sign=1;
                        in1= (~ A)+1;
                        in2=B;
                    end
                accumulator={32'b0,in2};
                count=0;
            end
        else
            begin
                count=count+1;
            end
    end
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

module registeredSequential #(parameter N = 32 ) (
    input innerClk,clk,reset,enable,
    input signed [N-1:0] A, B,
    output signed [2*N-1:0] result
);
wire [2*N-1:0] regAB,regOut;

genericRegister #(64) AB (clk,reset,enable,{A,B}, regAB);
sequentialMultiplier sequentialMult (innerClk, regAB[63:32], regAB[31:0], regOut);
genericRegister #(65) finalOutput (clk, reset, enable, regOut, result);

endmodule