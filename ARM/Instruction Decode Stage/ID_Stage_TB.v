
module ID_Stage_TB();
	reg clk = 1'b0;
   	reg rst = 1'b0;
	reg [3:0] StatusRegister_input = 4'b1111;
	reg [3:0] WB_Dest = 4'b0000;
    	reg hazard = 1'b0;
    	reg WB_WB_EN = 1'b0;
        reg [31:0] WB_Value = 32'd0;
    	//reg [31:0] instruction = 32'b1110_00_0_0100_1_0010_0011_000000000010; //ADDS R3 ,R2,R2 //R3 = -2147483648; 
    	reg [31:0] instruction = 32'b1110_00_0_0010_0_0001_0010_000000000011; //SUB	
	reg [31:0] PC_in = 32'd4;
    	wire [31:0] Val_Rm, Val_Rn;
    	wire [3:0] EXE_CMD;
    	wire MEM_R_EN, MEM_W_EN, WB_EN, S, B;
    	wire Two_src;
    	wire mux_for_hazard;
    	wire [3:0] Dest;
    	wire [23:0] Signed_imm_24;
    	wire [11:0] Shift_operand;
    	wire imm;
    	wire [31:0] PC_out;
    	wire StatusRegister_output;


	//wire [31: 0] Instruction;
	ID_Stage id_stage(clk, rst, StatusRegister_input, hazard, WB_WB_EN, WB_Dest, WB_Value, instruction, PC_in,
		Val_Rm, Val_Rn, EXE_CMD, MEM_R_EN, MEM_W_EN, WB_EN, S, B, Two_src, mux_for_hazard,
		Dest, Signed_imm_24, Shift_operand, imm, PC_out, StatusRegister_output);
	always #5 clk = ~clk; 
	initial begin
		rst = 1'b1;
		#52 rst = 1'b0; 
		#500 instruction = 32'b1110_00_0_0000_0_0010_1100_000000000101; //AND 
		#500 instruction = 32'b1110_00_0_1100_0_0110_1101_000000000010; //ORR 
		#500 instruction = 32'b1110_00_0_0100_1_0010_1110_000000000010; //ADDS 
		#500 instruction = 32'b1110_01_0_0100_0_0010_1111_000000110100; //STR
		#500 $stop;
	end

endmodule