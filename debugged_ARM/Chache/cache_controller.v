`timescale 1ns/1ns

module Cache_Controller (input clk, rst, mem_write_en, mem_read_en, SRAM_ready, cache_hit,
    input  [31:0] address,
    input  [31:0] writeData,
    input  [63:0] SRAM_read_data,
    input  [31:0] cache_read_data,
    output ready, cache_write_en, cache_read_en, SRAM_write_en, SRAM_read_en, check_invalid,
    output [16:0] cache_addr, 
    output [31:0] SRAM_addr, 
    output [31:0] SRAM_Write_Data,
    output [31:0] readData,
    output [63:0] cache_write_data
);

   	wire is_read_ok, is_miss, is_in_sram_read, is_in_sram_write;
    wire [31:0] real_addr;
    reg  [1 :0] ps, ns;
    parameter IDLE = 2'b00, WRITE = 2'b01, SRAM_WRITE = 2'b10;

    assign real_addr  = {address[31:2], 2'b00} - 32'd1024;
    assign cache_addr = real_addr[18:2];
    assign SRAM_addr  = address;

    assign is_read_ok = (ps == IDLE) && mem_read_en && cache_hit;
    assign is_miss    = (ps == WRITE) && SRAM_ready;
    assign SRAM_write_en = (ps == SRAM_WRITE);
    assign cache_read_en = (ps == IDLE) && mem_read_en;
    assign is_in_sram_read = (ps == WRITE);
    assign is_in_sram_write = (ps == SRAM_WRITE) && SRAM_ready;
    assign cache_write_en = is_miss;
    assign SRAM_read_en   = is_in_sram_read;
    assign SRAM_Write_Data  = SRAM_write_en ? writeData : 32'b0;
    assign cache_write_data = is_miss ? SRAM_read_data : 64'b0;
    assign check_invalid    = (ps == IDLE) && mem_write_en;
    assign ready = (~mem_write_en && ~mem_read_en) || is_miss || is_read_ok || is_in_sram_write;
    assign readData = is_read_ok ? cache_read_data : 
                      (is_miss ? (cache_addr[0] ? SRAM_read_data[63:32] : SRAM_read_data[31:0]) : 32'b0); 
    
    always @(*) begin
      if(ps == IDLE) begin
        if(mem_read_en) ns = cache_hit ? IDLE : WRITE;
        else if(mem_write_en) ns = SRAM_WRITE;
        else ns = IDLE;
      end

      else if(ps == WRITE) 
        ns = SRAM_ready ? IDLE : WRITE;

      else if(ps == SRAM_WRITE) 
        ns = SRAM_ready ? IDLE : SRAM_WRITE;
    end

    always @(posedge clk, posedge rst) begin
      if(rst) 
        ps <= IDLE;
      else 
        ps <= ns;
    end

    

endmodule
