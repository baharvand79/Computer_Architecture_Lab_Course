`include "IF_Stage.v"
`include "adder.v"
`include "Instruction_memory.v"
`include "mux2to1.v"
`include "PC.v"
module IF_TB();
	reg clk = 1'b0;
   	reg rst = 1'b0;
	reg freeze = 1'b0;
	reg Branch_Tacken = 1;
	reg [31:0] Branch_Address = 32'b00000000000000000000000000000000;
	wire [31: 0] Instruction, pc;

	IF_Stage IF_stage(.clk(clk), .rst(rst), .freeze(freeze), .Branch_Tacken(Branch_Tacken),
			 .Branch_Address(Branch_Addres), .Instruction(Instruction), .pc(pc));

	always #5 clk = ~clk; 
	initial begin
		rst = 1'b1;
		#52 rst = 1'b0; 
		#500 rst = 1'b1;
		#52 rst = 1'b0; 
		#500 $finish;
	end

endmodule
