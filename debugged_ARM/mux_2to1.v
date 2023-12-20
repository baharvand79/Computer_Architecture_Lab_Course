module MUX_2to1 #(parameter N = 32)(
    input [N-1:0] x0, x1,
    input sel,
    output [N-1:0] res
);
    assign res = sel ? x1 : x0;
endmodule