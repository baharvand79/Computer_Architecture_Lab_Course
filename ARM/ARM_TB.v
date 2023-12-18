`include "ARM.v"

module ARM_TB();

    reg clk = 1, rst = 1;
    wire WB_EN_ID_REG_arm, MEM_R_EN_ID_REG_arm, MEM_W_EN_ID_REG_arm, B_ID_REG_arm, S_ID_REG_arm;
    wire [3:0] EXE_CMD_ID_REG_arm;
    wire [31:0] pc_if_reg_arm, Instruction_if_reg_arm;
    ARM arm(clk, rst,
    pc_if_reg_arm, Instruction_if_reg_arm, EXE_CMD_ID_REG_arm, WB_EN_ID_REG_arm, MEM_R_EN_ID_REG_arm, MEM_W_EN_ID_REG_arm, B_ID_REG_arm, S_ID_REG_arm);
    
    always #50 clk = ~clk;

    initial begin
		$dumpfile("ARM_TB.vcd");
        $dumpvars(0, ARM_TB);
        #123 rst = 0;
        #2000 $finish;
    end

endmodule
