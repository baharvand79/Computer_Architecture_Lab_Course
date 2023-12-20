
module EXE_Stage_Reg(clk, rst, wb_en_in, mem_r_en_in, mem_w_en_in, alu_res_in,
  		dest_in, val_rm_in, wb_en_out, mem_r_en_out, mem_w_en_out, alu_result_out, val_rm_out, dest_out, instruction_in, instruction_out);

  input clk, rst ,wb_en_in, mem_r_en_in, mem_w_en_in;
  input [31:0] alu_res_in, val_rm_in, instruction_in;
  input [3:0] dest_in;
  output reg wb_en_out, mem_r_en_out, mem_w_en_out;
  output reg [31:0] alu_result_out, val_rm_out;
  output [31:0]instruction_out;
  output reg [3:0] dest_out;

	assign instruction_out = instruction_in;

  always @ (posedge clk, posedge rst) begin
    if (rst) begin      
	val_rm_out <= 32'b00000000000000000000000000000000;
	alu_result_out <= 32'b00000000000000000000000000000000;
	dest_out <= 4'b0000;
	wb_en_out <= 1'b0;
	mem_w_en_out <= 1'b0; 
	mem_r_en_out <= 1'b0;
    end else begin
	val_rm_out <= val_rm_in; 
	wb_en_out <= wb_en_in;
	dest_out <= dest_in;
	mem_r_en_out <= mem_r_en_in;
	mem_w_en_out <= mem_w_en_in;
	alu_result_out <= alu_res_in;
    end
  end
  
endmodule
