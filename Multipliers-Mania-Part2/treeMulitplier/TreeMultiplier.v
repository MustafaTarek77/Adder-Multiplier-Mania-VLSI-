module treeMultiplier(
    input [31:0] A,
    input [31:0] B,
    output reg [63:0] out
);

  reg sign;
  reg[31:0] in1;
  reg[31:0] in2;
  reg [31:0] p   [31:0];
  reg [62:0] carry[10:0]; 
  reg [62:0] sum  [10:0];
  reg [63:0] carryOut;
  reg [63:0]outTemp;
  
  // Initialize arrays
  integer row,column,i,j,temp;
  initial begin
    for (column = 0; column < 64; column = column + 1) begin
        carryOut[column] = 1'b0; 
        outTemp[column] = 1'b0; 
      end
    for (row = 0; row < 11; row = row + 1) begin
      for (column = 0; column < 63; column = column + 1) begin
        sum[row][column] = 1'b0; 
        carry[row][column] = 1'b0; 
      end
    end
  end

  // Defining the sign
  always @(*)
  begin
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
  
  // Calculating the products
  for(row = 0; row<32; row=row+1) 
      for(column = 0; column<32; column=column+1) 
         p[row][column] = in2[row] & in1[column];

    for(i = 0; i<10; i=i+1) begin : gen_i
      //row i
       temp = i + i + i;
       sum[i][0] = p[temp][0];  //col0
      // Half Adder  //col1
       sum[i][1] = p[temp][1] ^ p[temp+1][0];
       carry[i][1] = p[temp][1] & p[temp+1][0];
      for(j = 0; j<30; j=j+1) begin : gen_j
        // Full Adder
         sum[i][j+temp+2]   = p[temp][2+j] ^ p[temp+1][1+j] ^ p[temp+2][j];
         carry[i][j+temp+2] = (p[temp][2+j] & p[temp+1][1+j]) | (p[temp+1][1+j] & p[temp+2][j]) | (p[temp][2+j] & p[temp+2][j]);
      end
      // Half Adder  //col30
       sum[i][32+temp]   = p[temp+2][30] ^ p[temp+1][31];
       carry[i][32+temp] = p[temp+2][30] & p[temp+1][31];
       sum[i][33+temp] = p[temp+2][31];  //col31
    end

  // Last 2 bits
       sum[10][30] = p[30][0];  //col0
      for(j = 0; j<31; j=j+1) begin : gen_j2 
        // Half Adder
         sum[10][j+31]   = p[30][j+1] ^ p[31][j];
         carry[10][j+31] = p[30][j+1] & p[31][j]; 
      end
       sum[10][62] = p[31][31];  //col31

  // Assigning outputs 
    for (column = 0; column < 64; column = column + 1)
      begin
        carryOut[column] = 1'b0; 
        outTemp[column] = 1'b0; 
      end
    outTemp[0] = sum[0][0];
    for (column = 1; column < 63; column = column + 1)
      begin
        // Full Adder
        outTemp[column] = sum[0][column] ^ carry[0][column-1] ^ carryOut[column-1];
        carryOut[column] = (sum[0][column] & carry[0][column-1]) | (carry[0][column-1] & carryOut[column-1]) | (sum[0][column] & carryOut[column-1]);
        for (row = 1; row < 11; row = row + 1)
          begin
            outTemp[column] = sum[row][column] ^ carry[row][column-1] ^ outTemp[column];
          end
      end

  if(sign==0)
      begin
         out=outTemp;
      end
  else
      begin
         out=(~ outTemp)+1;
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

module registeredTree #(parameter N = 32 ) (
    input clk,reset,enable,
    input signed [N-1:0] A, B,
    output signed [2*N-1:0] result
);
wire [2*N-1:0] regAB,regOut;

genericRegister #(64) AB (clk,reset,enable,{A,B}, regAB);
treeMultiplier treeMult (regAB[63:32], regAB[31:0], regOut);
genericRegister #(65) finalOutput (clk, reset, enable, regOut, result);

endmodule