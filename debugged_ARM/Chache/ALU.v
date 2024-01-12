module ALU(op1, op2, carry, exe_cmd, alu_res, s_b);

  input carry;
  input [31 : 0] op1, op2;
  input [3 : 0] exe_cmd;
  output [31 : 0] alu_res;
  output [3 : 0] s_b;

  reg v_, c_;
  wire n_, z_;
  reg [32 : 0] temp;

  always@(*)begin
    {v_, c_} = 2'b00;
    case(exe_cmd)
      4'b0001: begin //mov
        temp = op2;
      end
      4'b1001: begin //mvn
        temp = ~op2;
      end
      4'b0010: begin //add & ldr & str
        temp = op1 + op2;
        c_ = temp[32];
        v_ = (temp[31] ^ op1[31]) & (op1[31] ~^ op2[31]);
      end
      4'b0011: begin //adc
        temp = op1 + op2 + carry;
        c_ = temp[32];
        v_ = (temp[31] ^ op1[31]) & (op1[31] ~^ op2[31]);
      end
      4'b0100: begin //sub & cmp
        temp = {op1[31],op1} - {op2[31],op2};
        c_ = temp[32];
        v_ = (temp[31] ^ op1[31]) & (op1[31] ^ op2[31]);
      end
      4'b0101: begin //sbc
        if(carry) temp = op1 - op2;
        else temp = op1 - op2 - 1'b1;
       
        c_ = temp[32];
        v_ = (temp[31] ^ op1[31]) & (op1[31] ^ op2[31]);
      end
      4'b0110: begin //and & tst
        temp = op1 & op2;
      end
      4'b0111: begin //orr
        temp = op1 | op2;
      end
      4'b1000: begin //eor
        temp = op1 ^ op2;
      end
    endcase
  end

  assign n_ = alu_res[31];
  assign z_ = alu_res == 32'b0;
  assign alu_res = temp[31:0];
  assign s_b = {n_, z_, c_, v_};

endmodule