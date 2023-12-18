`include "ALU.v"
`include "Val2Generator.v"
module EXE_Stage (clk, rst, exe_cmd, wb_en_in, mem_r_en_in, mem_w_en_in, pc_in, val_rn, val_rm, imm, shift_operand, imm_signed_24, sr, dest_in, 
		  wb_en, mem_r_en, mem_w_en, alu_result, br_addr, status, val_rm_out, dest, instruction_in, instruction_out);
  
 input clk, rst, wb_en_in, mem_r_en_in, mem_w_en_in, imm;
 input [3:0] exe_cmd;
 input [31:0] pc_in, val_rn, val_rm, instruction_in;
 input [11:0] shift_operand;
 input [23:0]imm_signed_24;
 input [3:0]sr, dest_in;
 output wb_en, mem_r_en, mem_w_en;
 output [31:0] alu_result, br_addr, val_rm_out, instruction_out;
 output [3:0] status, dest;


  wire or_output;
  wire [31:0] val_2;
  assign dest = dest_in;
  assign wb_en = wb_en_in;
  assign val_rm_out = val_rm;
  assign mem_r_en = mem_r_en_in;
  assign mem_w_en = mem_w_en_in;
  assign or_output = mem_w_en_in || mem_r_en_in;
  assign br_addr = {{(6){imm_signed_24[23]}}, imm_signed_24, 2'b0} + pc_in;
// module ALU #(
//     parameter N = 32
// )(
//     input [N-1:0] a, b,
//     // input carryIn,
//     input [3:0] exeCmd,
//     output reg [N-1:0] out,
//     output [3:0] status
// );
  ALU alu(.a(val_rn), .b(val_2), .exeCmd(exe_cmd), .out(alu_result), .status(status));
  Val2Generator val_2_generator (.val_Rm(val_rm), .shifter_operand(shift_operand), .I(imm), .mem_en(or_output), .out(val_2));
  assign instruction_out = instruction_in;
endmodule
