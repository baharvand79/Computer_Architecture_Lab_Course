`include "ARM.v"

module ARM_TB();

    reg clk = 1, rst = 1;
 
    ARM arm(clk, rst);

    always #50 clk = ~clk;

    initial begin
		$dumpfile("ARM_TB.vcd");
        $dumpvars(0, ARM_TB);
        #123 rst = 0;
        #2000 $finish;
    end

endmodule
