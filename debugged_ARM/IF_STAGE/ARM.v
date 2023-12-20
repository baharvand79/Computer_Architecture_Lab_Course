`include "stage_IF.v"
`include "stage_IF_to_ID_register.v"
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
endmodule