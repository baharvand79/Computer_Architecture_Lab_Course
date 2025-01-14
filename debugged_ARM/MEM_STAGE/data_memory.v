module DataMemory(
    input clk, rst,
    input [31:0] memAdr, writeData,
    input memRead, memWrite,
    output reg [31:0] readData
);
    localparam WordCount = 64;

    reg [31:0] dataMem [0:WordCount-1]; // 256B memory

    wire [31:0] dataAdr, adr;
    assign dataAdr = memAdr - 32'd1024;
    assign adr = {2'b00, dataAdr[31:2]}; // Align address to the word boundary
    wire [31:0] Data_Memory_Output_tmp;
    assign Data_Memory_Output_tmp = (memRead) ? dataMem[adr] : readData;
    always @(posedge clk, posedge rst) begin
        readData = Data_Memory_Output_tmp;
        if (rst) begin
            readData = 32'b0;
        end
        if (memRead)
            dataMem[adr] <= writeData;
    end

    // always @(memRead or adr) begin
    //     if (memRead)
    //         readData = dataMem[adr];
    // end
endmodule
