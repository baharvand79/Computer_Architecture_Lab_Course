// module ALU(input [31:0]val_1, val_2,
//   input [3:0]exe_cmd, sr_in,output reg [31:0]alu_result, output reg [3:0]sr);
  
//   reg z, c, n, v;
//   wire z_in, c_in, n_in, v_in;
//   assign {z_in, c_in, n_in, v_in} = sr_in;
  
//   always @ (val_1, val_2, exe_cmd, z_in, c_in, n_in, v_in) begin
    
//     alu_result = 32'b00000000000000000000000000000000;
//     sr = 4'b0000; n = 1'b0; c = 1'b0; z = 1'b0; v = 1'b0;
    
//     case (exe_cmd)
//       4'b0001: begin alu_result = val_2; end
//       4'b1001: begin alu_result = ~val_2; end
//       4'b0010: begin
//         {c, alu_result} = val_1 + val_2;
//         if ((val_1[31] == val_2[31]) && (val_1[31] == (~alu_result[31]))) v = 1'b1;
//       end
//       4'b0011: begin
//         {c, alu_result} = val_1 + val_2 + c_in;
//         if ((val_1[31] == val_2[31]) && (val_1[31] == (~alu_result[31]))) v = 1'b1;
//       end
//       4'b0100: begin
//         {c, alu_result} = val_1 - val_2;
//         if ((val_1[31] == (~val_2[31])) && (val_1[31] == (~alu_result[31]))) v = 1'b1;
//       end
//       4'b0101: begin
//         {c, alu_result} = val_1 - val_2 - {{31'b0000000000000000000000000000000}, ~(c_in)};
//         if ((val_1[31] == (~val_2[31])) && (val_1[31] == (~alu_result[31]))) v = 1'b1;
//       end
//       4'b0110: begin alu_result = val_1 & val_2; end
//       4'b0111: begin alu_result = val_1 | val_2; end
//       4'b1000: begin alu_result = val_1 ^ val_2; end
//     endcase

//     z = alu_result == 32'b00000000000000000000000000000000 ? 1'b1 : 1'b0;
//     n = alu_result[31];    
//     sr = {z, c, n, v};
//   end
// endmodule

module ALU #(
    parameter N = 32
)(
    input [N-1:0] a, b,
    // input carryIn,
    input [3:0] exeCmd,
    output reg [N-1:0] out,
    output [3:0] status
);
    reg c, v;
    wire z, n;
    assign status = {n, z, c, v};
    assign z = ~|out;
    assign n = out[N-1];

    // wire [N-1:0] carryExt, nCarryExt;
    // assign carryExt = {{(N-1){1'b0}}, carryIn};
    // assign nCarryExt = {{(N-1){1'b0}}, ~carryIn};

    always @(exeCmd or a or b) begin
        out = {N{1'b0}};
        c = 1'b0;

        case (exeCmd)
            4'b0001: out = b;                      // MOV
            4'b1001: out = ~b;                     // MVN
            4'b0010: {c, out} = a + b;             // ADD
            4'b0011: {c, out} = a + b;  // ADC
            4'b0100: {c, out} = a - b;             // SUB
            4'b0101: {c, out} = a - b; // SBC
            4'b0110: out = a & b;                  // AND
            4'b0111: out = a | b;                  // ORR
            4'b1000: out = a ^ b;                  // EOR
            default: out = {N{1'b0}};
        endcase

        v = 1'b0;
        if (exeCmd[3:1] == 3'b001) begin      // ADD, ADC
            v = (a[N-1] == b[N-1]) && (a[N-1] != out[N-1]);
        end
        else if (exeCmd[3:1] == 3'b010) begin // SUB, SBC
            v = (a[N-1] != b[N-1]) && (a[N-1] != out[N-1]);
        end
    end
endmodule
