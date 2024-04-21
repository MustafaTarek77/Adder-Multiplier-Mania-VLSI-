/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : U-2022.12-SP7
// Date      : Sun Dec 24 13:12:39 2023
/////////////////////////////////////////////////////////////


module registeredFPM ( clk, reset, enable, A, B, result, overflow );
  input [31:0] A;
  input [31:0] B;
  output [31:0] result;
  input clk, reset, enable;
  output overflow;

  wire   [63:0] regAB;
  tri   clk;
  tri   reset;
  tri   enable;
  tri   [31:0] result;
  tri   overflow;
  tri   [31:0] regOut;
  tri   regOverflow;

  genericRegister_N64 AB ( .clk(clk), .reset(reset), .enable(enable), .in({A, 
        B}), .out(regAB) );
  fpMultiplier fpMult ( .A(regAB[63:32]), .B(regAB[31:0]), .result(regOut), 
        .overflow(regOverflow) );
  genericRegister finalOutput ( .p1(clk), .p2(reset), .p3(enable), .p4({regOut, 
        regOverflow}), .p5({result, overflow}) );
endmodule

