module Register_File(
    input clk, rst,
    input [3:0] src1, src2, Dest_wb, //Dest_wb = write register, srcs are for read
    input [31:0] Result_wb, //Result_wb = write data
    input writeBack_en,
    output [31:0] reg1, reg2
);
    reg [31:0] register_file [0:14];
    assign reg1 = register_file[src1];
    assign reg2 = register_file[src2];
    initial begin
        register_file[0] = 0;
        register_file[1] = 1;
        register_file[2] = 2;
        register_file[3] = 3;
        register_file[4] = 4;
        register_file[5] = 5;
        register_file[6] = 6;
        register_file[7] = 7;
        register_file[8] = 8;
        register_file[9] = 9;
        register_file[10] = 10;
        register_file[11] = 11;
        register_file[12] = 12;
        register_file[13] = 13;
        register_file[14] = 14;
    end
    integer i;
    always @(negedge clk, posedge rst) begin
        if (rst)
            for (i = 0; i < 15; i = i + 1)
                register_file[i] <= i;
        else if (writeBack_en)
            register_file[Dest_wb] <= Result_wb;
    end
endmodule
