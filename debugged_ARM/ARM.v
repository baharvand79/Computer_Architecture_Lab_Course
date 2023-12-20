`include "stage_IF.v"
module ARM(
    input clk, rst
);
    //IF
    wire hazard_if_stage_in, Branch_Tacken_if_stage_in;
    assign hazard_if_stage_in = 1'b0, Branch_Tacken_if_stage_in = 1'b0, BranchAddr_if_stage_in = 32'd0; //remove it later
    wire [31:0] BranchAddr_if_stage_in;
    wire [31:0] PC_if_stage_out, Instruction_if_stage_out;
    Stage_IF stage_if(
        .clk(clk),
        .rst(rst),
        .freeze(hazard_if_stage_in),
        .Branch_taken(Branch_Tacken_if_stage_in),
        .BranchAddr(BranchAddr_if_stage_in),
        .PC(PC_if_stage_out),
        .Instruction(Instruction_if_stage_out)
    );
endmodule