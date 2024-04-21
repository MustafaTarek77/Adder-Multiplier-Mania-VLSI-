module sequentialMultiplier_tb();

  reg innerClk, clk, reset,enable;
  reg  [31:0] in1,in2;
  wire [63:0] out;
  integer count;
  parameter maxInt=2147483647,minInt=-2147483648;
  
  registeredSequential dut (innerClk,clk,reset,enable,in1,in2,out);

  always #3200 clk = ~clk;
  always #50 innerClk = ~innerClk;
  
  initial begin
    innerClk = 1'b1;
    clk   = 1'b1;
    enable = 1'b1;
    reset = 1'b0;
    count = 0;

    in1 = -5;
    in2 = 5;
    #6400;
	
    in1 = 4;
    in2 = 10;
    #6400;
    if(out === -25 ) begin
		$display("TestCase#1 Success");
		count = count + 1 ;
	end
	else $display("TestCase#1 failed with inputs= %d , %d and output= %d expected= %d   ", $signed(in1), $signed(in2), $signed(out), $signed(-25));
	
    in1 = -4;
    in2 = -10;
    #6400;
    
    if(out === 40 ) begin
		$display("TestCase#2 Success");
		count = count + 1 ;
	end
	else $display("TestCase#2 failed with inputs= %d , %d and output= %d expected= %d", $signed(in1), $signed(in2), $signed(out), $signed(40));

	
    in1 = 0;
    in2 = 3;
    #6400;
    if(out === 40 ) begin
		$display("TestCase#3 Success");
		count = count + 1 ;
	end
	else $display("TestCase#3 failed with inputs= %d , %d and output= %d expected= %d", $signed(in1), $signed(in2), $signed(out), $signed(40));

    in1 = 1;
    in2 = 3;
    #6400;
    if(out === 0 ) begin
		$display("TestCase#4 Success");
		count = count + 1 ;
	end
	else $display("TestCase#4 failed with inputs= %d , %d and output= %d expected= %d", $signed(in1), $signed(in2), $signed(out), $signed(0));

    in1 = 3;
    in2 = 7;

    #6400;
    if(out === 3 ) begin
		$display("TestCase#5 Success");
		count = count + 1 ;
	end
	else $display("TestCase#5 failed with inputs= %d , %d and output= %d expected= %d", $signed(in1), $signed(in2), $signed(out), $signed(3));

    in1 = 2;
    in2 = -2;

    #6400;
    if(out === 21 ) begin
		$display("TestCase#6 Success");
		count = count + 1 ;
	end
	else $display("TestCase#6 failed with inputs= %d , %d and output= %d expected= %d", $signed(in1), $signed(in2), $signed(out),$signed(21));

    in1 = 5;
    in2 = 7;

    #6400;
    if(out === -4 ) begin
		$display("TestCase#7 Success");
		count = count + 1 ;
	end
	else $display("TestCase#7 failed with inputs= %d , %d and output= %d expected= %d", $signed(in1), $signed(in2), $signed(out), $signed(-4));

    in1 = 0;
    in2 = 0;
    #6400;
    if(out === 35 ) begin
		$display("TestCase#8 Success");
		count = count + 1 ;
	end
	else $display("TestCase#8 failed with inputs= %d , %d and output= %d ", $signed(in1), $signed(in2), $signed(out), $signed(35));

    in1 = 300;
    in2 = 3;
    #6400;
	if(out === 0) begin
		$display("TestCase#9 Success");
		count = count + 1 ;
	end
	else $display("TestCase#9 failed with inputs= %d , %d and output= %d expected= %d", $signed(in1), $signed(in2), $signed(out), $signed(0));

    #6400;
	if(out === 900 ) begin
		$display("TestCase#10 Success");
		count = count + 1 ;
	end
	else $display("TestCase#10 failed with inputs= %d , %d and output= %d ", $signed(in1), $signed(in2), $signed(out), $signed(900));

	$display("--------------------- %d   passed testcases out of 10   ---------------------", count);
	$display("--------------------- %d     failed testcases out of 10     ---------------------", 10-count);

  end

endmodule
