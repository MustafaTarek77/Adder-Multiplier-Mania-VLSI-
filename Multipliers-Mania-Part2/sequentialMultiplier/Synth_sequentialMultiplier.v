/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : U-2022.12-SP7
// Date      : Sun Dec 24 19:26:41 2023
/////////////////////////////////////////////////////////////


module registeredSequential ( innerClk, clk, reset, enable, A, B, result, 
        overflow );
  input [31:0] A;
  input [31:0] B;
  output [63:0] result;
  input innerClk, clk, reset, enable;
  output overflow;
  wire   regOverflow;
  wire   [63:0] regAB;
  wire   [63:0] regOut;

  genericRegister_N64 AB ( .clk(clk), .reset(reset), .enable(enable), .in({A, 
        B}), .out(regAB) );
  sequentialMultiplier sequentialMult ( .clk(innerClk), .A(regAB[63:32]), .B(
        regAB[31:0]), .out(regOut), .overFlow(regOverflow) );
  genericRegister_N65 finalOutput ( .clk(clk), .reset(reset), .enable(enable), 
        .in({regOut, regOverflow}), .out({result, overflow}) );
endmodule

