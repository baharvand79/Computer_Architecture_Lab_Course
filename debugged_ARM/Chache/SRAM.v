module SRAM(clk, rst, SRAM_WE_N, SRAM_ADDR, SRAM_DQ);
    input clk, rst, SRAM_WE_N;
    input[17:0] SRAM_ADDR;
    inout[15:0] SRAM_DQ;

    reg[15:0] memory[0:511];

    assign SRAM_DQ = SRAM_WE_N ? memory[SRAM_ADDR] : 16'bz; 

    always @(posedge clk) begin
        if (~SRAM_WE_N) 
            memory[SRAM_ADDR] <= SRAM_DQ;
    end

endmodule
