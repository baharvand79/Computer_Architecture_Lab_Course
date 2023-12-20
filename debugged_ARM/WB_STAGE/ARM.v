//`include "stage_IF.v"
//`include "stage_IF_to_ID_register.v"
//`include "stage_ID.v"
//`include "mux_2to1.v"
//`include "stage_ID_to_EX_register.v"
//`include "stage_EXE.v"
//`include "stage_EXE_to_MEM.v"
//`include "stage_MEM.v"
//`include "stage_MEM_to_WB_register.v"
//`include "stage_WB.v"
module ARM(
    input clk, rst
);

    // Hazard
    wire hazard, hazardTwoSrc;
    wire [3:0] status;
    wire [3:0] hazardRn, hazardRdm;
  
    // IF
    wire Branch_taken;
    //assign hazard = 1'b0, Branch_taken = 1'b0;// BranchAddr_if_stage_in = 32'd0; //remove it later
    wire [31:0] BranchAddr;
    wire [31:0] PC_if_stage_out, Instruction_if_stage_out;
    //assign  Branch_taken =  BranchAddr;
    Stage_IF stage_if(
        .clk(clk),
        .rst(rst),
        .freeze(hazard),
        .Branch_taken(Branch_taken),
        .BranchAddr(BranchAddr),
        .PC(PC_if_stage_out),
        .Instruction(Instruction_if_stage_out)
    );
    // IF Register
    wire [31:0] PC_if_to_id_register_out, instruction_if_to_id_register_out;
    Stage_IF_to_ID_Register stage_if_to_id_register(
    .clk(clk), 
    .rst(rst),
    .freeze(hazard), 
    .flush(Branch_taken),
    .pc_in(PC_if_stage_out), 
    .instruction_in(Instruction_if_stage_out),
    .pc_out(PC_if_to_id_register_out),
    .instruction_out(instruction_if_to_id_register_out)
    );
    // ID
    wire [31:0] reg1_id_out, reg2_id_out, pc_id_out;
    wire mem_read_id_out, mem_write_id_out, wb_en_id_out, b_id_out, s_id_out;
    wire imm_id_out;
    wire [11:0] shift_operand_if_out;
    wire signed [23:0] imm24_id_out;
    wire [3:0] Rd_id_out, exe_cmd_id_out;
    wire [3:0] hazardRn_id_out, hazardRm_id_out;
    wire hazard_two_scr_id_out;
    wire [31:0] wbValue;
    Stage_ID stage_id(
    .clk(clk),
    .rst(rst),
    //from if to id register
    .instruction_in(instruction_if_to_id_register_out),
    .pc_in(PC_if_to_id_register_out),
    //from wb
    .Dest_wb(4'd0),
    .Value_wb(wbValue),
    .wb_wb_en(1'b0),
    //from ex
    .status(status),
    //from hazard
    .hazard(hazard),
    //out to next register
    .reg1(reg1_id_out),
    .reg2(reg2_id_out),
    .pc_out(pc_id_out),
    .mem_read_out(mem_read_id_out), 
    .mem_write_out(mem_write_id_out),
    .wb_en_out(wb_en_id_out),
    .b_out(b_id_out),
    .s_out(s_id_out),
    .imm(imm_id_out),
    .shift_operand(shift_operand_if_out),
    .imm24(imm24_id_out),
    .R_destination(Rd_id_out),
    .exe_cmd_out(exe_cmd_id_out),
    // out to hazard
    .hazardRn(hazardRn_id_out),
    .hazardRdm(hazardRm_id_out),
    .hazardTwoSrc(hazard_two_scr_id_out)
    );

    //ID Register
    wire [31:0] reg1_id_ex_reg_out, reg2_id_ex_reg_out, pc_id_ex_reg_out, instruction_id_ex_reg_out;
    wire mem_read_id_ex_reg_out, mem_write_id_ex_reg_out, wb_en_id_ex_reg_out, b_id_ex_reg_out, s_id_ex_reg_out, imm_id_ex_reg_out, carry_id_ex_reg_out;
    wire [3:0] exe_cmd_id_ex_reg_out, dest_id_ex_reg_out;
    wire [11:0] shift_operand_id_ex_reg_out;
    wire [23:0] imm24_id_ex_reg_out;
    wire carry_in;
    Stage_ID_to_EX_Register stage_id_to_ex_register(
    .clk(clk), 
    .rst(rst),
    .pc_in(pc_id_out),
    .reg1_in(reg1_id_out), 
    .reg2_in(reg2_id_out),
    .instruction_in(instruction_if_to_id_register_out),
    .cmd_exe_in(exe_cmd_id_out),
    .mem_read_in(mem_read_id_out),
    .mem_write_in(mem_write_id_out),
    .wb_en_in(wb_en_id_out),
    .b_in(b_id_out),
    .s_in(s_id_out),
    .carry_in(status[1]),
    .flush(Branch_taken),
    .imm_in(imm_id_out),
    .shift_operand_in(shift_operand_if_out),
    .imm24_in(imm24_id_out),
    .dest_in(Rd_id_out),
    .reg1_out(reg1_id_ex_reg_out),
    .reg2_out(reg2_id_ex_reg_out),
    .pc_out(pc_id_ex_reg_out),
    .instruction_out(instruction_id_ex_reg_out),
    .mem_read_out(mem_read_id_ex_reg_out),
    .mem_write_out(mem_write_id_ex_reg_out),
    .wb_en_out(wb_en_id_ex_reg_out),
    .b_out(Branch_taken),
    .s_out(s_id_ex_reg_out),
    .imm_out(imm_id_ex_reg_out),
    .carry_out(carry_id_ex_reg_out),
    .exe_cmd_out(exe_cmd_id_ex_reg_out),
    .shift_operand_out(shift_operand_id_ex_reg_out),
    .imm24_out(imm24_id_ex_reg_out),
    .dest_out(dest_id_ex_reg_out)
    );

    // EXE Stage
    wire [31:0] alu_res;
    Stage_EXE stage_exe(
    .clk(clk),
    .rst(rst),
    .mem_read_en(mem_read_id_ex_reg_out),
    .mem_write_en(mem_write_id_ex_reg_out), 
    .imm(imm_id_ex_reg_out),
    .carry(carry_id_ex_reg_out),
    .s(s_id_ex_reg_out),
    .exe_cmd(exe_cmd_id_ex_reg_out),
    .val1(reg1_id_ex_reg_out),
    .valRm(reg2_id_ex_reg_out), 
    .pc(pc_id_ex_reg_out),
    .shift_operand(shift_operand_id_ex_reg_out),
    .imm_signed_24(imm24_id_ex_reg_out),
    .alu_res(alu_res), 
    .branch_addr(BranchAddr),
    .status(status)
    );

    // EXE REG
    wire wb_en_ex_mem_reg_out, mem_read_en_ex_mem_reg_out, mem_write_en_ex_mem_out;
    wire [31:0] alu_res_ex_mem_reg_out, val_rm_ex_mem_out, instruction_exe_mem_out;
    wire [3:0] dest_ex_mem_out;
    Stage_EXE_to_MEM_Reg stage_exe_to_mem_reg(
    .clk(clk),
    .rst(rst),
    .wb_en_in(wb_en_id_ex_reg_out), 
    .mem_read_en_in(mem_read_id_ex_reg_out),
    .mem_write_en_in(mem_write_id_ex_reg_out),
    .alu_res_in(alu_res),
    .val_rm_in(reg2_id_ex_reg_out),
    .instruction_in(instruction_id_ex_reg_out),
    .dest_in(dest_id_ex_reg_out),
    .wb_en_out(wb_en_ex_mem_reg_out),
    .mem_read_en_out(mem_read_en_ex_mem_reg_out),
    .mem_write_en_out(mem_write_en_ex_mem_out),
    .alu_res_out(alu_res_ex_mem_reg_out),
    .val_rm_out(val_rm_ex_mem_out),
    .instruction_out(instruction_exe_mem_out),
    .dest_out(dest_ex_mem_out)
    );

    //MEM STAGE
    wire [31:0] data_read_out;
    Stage_MEM stage_mem(
    .clk(clk), 
    .rst(rst),
    .wb_en(wb_en_ex_mem_reg_out),
    .mem_read_en(mem_read_en_ex_mem_reg_out),
    .mem_write_en(mem_write_en_ex_mem_out),
    .alu_re_addr(alu_res_ex_mem_reg_out),
    .val_rm(val_rm_ex_mem_out),
    .data_out(data_read_out)
    );

    //MEM REG
    wire wb_en_mem_to_wb_reg_out, mem_read_en_mem_to_wb_reg_out;
    wire [31:0] alu_res_mem_to_wb_reg_out, mem_data_out_mem_ro_wb_reg_out,  instruction_mem_in, instruction_mem_out;
    wire [3:0] dest_mem_to_wb_reg_out;
    Stage_MEM_to_WB_Register stage_MEM_to_WB_register(
    .clk(clk), 
    .rst(rst),
    .wbEnIn(wb_en_ex_mem_reg_out),
    .memREnIn(mem_read_en_ex_mem_reg_out),
    .aluResIn(alu_res_ex_mem_reg_out),
    .memDataIn(val_rm_ex_mem_out),
    .destIn(dest_ex_mem_out),
    .wbEnOut(wb_en_mem_to_wb_reg_out),
    .memREnOut(mem_read_en_mem_to_wb_reg_out),
    .aluResOut(alu_res_mem_to_wb_reg_out),
    .memDataOut(mem_data_out_mem_ro_wb_reg_out),
    .destOut(dest_mem_to_wb_reg_out),
    .instruction_in(instruction_mem_in),
    .instruction_out(instruction_mem_out)
    );

    // WB STAGE
    Stage_WB stage_wb(
    .clk(clk),
    .rst(rst),
    .memREn(mem_read_en_mem_to_wb_reg_out),
    .aluRes(alu_res_mem_to_wb_reg_out),
    .memData(mem_data_out_mem_ro_wb_reg_out),
    .wbValue(wbValue)
    );

    //Hazard
//    hazard_unit hazard_unit(
//        .rn(hazardRn), .rdm(hazardRdm),
//        .twoSrc(hazardTwoSrc),
//        .destEx(destOutEx), .destMem(destOutMem),
//        .wbEnEx(wbEnOutEx), .wbEnMem(wbEnOutMem),
//        .hazard(hazard)
//    );

    hazard_unit  hazard_unit(.exe_wb_en(destOutEx), .src_1(hazardRn), .src_2(hazardRdm), 
	.exe_dest(destOutEx), .mem_dest(destOutMem), .instruction_exe(instruction_exe_mem_out), 
	.instruction_mem(instruction_mem_out), .mem_wb_en(wbEnOutMem),
	.two_src(hazardTwoSrc),  .hazard_detected(hazard)
    );
endmodule