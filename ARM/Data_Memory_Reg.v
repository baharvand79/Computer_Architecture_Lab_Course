
module Data_Memory_Reg(clk, rst, mem_r_en, wb_en, alu_res, data_mem_out, dest_in, mem_r_en_out, wb_en_out, dest_out, alu_res_exe_reg, data_mem_out_exe_reg);
	input clk, rst, mem_r_en, wb_en;
	input [31:0] alu_res, data_mem_out;
	input [3:0] dest_in;
	output reg mem_r_en_out, wb_en_out;
	output reg [3:0] dest_out;
	output reg [31:0] alu_res_exe_reg, data_mem_out_exe_reg;
	
	always@(posedge clk, posedge rst)begin
		if(rst)begin
			mem_r_en_out <= 1'b0;
			wb_en_out <= 1'b0;
			dest_out <= 4'b0000;
			alu_res_exe_reg <= 32'b00000000000000000000000000000000;
			data_mem_out_exe_reg <= 32'b00000000000000000000000000000000;
		end
		else begin
			dest_out <= dest_in;
			wb_en_out <= wb_en;
      			alu_res_exe_reg <= alu_res;
			mem_r_en_out <= mem_r_en;
      			data_mem_out_exe_reg <= data_mem_out;
		end
	end
endmodule