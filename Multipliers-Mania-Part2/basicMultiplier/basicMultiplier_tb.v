module basic_tb();

  reg clk, reset,enable;
  reg  [31:0] in1,in2;
  wire [63:0] out;
  integer count;
  parameter maxInt=2147483647,minInt=-2147483648;
  
  registeredBasic dut (clk,reset,enable,in1,in2,out);

  always #10 clk = ~clk;
  
  initial begin
    clk   = 1'b1;
    enable = 1'b0;
    count = 0;

    reset = 1'b1;
    #40
    reset = 1'b0;

    in1 = -5;
    in2 = 5;
    #20;
    enable=1;
    #80;
	if(out === -25 ) begin
		$display("TestCase#1 Success");
		count = count + 1 ;
	end
	else $display("TestCase#1 failed with inputs= %d , %d and output= %d expected= %d   ", $signed(in1), $signed(in2), $signed(out), $signed(-25));

    in1 = 5;
    in2 = 10;
    #80;
	if(out === 50 ) begin
		$display("TestCase#2 Success");
		count = count + 1 ;
	end
	else $display("TestCase#2 failed with inputs= %d , %d and output= %d expected= %d", $signed(in1), $signed(in2), $signed(out), $signed(25));

    in1 = -5;
    in2 = -20;
    #80;
	if(out === 100 ) begin
		$display("TestCase#3 Success");
		count = count + 1 ;
	end
	else $display("TestCase#3 failed with inputs= %d , %d and output= %d expected= %d", $signed(in1), $signed(in2), $signed(out), $signed(100));

    in1 = 0;
    in2 = 50;
    #80;
	if(out === 0 ) begin
		$display("TestCase#4 Success");
		count = count + 1 ;
	end
	else $display("TestCase#4 failed with inputs= %d , %d and output= %d expected= %d", $signed(in1), $signed(in2), $signed(out), $signed(0));

    in1 = 1;
    in2 = 50;
    #80;
	if(out === 50 ) begin
		$display("TestCase#5 Success");
		count = count + 1 ;
	end
	else $display("TestCase#5 failed with inputs= %d , %d and output= %d expected= %d", $signed(in1), $signed(in2), $signed(out), $signed(50));

    in1 = 20;
    in2 = 30;

    #80;
	if(out === 600 ) begin
		$display("TestCase#6 Success");
		count = count + 1 ;
	end
	else $display("TestCase#6 failed with inputs= %d , %d and output= %d expected= %d", $signed(in1), $signed(in2), $signed(out),$signed(600));

    in1 = 30;
    in2 = -30;

    #80;
	if(out === -900 ) begin
		$display("TestCase#7 Success");
		count = count + 1 ;
	end
	else $display("TestCase#7 failed with inputs= %d , %d and output= %d expected= %d", $signed(in1), $signed(in2), $signed(out), $signed(-900));


    in1 = 10;
    in2 = 10;

    #80;
	if(out === 100 ) begin
		$display("TestCase#8 Success");
		count = count + 1 ;
	end
	else $display("TestCase#8 failed with inputs= %d , %d and output= %d ", $signed(in1), $signed(in2), $signed(out), $signed(100));

    in1 = 0;
    in2 = 0;
    #80;
	if(out === 0) begin
		$display("TestCase#9 Success");
		count = count + 1 ;
	end
	else $display("TestCase#9 failed with inputs= %d , %d and output= %d expected= %d", $signed(in1), $signed(in2), $signed(out), $signed(0));

    in1 = 100;
    in2 = 100;
    #80;
	if(out === 10000 ) begin
		$display("TestCase#10 Success");
		count = count + 1 ;
	end
	else $display("TestCase#10 failed with inputs= %d , %d and output= %d ", $signed(in1), $signed(in2), $signed(out), $signed(10000));
    enable=0;

	$display("--------------------- %d   passed testcases out of 10   ---------------------", count);
	$display("--------------------- %d     failed testcases out of 10     ---------------------", 10-count);

  end

endmodule