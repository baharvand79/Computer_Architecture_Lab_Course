module Control_Unit(    
    input [1:0]mode,
    input [3:0]op_code,
    input s_in,
    output reg [3:0] exe_cmd,
    output reg mem_read, mem_write, wb_en, b, s_out
);
    always @(mode, op_code, s_in) begin
        mem_read = 1'b0; mem_write = 1'b0; wb_en = 1'b0; b = 1'b0; s_out = 1'b0;
        exe_cmd = 4'd0;
        case(op_code)
            4'b1101: exe_cmd = 4'b0001; // MOV
            4'b1111: exe_cmd = 4'b1001; // MVN
            4'b0100: exe_cmd = 4'b0010; // ADD
            4'b0101: exe_cmd = 4'b0011; // ADC
            4'b0010: exe_cmd = 4'b0100; // SUB
            4'b0110: exe_cmd = 4'b0101; // SBC
            4'b0000: exe_cmd = 4'b0110; // AND
            4'b1100: exe_cmd = 4'b0111; // ORR
            4'b0001: exe_cmd = 4'b1000; // EOR
            4'b1010: exe_cmd = 4'b0100; // CMP
            4'b1000: exe_cmd = 4'b0110; // TST
            4'b0100: exe_cmd = 4'b0010; // LDR
            4'b0100: exe_cmd = 4'b0010; // STR
            default: exe_cmd = 4'b0001;
        endcase
        case(mode)
            2'b00: begin
                s_out = s_in;
                // wb_en is off for CMP, TST
                wb_en = (op_code == 4'b1010 || op_code == 4'b1000) ? 1'b0 : 1'b1;
            end
            2'b01: begin
                wb_en = s_in;
                mem_write = ~s_in;
                mem_read = s_in;
            end
            2'b10: b = 1'b1;
        endcase
    end
endmodule