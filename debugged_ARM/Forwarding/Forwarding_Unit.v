module Forwarding_Unit(MEM_wb_en, WB_wb_en, Forward_en,src1, src2, MEM_dst, WB_dst,sel_src1, sel_src2);
    input MEM_wb_en, WB_wb_en, Forward_en;
    input[3:0] src1, src2, MEM_dst, WB_dst;
    output reg[1:0] sel_src1, sel_src2;

    always @(*) begin
        {sel_src1, sel_src2} = 4'b0000;

        if(Forward_en == 1'b1) begin 
            if((src1 == MEM_dst)  && (MEM_wb_en == 1'b1)) 
                sel_src1 = 2'b01;

            else if((src1 == WB_dst) && (WB_wb_en == 1'b1))
                sel_src1 = 2'b10;

            if((src2 == MEM_dst) && (MEM_wb_en == 1'b1)) 
                sel_src2 = 2'b01;

            else if((src2 == WB_dst) && (WB_wb_en == 1'b1))
                sel_src2 = 2'b10;
        end      
    end

endmodule