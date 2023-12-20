`include "PC.v"
`include "adder.v"
`include "Instruction_memory.v"
module IF_Stage(clk, rst, freeze, Branch_Tacken, Branch_Address, Instruction, adder_o);
input clk, rst, freeze, Branch_Tacken;
input [31:0] Branch_Address;
output [31:0]  Instruction;
output [31:0] adder_o;
wire [31:0] pc_in, pc_out, adder_o;

//mux2to1 mux_IF(.sel(Branch_Tacken), .x0(Branch_Address), .x1(adder_o), .y(pc_in));
//mux_IF
assign pc_in = Branch_Tacken? Branch_Address: adder_o;
PC pc(.clk(clk), .rst(rst), .freeze(freeze), .in(pc_in), .out(pc_out));
//assign adder_o = pc_out;
//assign Instruction = pc_out;
adder adder_IF(.x0(pc_out), .x1(32'd4), .y(adder_o));
Instruction_memory IM(.clk(clk), .rst(rst), .PC(pc_out), .Instruction(Instruction));
endmodule
