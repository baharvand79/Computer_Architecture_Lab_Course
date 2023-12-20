`timescale 1ns/1ns
`include "ARM.v"
module ARM_TB();
    localparam HCLK = 5;

    reg clk, rst;

    ARM arm(clk, rst);

    always #HCLK clk = ~clk;

    initial begin
        //$dumpfile("ARM_TB.vcd");
        //$dumpvars(0, ARM_TB);
        {clk, rst} = 2'b01;
        #10 rst = 1'b0;
        #3000 $finish;
    end
endmodule
