
module ARM(clk, rst);
	input clk, rst;

	wire  freeze = 1'b0, Branch_Tacken = 1'b1, flush = 1'b0, hazard = 1'b0, WB_WB_EN = 1'b0;
	wire [31:0] Branch_Address; 
	wire [31:0]  Instruction, pc_out, pc, Instruction_reg;
	wire [3:0] StatusRegister_input = 4'b0000; //later
	wire [31:0] WB_Value = 32'd0;
	wire [31:0] Val_Rm, Val_Rn;
	wire [3:0] EXE_CMD, Dest, Dest_ID_Reg, StatusRegister_ID_Reg;
	wire MEM_R_EN, MEM_W_EN, WB_EN, S, B;
	wire Two_src, mux_for_hazard;
	wire [31:0] pc_ID, PC_ID_REG, Val_Rn_ID_REG, Val_Rm_ID_REG, ALU_Result, val_rm_out_EXE;
    	wire [23:0] Signed_imm_24, Signed_imm_24_ID_reg;
    	wire [11:0] Shift_operand, shift_operand_ID_reg;
    	wire imm, imm_ID_reg, WB_EN_EXE, MEM_R_EN_EXE, MEM_W_EN_EXE;
	wire WB_EN_ID_REG, MEM_W_EN_ID_REG, MEM_R_EN_ID_REG, B_ID_REG, S_ID_REG;
	wire [3:0] EXE_CMD_ID_REG, StatusRegister_output, status_bits, Dest_EXE;

	IF_Stage if_stage(.clk(clk), .rst(rst), .freeze(freeze), .Branch_Tacken(Branch_Tacken), .Branch_Address(Branch_Address), 
			.Instruction(Instruction), .adder_o(pc_out));

	IF_Stage_Reg if_stage_reg(.clk(clk), .rst(rst), .pc_in(pc_out), .instruction_in(Instruction),  .flush(flush), .freeze(freeze),
			 .pc(pc), .instruction(Instruction_reg));
  
	ID_Stage id_stage(.clk(clk), .rst(rst), .StatusRegister_input(StatusRegister_input), .hazard(hazard), .WB_WB_EN(WB_WB_EN),
			 .WB_Dest(Instruction[15:12]), .WB_Value(WB_Value), .instruction(Instruction_reg), .PC_in(pc),
			.Val_Rm(Val_Rm), .Val_Rn(Val_Rn), .EXE_CMD(EXE_CMD), .MEM_R_EN(MEM_R_EN), .MEM_W_EN(MEM_W_EN), .WB_EN(WB_EN),
			 .S(S), .B(B), .Two_src(Two_src), .mux_for_hazard(mux_for_hazard), .Dest(Dest), .Signed_imm_24(Signed_imm_24), 
			.Shift_operand(Shift_operand), .imm(imm), .PC_out(pc_ID), .StatusRegister_output(StatusRegister_output));

	ID_Stage_Reg id_stage_reg(.clk(clk), .rst(rst), .wb_en_in(WB_EN), .mem_r_en_in(MEM_R_EN), .mem_w_en_in(MEM_W_EN), 
				.exe_cmd_in(EXE_CMD), .b_in(B), .s_in(S), .pc_in(pc_ID), .value_rn_in(Val_Rn), .value_rm_in(Val_Rm),
				 .shift_operand_in(Shift_operand), .imm_in(imm), .imm_signed_24_in(Signed_imm_24), .dest_in(Dest),
				 .src_1_in(Instruction_reg[19:16]), .src_2_in(Instruction_reg[15:12]), .flush(flush), .sr_in(StatusRegister_output),
  				.wb_en(WB_EN_ID_REG), .mem_r_en(MEM_R_EN_ID_REG), .mem_w_en(MEM_W_EN_ID_REG), .exe_cmd(EXE_CMD_ID_REG), 
				.b(B_ID_REG), .s(S_ID_REG), .pc(PC_ID_REG), .value_rn(Val_Rn_ID_REG), .value_rm(Val_Rm_ID_REG), 
				.shift_operand(shift_operand_ID_reg), .imm(imm_ID_reg), .imm_signed_24(Signed_imm_24_ID_reg),
				 .dest(Dest_ID_Reg), .sr(StatusRegister_ID_Reg), .src_1(), .src_2());// later src


	EXE_Stage exe_stage(.clk(clk), .rst(rst), .exe_cmd(EXE_CMD_ID_REG) , .wb_en_in(WB_EN_ID_REG), .mem_r_en_in(MEM_R_EN_ID_REG),
		 .mem_w_en_in(MEM_W_EN_ID_REG), .pc_in(PC_ID_REG), .val_rn(Val_Rn_ID_REG), .val_rm(Val_Rm_ID_REG),
		 .imm(imm_ID_reg), .shift_operand(shift_operand_ID_reg), .imm_signed_24(Signed_imm_24_ID_reg), .sr(StatusRegister_ID_Reg), 
		 .dest_in(Dest_ID_Reg), .wb_en(WB_EN_EXE), .mem_r_en(MEM_R_EN_EXE), .mem_w_en(MEM_W_EN_EXE), .alu_result(ALU_Result),
		 .br_addr(Branch_Address), .status(status_bits), .val_rm_out(val_rm_out_EXE), .dest(Dest_EXE));

endmodule