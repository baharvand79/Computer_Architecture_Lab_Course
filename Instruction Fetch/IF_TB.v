
module IF_TB();
	reg clk = 1'b0;
   	reg rst = 1'b0;
	reg freeze = 1'b0;
	reg Branch_Tacken = 1;
	reg [31:0] Branch_Address = 32'b0;
	wire [31: 0] Instruction;
	datapath datapath(.clk(clk), .rst(rst), .freeze(freeze), .Branch_Tacken(Branch_Tacken),
			 .Branch_Address(Branch_Addres), .Instruction(Instruction));

	always #5 clk = ~clk; 
	initial begin
		rst = 1'b1;
		#52 rst = 1'b0; 
		#500 rst = 1'b1;
		#52 rst = 1'b0; 
		#500 $stop;
	end

endmodule
