//`include "register_file.v"
//`include "control_unit.v"
//`include "condition_check.v"
module Stage_ID(
    input clk, rst,
    //from if to id register
    input [31:0] instruction_in, pc_in,
    //from wb
    input [3:0] Dest_wb,
    input [31:0] Value_wb,
    input wb_wb_en,
    //from ex
    input [3:0] status,
    //from hazard
    input hazard,
    //out to next register
    output [31:0] reg1, reg2, pc_out,
    output mem_read_out, mem_write_out, wb_en_out, b_out, s_out, imm,
    output [11:0] shift_operand,
    output signed [23:0] imm24,
    output [3:0] R_destination,
    output [3:0] exe_cmd_out,
    // out to hazard
    output [3:0] hazardRn, hazardRdm,
    output hazardTwoSrc
);
    //global 
    assign pc_out = pc_in;
    assign shift_operand = instruction_in[11:0];
    assign imm24 = instruction_in[23:0];
    wire [3:0] Rm;
    assign Rm = instruction_in[3:0];
    assign R_destination = instruction_in[15:12];
    assign imm = instruction_in[25];
    assign hazardRn = instruction_in[19:16];
    // ----------------------------------------------------------
    //register file
    wire [3:0] src1;
    assign src1 = instruction_in[19:16]; //src1 = rn
    wire [3:0] src2;
    
    wire [31:0] regRn, regRm;
    Register_File register_file(
        .clk(clk),
        .rst(rst),
        .src1(src1),
        .src2(src2),
        .Dest_wb(Dest_wb),
        .Result_wb(Value_wb),
        .writeBack_en(wb_wb_en),
        .reg1(regRn),
        .reg2(regRm)
    );

    //control unit
    wire mem_read, mem_write, wb_en, b, s;
    wire [3:0] exe_cmd;
    wire s_in;
    assign s_in = instruction_in[20];
    wire [3:0] op_code;
    assign op_code = instruction_in[24:21];
    wire [1:0] mode;
    assign mode = instruction_in[27:26];
    Control_Unit control_unit(    
    .mode(mode),
    .op_code(op_code),
    .s_in(s_in),
    .exe_cmd(exe_cmd),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .wb_en(wb_en),
    .b(b),
    .s_out(s)
    );


     MUX_2to1 #(4) mux_src2(
        .x0(Rm),
        .x1(R_destination),
        .sel(mem_write),
        .res(src2)
    );

    //condition check
    wire [3:0] cond;
    assign cond = instruction_in[31:28];
    wire cond_result;
    Condition_Check condition_check(
    .cond(cond),
    .status(status),
    .result(cond_result)
    );

    // X  OUTPUT FOR REGISTER FILE 15 //~~~~~~~~~~~~~~~HERE!!!!!
    MUX_2to1 Rn15(
        .x0(regRn),
        .x1(pc_in),
        .sel(&src1),
        .res(reg1)
    );
    MUX_2to1 Rm15(
        .x0(regRm),
        .x1(pc_in),
        .sel(&src2),
        .res(reg2)
    );

    //global
    assign hazardTwoSrc = ~imm | mem_write;
    wire final_condition;
    assign final_condition = ~cond || hazard;
    MUX_2to1 #(9) mx(
        .x0({exe_cmd, mem_read, mem_write, wb_en, b, s}),
        .x1(9'd0),
        .sel(final_condition),
        .res({exe_cmd_out, mem_read_out, mem_write_out, wb_en_out, b_out, s_out})
    );
endmodule