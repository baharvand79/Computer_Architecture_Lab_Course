module PC_tb();
    reg clk, rst, freeze;
    reg [31:0] in;
    wire [31:0] out;
    always #10 clk = ~clk;
    initial begin
        $dumpfile("PC.vcd");
        $dumpvars(0, pc);
        $monitor("PC input is %d, and PC output is %d.", in, out);
        clk = 1'b0;
        rst = 1'b1;
        in = 32'd25;
        #25 rst = 1'b0;
        #55 in = 32'd1001;
        #55 freeze = 1'b1;
        #55 in = 32'd503;
        #55 freeze = 1'b0;
        #100 $finish;

    end
    PC pc(.clk(clk), .rst(rst), .freeze(freeze), .in(in), .out(out));
endmodule

