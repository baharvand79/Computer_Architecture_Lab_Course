module ID_Stage(clk, rst, instruction, WB_data, WB_en, WB_destination, hazard, status_reg,
  		WB_en_out, mem_read_out, mem_write_out, branch, s_out, EXE_cmd, Val_Rn, 
  		Val_Rm, imm_out, shift_operand, signed_immediate, dest_reg, src1, src2,
  		one_src, two_src);

  input clk, rst, hazard, WB_en;
  input [31:0] instruction, WB_data;
  input [3:0] WB_destination, status_reg;
  output mem_read_out, mem_write_out, WB_en_out, branch, s_out, one_src, two_src, imm_out;
  output [3:0] EXE_cmd, dest_reg, src1, src2;
  output [11:0] shift_operand;
  output [23:0] signed_immediate;
  output [31:0] Val_Rn, Val_Rm;

  wire mem_write, condition_check_result;
  wire controller_mux_sel;
  wire [8:0] controller_out, final_control_signals;
  
  assign src1 = instruction[19:16];
  
  MUX #(.len(4)) src2_mux(.in0(instruction[3:0]), .in1(instruction[15:12]), .sel(mem_write), .out(src2));
  
  MUX #(.len(9)) controller_mux(.in0(controller_out), .in1(9'd0), .sel(controller_mux_sel), .out(final_control_signals));


  Register_File reg_file(.clk(clk), .rst(rst), .reg_write(WB_en), .src1(src1), .src2(src2), .reg_dest(WB_destination), .data(WB_data), .reg1(Val_Rn), .reg2(Val_Rm));

  Control_Unit control_unit(.S(instruction[20]), .mode(instruction[27:26]), .opcode(instruction[24:21]), 
    .one_input(one_src), .controller_out(controller_out));

  Condition_Check condition_check(.cond(instruction[31:28]), .status_regs(status_reg), .cond_res(condition_check_result));

  assign {EXE_cmd, mem_read, mem_write, WB_en_out, branch, s_out} = final_control_signals;
  assign mem_read_out = mem_read;
  assign mem_write_out = mem_write;
  assign imm_out = instruction[25];
  assign shift_operand = instruction[11:0];
  assign signed_immediate = instruction[23:0];
  assign dest_reg = instruction[15:12]; 
  assign two_src = ~imm_out | WB_en;
  assign controller_mux_sel = (~condition_check_result) | hazard;  


  endmodule