// `include "mux_2to1.v"
module Stage_WB(
    input clk, rst,
    input memREn,
    input [31:0] aluRes, memData,
    output [31:0] wbValue
);
    MUX_2to1 #(32) wbMux(
        .x0(aluRes),
        .x1(memData),
        .sel(memREn),
        .res(wbValue)
    );
endmodule