
module ARM(clk, rst);
	IF_Stage if_stage(.clk(clk), .rst(rst), freeze, Branch_Tacken, Branch_Address, Instruction);
wire  freeze = 1'b0, Branch_Tacken = 1'b1;
wire [31:0] Branch_Address; //later
wire [31:0]  Instruction;



	IF_Stage_Reg if_stage_reg(.clk(), .rst(), input [31:0]pc_in, instruction_in,  adder_o);
  input flush, freeze, output reg [31:0] pc, instruction);
	ID_Stage id_stage(.clk(clk), .rst(rst), .StatusRegister_input(), .hazard(), .WB_WB_EN(), .WB_Dest(), .WB_Value(), .instruction(), .PC_in(),
		.Val_Rm(), .Val_Rn(), .EXE_CMD(), MEM_R_EN, MEM_W_EN, WB_EN, S, B, Two_src, mux_for_hazard,
		Dest, Signed_imm_24, Shift_operand, imm, PC_out, StatusRegister_output);


 
    input [3:0] StatusRegister_input, WB_Dest;
    input hazard;
    input WB_WB_EN;
    input [31:0] instruction, WB_Value;
    input [31:0] PC_in;
    output Val_Rm, Val_Rn;
    output [3:0] EXE_CMD;
    output MEM_R_EN, MEM_W_EN, WB_EN, S, B;
    output Two_src;
    output mux_for_hazard;
    output [3:0] Dest;
    output [23:0] Signed_imm_24;
    output [11:0] Shift_operand;
    output imm;
    output [31:0] PC_out;
    output StatusRegister_output;

endmodule