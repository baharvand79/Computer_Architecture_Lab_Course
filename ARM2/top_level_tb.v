`timescale 1ns/1ns
`include "top_level.v"
module top_level_tb();
    localparam HCLK = 5;

    reg clk, rst;

    TopLevel tl(clk, rst);

    always #HCLK clk = ~clk;

    initial begin
        $dumpfile("top_level_tb.vcd");
        $dumpvars(0, top_level_tb);
        {clk, rst} = 2'b01;
        #10 rst = 1'b0;
        #3000 $finish;
    end
endmodule
