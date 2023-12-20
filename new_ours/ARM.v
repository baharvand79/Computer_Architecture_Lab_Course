`include "IF_Stage.v"
`include "IF_Stage_Reg.v"
`include "ID_Stage.v"
`include "ID_Stage_Reg.v"
`include "EXE_Stage.v"
`include "EXE_Stage_Reg.v"
`include "Data_Memory.v"
`include "Data_Memory_Reg.v"
`include "StatusRegister .v"
`include "Hazard_Detection_Unit.v"
module ARM(clk, rst);
	input clk, rst;

	wire  freeze, Branch_Tacken, flush, hazard;
	//wire WB_WB_EN = 1'b0;
	wire [31:0] Branch_Address, instruction_mem; 
	wire [31:0]  Instruction, pc_out, pc, Instruction_reg;
	wire [3:0] StatusRegister_input; 
	wire [31:0] WB_Value, instruction_id, instruction_id_reg, instruction_exe, instruction_exe_reg;
	//wire [31:0] WB_Value = 32'd0;
	wire [31:0] Val_Rm, Val_Rn, val_rm_out_EXE_Reg, data_mem_out, DataMem_Mem_Reg;
	wire [3:0] EXE_CMD, Dest, Dest_ID_Reg, StatusRegister_ID_Reg, Dest_EXE_Reg, Rn, src_1_reg, src_2_reg,StatusRegister_output_1;
	wire MEM_R_EN, MEM_W_EN, WB_EN, S, B;
	wire Two_src, mux_for_hazard;
	wire [31:0] pc_ID, PC_ID_REG, Val_Rn_ID_REG, Val_Rm_ID_REG, ALU_Result, val_rm_out_EXE, ALU_Result_EXE_REG, alu_res_mem_reg;
    wire [23:0] Signed_imm_24, Signed_imm_24_ID_reg;
    wire [11:0] Shift_operand, shift_operand_ID_reg;
    wire imm, imm_ID_reg, WB_EN_EXE, MEM_R_EN_EXE, MEM_W_EN_EXE, MEM_R_EN_MEM_REG;
	wire WB_EN_ID_REG, MEM_W_EN_ID_REG, MEM_R_EN_ID_REG, B_ID_REG, S_ID_REG, WB_EN_EXE_REG, MEM_R_EN_EXE_REG, MEM_W_EN_EXE_REG, WB_EN_MEM_REG;
	wire [3:0] EXE_CMD_ID_REG, StatusRegister_output, status_bits, Dest_EXE, Dest_Mem_Reg, src_1, src_2;

	assign Rn = Instruction_reg[19:16];
    assign freeze = hazard;
	// assign freeze = 0;
	// assign Branch_Tacken = 0;
    assign Branch_Tacken = B_ID_REG;
    assign flush = Branch_Tacken;
    assign StatusRegister_input = StatusRegister_output_1;

	IF_Stage if_stage(.clk(clk), .rst(rst), .freeze(freeze), .Branch_Tacken(Branch_Tacken), .Branch_Address(Branch_Address), 
			.Instruction(Instruction), .adder_o(pc_out));

	IF_Stage_Reg if_stage_reg(.clk(clk), .rst(rst), .pc_in(pc_out), .instruction_in(Instruction),  .flush(flush), .freeze(freeze),
			 .pc(pc), .instruction(Instruction_reg));
  
	ID_Stage id_stage(.clk(clk), .rst(rst), .StatusRegister_input(StatusRegister_input), .hazard(hazard), .WB_WB_EN(WB_EN_MEM_REG),
			 .WB_Dest(Dest_EXE_Reg), .WB_Value(WB_Value), .instruction(Instruction_reg), .PC_in(pc),
			.Val_Rm(Val_Rm), .Val_Rn(Val_Rn), .EXE_CMD(EXE_CMD), .MEM_R_EN(MEM_R_EN), .MEM_W_EN(MEM_W_EN), .WB_EN(WB_EN),
			 .S(S), .B(B), .Two_src(Two_src), .mux_for_hazard(mux_for_hazard), .Dest(Dest), .Signed_imm_24(Signed_imm_24), 
			.Shift_operand(Shift_operand), .imm(imm), .PC_out(pc_ID), .StatusRegister_output(StatusRegister_output),
			.src_1(src_1), .src_2(src_2), .instruction_out(instruction_id));

	ID_Stage_Reg id_stage_reg(.clk(clk), .rst(rst), .wb_en_in(WB_EN), .mem_r_en_in(MEM_R_EN), .mem_w_en_in(MEM_W_EN),
				.exe_cmd_in(EXE_CMD), .b_in(B), .s_in(S), .pc_in(pc_ID), .value_rn_in(Val_Rn), .value_rm_in(Val_Rm),
				 .shift_operand_in(Shift_operand), .imm_in(imm), .imm_signed_24_in(Signed_imm_24), .dest_in(Dest),
				 .src_1_in(src_1), .src_2_in(src_2), .flush(flush), .sr_in(StatusRegister_output),
  				.wb_en(WB_EN_ID_REG), .mem_r_en(MEM_R_EN_ID_REG), .mem_w_en(MEM_W_EN_ID_REG), .exe_cmd(EXE_CMD_ID_REG), 
				.b(B_ID_REG), .s(S_ID_REG), .pc(PC_ID_REG), .value_rn(Val_Rn_ID_REG), .value_rm(Val_Rm_ID_REG), 
				.shift_operand(shift_operand_ID_reg), .imm(imm_ID_reg), .imm_signed_24(Signed_imm_24_ID_reg),
				 .dest(Dest_ID_Reg), .sr(StatusRegister_ID_Reg), .src_1(src_1_reg), .src_2(src_2_reg), 
				.instruction_in(instruction_id), .instruction_out(instruction_id_reg));


	EXE_Stage exe_stage(.clk(clk), .rst(rst), .exe_cmd(EXE_CMD_ID_REG) , .wb_en_in(WB_EN_ID_REG), .mem_r_en_in(MEM_R_EN_ID_REG),
		 .mem_w_en_in(MEM_W_EN_ID_REG), .pc_in(PC_ID_REG), .val_rn(Val_Rn_ID_REG), .val_rm(Val_Rm_ID_REG),
		 .imm(imm_ID_reg), .shift_operand(shift_operand_ID_reg), .imm_signed_24(Signed_imm_24_ID_reg), .sr(StatusRegister_ID_Reg), 
		 .dest_in(Dest_ID_Reg), .wb_en(WB_EN_EXE), .mem_r_en(MEM_R_EN_EXE), .mem_w_en(MEM_W_EN_EXE), .alu_result(ALU_Result),
		 .br_addr(Branch_Address), .status(status_bits), .val_rm_out(val_rm_out_EXE), .dest(Dest_EXE), 
		.instruction_in(instruction_id_reg), .instruction_out(instruction_exe));


	EXE_Stage_Reg exe_stage_reg(.clk(clk), .rst(rst), .wb_en_in(WB_EN_EXE), .mem_r_en_in(MEM_R_EN_EXE), .mem_w_en_in(MEM_W_EN_EXE), 
				    .alu_res_in(ALU_Result), .dest_in(Dest_EXE), .val_rm_in(val_rm_out_EXE), .wb_en_out(WB_EN_EXE_REG), 
				     .mem_r_en_out(MEM_R_EN_EXE_REG), .mem_w_en_out(MEM_W_EN_EXE_REG), .alu_result_out(ALU_Result_EXE_REG),
				     .dest_out(Dest_EXE_Reg), .val_rm_out(val_rm_out_EXE_Reg), .instruction_in(instruction_exe), .instruction_out(instruction_exe_reg));

	Data_Memory data_mem(.clk(clk), .rst(rst), .mem_r_en(MEM_R_EN_EXE_REG), .mem_w_en(MEM_W_EN_EXE_REG), .val_rm(val_rm_out_EXE_Reg), 
				.alu_res(ALU_Result_EXE_REG), .Data_Memory_Output(data_mem_out), .instruction_in(instruction_exe_reg), .instruction_out(instruction_mem));

	Data_Memory_Reg data_memory_reg(.clk(clk), .rst(rst), .mem_r_en(MEM_R_EN_EXE_REG), .wb_en(WB_EN_EXE_REG), .alu_res(ALU_Result_EXE_REG), 
					.data_mem_out(data_mem_out), .mem_r_en_out(MEM_R_EN_MEM_REG), .wb_en_out(WB_EN_MEM_REG), .dest_out(Dest_Mem_Reg), 
					.alu_res_exe_reg(alu_res_mem_reg), .data_mem_out_exe_reg(DataMem_Mem_Reg), .dest_in(Dest_EXE_Reg));

    StatusRegister statusreg(.clk(clk), .rst(rst), .s(S_ID_REG), .in(status_bits), .out(StatusRegister_output_1));

	// //WB_Stage
	//mux2to1 Write_Back_Stage(.sel(MEM_R_EN_MEM_REG), .x0(alu_res_mem_reg), .x1(DataMem_Mem_Reg), .y(WB_Value));
	assign WB_Value = MEM_R_EN_MEM_REG? DataMem_Mem_Reg: alu_res_mem_reg;


	Hazard_Detection_Unit hazard_unit(.src_1(src_1_reg), .src_2(src_2_reg), .exe_dest(Dest_EXE), .exe_wb_en(WB_EN_EXE),
                               .mem_dest(Dest_Mem_Reg), .mem_wb_en(WB_EN_EXE_REG), .two_src(Two_src), .hazard_detected(hazard),
				.instruction_exe(instruction_exe), .instruction_mem(instruction_mem));
	//assign hazard = 1'b0;
	

endmodule