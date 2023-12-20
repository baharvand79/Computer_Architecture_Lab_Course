// !!!!!!!! THIS WAS OUR MODULE BUT I USED ANOTHER
// module ConditionCheck (Cond, StatusRegister_output,
//                         out);

//     input [3:0] Cond, StatusRegister_output;
//     output reg out;

//     wire Z_, C, N, V;  
//     assign {Z_, C, N, V} = StatusRegister_output;
    
//     always @ (Cond, StatusRegister_output) begin
//         out = 1'b0;
//         case (Cond)
//         4'b0000: begin if (Z_ == 1'b1) 
//             out = 1'b1; end
//         4'b0001: begin if (Z_ == 1'b0) 
//             out = 1'b1; end
//         4'b0010: begin if (C == 1'b1) 
//             out = 1'b1; end
//         4'b0011: begin if (C == 1'b0) 
//             out = 1'b1; end
//         4'b0100: begin if (N == 1'b1) 
//             out = 1'b1; end
//         4'b0101: begin if (N == 1'b0) 
//             out = 1'b1; end
//         4'b0110: begin if (V == 1'b1) 
//             out = 1'b1; end
//         4'b0111: begin if (V == 1'b0) 
//             out = 1'b1; end
//         4'b1000: begin if ((C == 1'b1) && (Z_ == 1'b0)) 
//             out = 1'b1; end
//         4'b1001: begin if ((C == 1'b0) && (Z_ == 1'b1)) 
//             out = 1'b1; end
//         4'b1010: begin if (N == V) 
//             out = 1'b1; end
//         4'b1011: begin if (N != V) 
//             out = 1'b1; end
//         4'b1100: begin if ((N == V) && (Z_ == 1'b0)) 
//             out = 1'b1; end
//         4'b1101: begin if ((N != V) && (Z_ == 1'b1)) 
//             out = 1'b1; end
//         4'b1110: begin 
//             out = 1'b1; end
//         default: out = 1'b0;
//         endcase
//     end
// endmodule

module Condition_Check(
    input [3:0] cond,
    input [3:0] status,
    output reg result
);
    wire n, z, c, v;
    assign {n, z, c, v} = status;

    always @(cond, status) begin
        result = 1'b0;
        case (cond)
            4'b0000: result = z;             // EQ
            4'b0001: result = ~z;            // NE
            4'b0010: result = c;             // CS/HS
            4'b0011: result = ~c;            // CC/LO
            4'b0100: result = n;             // MI
            4'b0101: result = ~n;            // PL
            4'b0110: result = v;             // VS
            4'b0111: result = ~v;            // VC
            4'b1000: result = c & ~z;        // HI
            4'b1001: result = ~c | z;        // LS
            4'b1010: result = (n == v);      // GE
            4'b1011: result = (n != v);      // LT
            4'b1100: result = ~z & (n == v); // GT
            4'b1101: result = z & (n != v);  // LE
            4'b1110: result = 1'b1;          // AL
            default: result = 1'b0;
        endcase
    end
endmodule