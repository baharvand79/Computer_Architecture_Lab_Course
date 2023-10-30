`include "ARM.v"
module ARM_TB();
	reg clk = 1'b0;
   	reg rst = 1'b0;
	reg freeze = 1'b0;
	reg Branch_Tacken = 1'b1;
    reg flush = 1'b0;
	reg [31:0] Branch_Address = 32'b00000000000000000000000000000000;
	wire [31: 0] Instruction, pc;

    ARM arm (clk, rst, freeze, flush, Branch_Tacken, Branch_Addres, PC, Instrucion);

	always #5 clk = ~clk; 
	initial begin
		$dumpfile("ARM_TB.vcd");
        $dumpvars(0, ARM_TB);
		rst = 1'b1;
		#52 rst = 1'b0; 
		#500 rst = 1'b1;
		#52 rst = 1'b0; 
		#500 $finish;
	end
endmodule