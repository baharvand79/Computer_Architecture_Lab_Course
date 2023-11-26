`timescale 1ps/1ps

module ARM_TB();

    reg clk = 1, rst = 1;
 
    ARM arm(clk, rst);

    always #50 clk = ~clk;

    initial begin
        #123 rst = 0;
        #2000 $stop;
    end

endmodule
