
module ConditionCheck (Cond, StatusRegister_output,
                        out);

    input [3:0] Cond, StatusRegister_output;
    output reg out;

    wire Z_, C, N, V;  
    assign {Z_, C, N, V} = StatusRegister_output;
    
    always @ (Cond, StatusRegister_output) begin
        out = 1'b0;
        case (Cond)
        4'b0000: begin if (Z_ == 1'b1) 
            out = 1'b1; end
        4'b0001: begin if (Z_ == 1'b0) 
            out = 1'b1; end
        4'b0010: begin if (C == 1'b1) 
            out = 1'b1; end
        4'b0011: begin if (C == 1'b0) 
            out = 1'b1; end
        4'b0100: begin if (N == 1'b1) 
            out = 1'b1; end
        4'b0101: begin if (N == 1'b0) 
            out = 1'b1; end
        4'b0110: begin if (V == 1'b1) 
            out = 1'b1; end
        4'b0111: begin if (V == 1'b0) 
            out = 1'b1; end
        4'b1000: begin if ((C == 1'b1) && (Z_ == 1'b0)) 
            out = 1'b1; end
        4'b1001: begin if ((C == 1'b0) && (Z_ == 1'b1)) 
            out = 1'b1; end
        4'b1010: begin if (N == V) 
            out = 1'b1; end
        4'b1011: begin if (N != V) 
            out = 1'b1; end
        4'b1100: begin if ((N == V) && (Z_ == 1'b0)) 
            out = 1'b1; end
        4'b1101: begin if ((N != V) && (Z_ == 1'b1)) 
            out = 1'b1; end
        4'b1110: begin 
            out = 1'b1; end
        default: out = 1'b0;
        endcase
    end
endmodule
