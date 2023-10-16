module IF_Stage (input clk, rst, Branch_tacken, input [31:0]BranchAddr, output [31:0]PC, Instruction);
  
  wire [31:0] switch, pc_out;
  
  assign pc = pc_out + 4;
  assign switch = branch_tacken ? branch_address : pc;
  
  PC pc_reg (clk, rst, switch, freeze, pc_out);
  Instruction_mem instruction_memory (clk, rst, pc_out, instruction);

endmodule