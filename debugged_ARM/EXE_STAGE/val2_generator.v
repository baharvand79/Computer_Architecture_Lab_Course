module Val2Generator(
    input memInst, imm,
    input [31:0] valRm,
    input [11:0] shift_operand,
    output reg [31:0] val2
);
    integer i;

    always @(memInst or imm or valRm or shift_operand) begin
        val2 = 32'd0;
        if (memInst) begin // LDR, STR
            val2 = {{20{shift_operand[11]}}, shift_operand};
        end
        else begin
            if (imm) begin // immediate
                val2 = {24'd0, shift_operand[7:0]};
                for (i = 0; i < 2 * shift_operand[11:8]; i = i + 1) begin
                    val2 = {val2[0], val2[31:1]};
                end
            end
            else begin // shift Rm
                case (shift_operand[6:5])
                    2'b00: val2 = valRm << shift_operand[11:7];  // LSL
                    2'b01: val2 = valRm >> shift_operand[11:7];  // LSR
                    2'b10: val2 = $signed(valRm) >>> shift_operand[11:7]; // ASR
                    2'b11: begin                                  // ROR
                        val2 = valRm;
                        for (i = 0; i < shift_operand[11:7]; i = i + 1) begin
                            val2 = {val2[0], val2[31:1]};
                        end
                    end
                    default: val2 = 32'd0;
                endcase
            end
        end
    end
endmodule
