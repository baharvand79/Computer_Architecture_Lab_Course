module RegisterFile (clk, rst, WB_WB_EN, 
                        Rn, Rd, WB_Dest,
                        WB_Value,
                        Val_Rn, Val_Rm, registers);
    input clk, rst, WB_WB_EN;
    input [3:0]Rn, Rd, WB_Dest;
    input [31:0]WB_Value;
    output [31:0]Val_Rn, Val_Rm;

    output reg [31:0] registers [0:14];

    assign Val_Rn = registers[Rn];
    assign Val_Rm = registers[Rd];
    
    integer i;
    always @ (negedge clk, posedge rst) begin
        if (rst) for (i = 0; i < 15; i=i+1) registers[i] <= i;
        else if (WB_WB_EN) registers[WB_Dest] <= WB_Value;
    end
  
endmodule
