module EXE_Stage (clk, rst, exe_cmd, wb_en_in, mem_r_en_in, mem_w_en_in, pc_in, val_rn, val_rm, imm, shift_operand, imm_signed_24, sr, dest_in, 
		  wb_en, mem_r_en, mem_w_en, alu_result, br_addr, status, val_rm_out, dest);
  
 input clk, rst, wb_en_in, mem_r_en_in, mem_w_en_in, imm;
 input [3:0] exe_cmd;
 input [31:0] pc_in, val_rn, val_rm;
 input [11:0] shift_operand;
 input [23:0]imm_signed_24;
 input [3:0]sr, dest_in;
 output wb_en, mem_r_en, mem_w_en;
 output [31:0] alu_result, br_addr, val_rm_out;
 output [3:0] status, dest;


  wire or_output;
  wire [31:0] val_2;
  assign dest = dest_in;
  assign wb_en = wb_en_in;
  assign val_rm_out = val_rm;
  assign mem_r_en = mem_r_en_in;
  assign mem_w_en = mem_w_en_in;
  assign or_output = mem_w_en_in || mem_r_en_in;
  assign br_addr = ({{8{imm_signed_24[23]}}, {imm_signed_24}} << 2) + pc_in;

  ALU alu(.clk(clk), .rst(rst), .val_1(val_rn), .val_2(val_rm), .exe_cmd(exe_cmd), .sr_in(sr), .alu_result(alu_result), .sr(status));
  Val2Generator val_2_generator (.clk(clk), .rst(rst), .rm(val_rm), .shift_operand(shift_operand), .imm(imm), .select(or_output), .val_2(val_2));

endmodule
