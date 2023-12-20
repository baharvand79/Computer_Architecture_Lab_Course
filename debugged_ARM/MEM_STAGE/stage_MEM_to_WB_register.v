module Stage_MEM_to_WB_Register(
    input clk, rst,
    input wbEnIn, memREnIn,
    input [31:0] aluResIn, memDataIn,
    input [3:0] destIn,
    output reg wbEnOut, memREnOut,
    output reg [31:0] aluResOut, memDataOut,
    output reg [3:0] destOut
);
    always@(posedge clk, posedge rst) begin
        if(rst) begin
            {wbEnOut, memREnOut} <= 2'd0;
            {aluResOut, memDataOut} <= 64'd0;
            destOut <= 4'd0;
        end else begin
            {wbEnOut, memREnOut} <= {wbEnIn, memREnIn};
            {aluResOut, memDataOut} <= {aluResIn, memDataIn};
            destOut <= destIn;
        end
    end
endmodule