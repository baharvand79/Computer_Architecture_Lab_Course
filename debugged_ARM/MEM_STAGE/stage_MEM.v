`include "data_memory.v"
module Stage_MEM(
    input clk, rst,
    input wb_en, mem_read_en, mem_write_en.
    input [31:0] alu_re_addr, val_rm
    output [31:0] data_out
    
);

    DataMemory data_memory(
        .clk(clk), 
        .rst(rst),
        .memAdr(alu_re_addr), 
        .writeData(val_rm),
        .memRead(mem_read_en),
        .memWrite(mem_write_en),
        .readData(data_out)
    );
endmodule