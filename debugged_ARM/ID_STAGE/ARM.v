`include "stage_IF.v"
`include "stage_IF_to_ID_register.v"
`include "stage_ID.v"
`include "mux_2to1.v"
module ARM(
    input clk, rst
);
    // IF
    wire hazard, Branch_taken;
    assign hazard = 1'b0, Branch_taken = 1'b0, BranchAddr_if_stage_in = 32'd0; //remove it later
    wire [31:0] BranchAddr_if_stage_in;
    wire [31:0] PC_if_stage_out, Instruction_if_stage_out;
    Stage_IF stage_if(
        .clk(clk),
        .rst(rst),
        .freeze(hazard),
        .Branch_taken(Branch_taken),
        .BranchAddr(BranchAddr_if_stage_in),
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
    Stage_ID stage_id(
    .clk(clk),
    .rst(rst),
    //from if to id register
    .instruction_in(instruction_if_to_id_register_out),
    .pc_in(PC_if_to_id_register_out),
    //from wb
    .Dest_wb(4'd0),
    .Value_wb(0),
    .wb_wb_en(1'b0),
    //from ex
    .status(4'd0),
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
endmodule