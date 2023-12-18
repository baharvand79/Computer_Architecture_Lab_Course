
module Data_Memory(clk, rst, mem_r_en, mem_w_en, val_rm, alu_res, Data_Memory_Output, instruction_in, instruction_out, mem1, mem2, mem3, mem4);
	input clk, rst, mem_r_en, mem_w_en;
	input [31:0] val_rm, alu_res, instruction_in;
	output reg [31:0] Data_Memory_Output;
	output [31:0] instruction_out;
	reg [31:0] memory[0:64];
	wire [31:0] address, Data_Memory_Output_tmp;
	output reg [31:0] mem1, mem2, mem3, mem4;
	assign address = ((val_rm - 1024) >> 2);
	assign instruction_out = instruction_in;
//	integer i;
//	initial begin
//		for(i = 0; i < 64; i = i+1)
//			memory[i] = 32'd0;
//	end
//	always @ (posedge clk, posedge rst) begin
//		if(rst) begin
//			Data_Memory_Output = 32'b;
//		end
//		if(mem_w_en) begin
//			memory[address] = alu_res;
//		end
//	end
//	always@(mem_r_en, address)begin
//		if(mem_r_en)begin
//			Data_Memory_Output = memory[address];
//		end
//	end
	assign Data_Memory_Output_tmp = (mem_r_en) ? memory[address] : Data_Memory_Output;

	always @ (posedge clk, posedge rst) begin
		Data_Memory_Output = Data_Memory_Output_tmp;
		if(rst) begin
			Data_Memory_Output = 32'b0;
		end
		else if(mem_r_en)begin
			memory[address] <= alu_res;
		end
	end
endmodule

