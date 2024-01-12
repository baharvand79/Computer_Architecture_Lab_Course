module SRAM_Controller(clk, rst, write_en, read_en, address, writeData, read_data, ready, SRAM_DQ, SRAM_ADDR, SRAM_UB_N, SRAM_LB_N, SRAM_WE_N, SRAM_CE_N, SRAM_OE_N);
    input clk, rst;
    input write_en, read_en;
    input [31 : 0] address;
    input [31 : 0] writeData;

    inout [15 : 0] SRAM_DQ; 

    output [31 : 0] read_data; 
    output ready;
    output [17 : 0] SRAM_ADDR; 

    //active low
    output SRAM_UB_N; 
    output SRAM_LB_N; 
    output SRAM_WE_N; 
    output SRAM_CE_N; 
    output SRAM_OE_N; 

    wire [15:0] read_data_low_temp, read_data_low;
    wire [31:0] read_data_temp;
    
    wire [2 : 0] cnt;
    reg [1 : 0] ps, ns;
    reg cnt_enable;

    parameter [2 : 0]
        cycles = 3'b101, low = 3'b001, high = 3'b010;
    parameter [1 : 0] 
        IDLE = 2'b0, READ = 2'b01, WRITE = 2'b10;

    wire[31:0] converted_addr  = address - 32'd1024;

    assign {SRAM_UB_N, SRAM_LB_N, SRAM_CE_N, SRAM_OE_N} = 4'd0; 

    assign ready = ~(read_en || write_en) ? 1'b1 : (cnt == cycles);  

    Counter counter(.clk(clk), .rst(rst), .cnt_en(cnt_enable), .count_res(cnt));

    assign SRAM_WE_N = write_en ? ~(cnt == low || cnt == high) : 1'b1; 
    assign SRAM_WE_N = read_en ? (cnt == low || cnt == high) : 1'b0;

    assign SRAM_ADDR = (cnt == low) ?  {converted_addr[18 : 2], 1'b0}  :  (cnt == high) ? {converted_addr[18 : 2], 1'b0} + 18'd1 : 18'bz;

    assign SRAM_DQ = (write_en) ? ((cnt == low) ? {writeData[15:0]} 
                            : ((cnt == high) ? {writeData[31:16]} : 16'bz)) : 16'bz;

    assign read_data_low_temp = (cnt == low) ? SRAM_DQ : 16'bz;
    register #(.len(16)) read_data_low_reg(.clk(clk), .rst(rst), .ld(1'b0), .in(read_data_low_temp), .out(read_data_low)); 
    assign read_data_temp = (cnt == high) ? {SRAM_DQ,  read_data_low} : 32'bz;

    wire ld = ~(cnt == high);
    register #(.len(32)) read_data_comp_reg(.clk(clk), .rst(rst), .ld(ld), .in(read_data_temp), .out(read_data));

    always @(posedge clk, posedge rst) begin
        if (rst)
            ps <= 3'b0;
        else
            ps <= ns;
    end

    always @(*) begin
        cnt_enable = 1'b0;
        case (ps)
            IDLE: begin
                if (read_en)
                    ns = READ;
                else if (write_en)
                    ns = WRITE;
                else
                    ns = IDLE;
            end
            READ: begin
                cnt_enable = 1'b1;
                if (cnt != cycles)
                    ns = READ;
                else
                    ns = IDLE;
            end
            WRITE: begin
                cnt_enable = 1'b1;
                if (cnt != cycles)
                        ns = WRITE;
                    else
                        ns = IDLE;
            end
        endcase
    end

endmodule