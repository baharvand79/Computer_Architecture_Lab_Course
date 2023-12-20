`include "val2_generator.v"
`include "status_register.v"
// `include "adder.v"
`include "alu.v"
module Stage_EXE(
    input clk, rst, mem_read_en, mem_write_en, imm, carry, s,
    input [3:0] exe_cmd,
    input [31:0] val1, valRm, pc,
    input [11:0] shift_operand,
    input signed [23:0] imm_signed_24,
    output [31:0] alu_res, branch_addr,
    output [3:0] status
);

    wire [31:0] val2; 
    Val2Generator val2generator(
    .memInst(mem_read_en | mem_write_en),
    .imm(imm),
    .valRm(valRm),
    .shift_operand(shift_operand),
    .val2(val2)
    );

    wire [3:0] status_in;
    StatusRegister #(4) status_register(
    .clk(clk),
    .rst(rst),
    .in(status_in),
    .ld(s),
    .clr(1'b0),
    .out(status)
    );

    ALU alu(
    .a(val1),
    .b(val2),
    .carryIn(carry),
    .exeCmd(exe_cmd),
    .out(alu_res),
    .status(status_in)
    );

    wire [31:0] imm24SignExt;
    assign imm24SignExt = {{6{imm_signed_24[23]}}, imm_signed_24, 2'b00};

    Adder branch_calculator(
        .x0(pc),
        .x1(imm24SignExt),
        .res(branch_addr)
    );
endmodule