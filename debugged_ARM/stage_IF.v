`include "mux_2to1.v"
`include "adder.v"
`include "pc.v"
`include "instruction_memory.v"
module Stage_IF (
    input clk, rst, freeze, Branch_taken,
    input [31:0] BranchAddr,
    output [31:0] PC, Instruction
);
    wire [31:0] pc_reg_in, pc_reg_out, pc_adder_out;
    assign PC = pc_adder_out;
    PC pc(
        .clk(clk),
        .rst(rst),
        .freeze(freeze),
        .in(pc_reg_in),
        .out(pc_reg_out)
    );
    Adder adder(
        .x0(pc_reg_out),
        .x1(32'd4),
        .res(pc_adder_out)

    );
    Instruction_memory instruction_memory(
    .clk(clk),
    .rst(rst), 
    .PC(pc_reg_out), 
    .Instruction(Instruction)
    );
    MUX_2to1 mux(
        .x0(pc_adder_out),
        .x1(BranchAddr),
        .sel(Branch_taken),
        .res(pc_reg_in)
    );

endmodule