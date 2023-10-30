`include "IF_Stage.v"
`include "IF_Stage_Reg.v"
module ARM(clk, rst, freeze, flush, Branch_Tacken, Branch_Addres, PC, Instruction);
    input clk, rst, freeze, flush, Branch_Tacken;
    input [31:0] Branch_Addres;
    wire [31:0] pc, instruction;
    output [31:0] PC, Instruction;
    IF_Stage if_stage(.clk(clk), .rst(rst), .freeze(freeze), .Branch_Tacken(Branch_Tacken), .Branch_Address(Branch_Address), .pc(pc), .Instruction(instruction));
    IF_Stage_Reg if_stage_reg(.clk(clk), .rst(rst), .freeze(freeze), .flush(flush), .PC_in(pc), .Instruction_in(instruction), .PC(PC), .Instruction(Instruction));
endmodule




