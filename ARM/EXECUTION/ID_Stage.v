module ID_Stage(clk, rst, StatusRegister_input, hazard, WB_WB_EN, WB_Dest, WB_Value, instruction, PC_in,
		Val_Rm, Val_Rn, EXE_CMD, MEM_R_EN, MEM_W_EN, WB_EN, S, B, Two_src, mux_for_hazard,
		Dest, Signed_imm_24, Shift_operand, imm, PC_out, StatusRegister_output);
    input clk, rst;
    input [3:0] StatusRegister_input, WB_Dest;
    input hazard;
    input WB_WB_EN;
    input [31:0] instruction, WB_Value;
    input [31:0] PC_in;
    output [31:0] Val_Rm, Val_Rn;
    output [3:0] EXE_CMD;
    output MEM_R_EN, MEM_W_EN, WB_EN, S, B;
    output Two_src;
    output mux_for_hazard;
    output [3:0] Dest;
    output [23:0] Signed_imm_24;
    output [11:0] Shift_operand;
    output imm;
    output [31:0] PC_out;
    output [3:0] StatusRegister_output;

    wire [3:0] Rm, Rd, Rn, OP_Code, Cond;
    wire S_input, I, or_cond;
    wire [1:0] Mode;
    wire [3:0] register_file_rd;
    //wire [31:0] registers [0:14];

    
    // rn = 19-16 src1
    assign Rm = instruction[3:0];
    assign Rd = instruction[15:12];
    assign Rn = instruction[19:16];
    assign S_input = instruction[20];
    assign OP_Code = instruction[24:21];
    assign I = instruction[25]; //I
    assign Mode = instruction[27:26];
    assign Cond = instruction[31:28];

    //MUX REGISTER FILE
    assign register_file_rd = MEM_W_EN ? Rd : Rm;
    wire [31:0] reg_1, reg_2;
    assign Val_Rm = reg_1;
    assign Val_Rn = reg_2;

    RegisterFile register_file(.clk(clk), .rst(rst), .write_back_en(WB_WB_EN), .src_1(Rn), .src_2(register_file_rd), .dest_wb(WB_Dest), 
				.result_wb(WB_Value), .reg1(reg_1), .reg2(reg_2));
    
    ConditionCheck condition_check(.Cond(Cond), .StatusRegister_output(StatusRegister_input), .out(condition_check_out));
    
    assign or_cond = ~condition_check_out || hazard;

    ControlUnit control_unit(.mode(Mode), .op_code(OP_Code), .s_in(S_input), .exe_cmd(EXE_CMD), .mem_r_en(MEM_R_EN), .mem_w_en(MEM_W_EN), 
				.wb_en(WB_EN), .s(S), .b(B));

    //MUX CONTROL UNIT
    assign control_unit_mux_out = or_cond ? {S_input, EXE_CMD, MEM_R_EN, MEM_W_EN, WB_EN, S} : 9'b000000000;

    //OR HAZARD
    assign Two_src = MEM_W_EN || (~I);

    assign mux_for_hazard = register_file_rd;
    assign Dest = instruction[15:12];
    assign Signed_imm_24 = instruction[23:0];
    assign Shift_operand = instruction[11:0];
    assign imm = I;
    assign PC_out = PC_in;
    assign StatusRegister_output = StatusRegister_input;
    
endmodule
