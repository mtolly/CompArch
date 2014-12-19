// Arithmetic logic unit.
module alu (
  input [15:0] A,
  input [15:0] B,
  input [4:0] Op,
  output err,
  output [15:0] Out);
  
  /*
    List of operations:

    00000 0:  ADD(I)
    00001 1:  SUB(I)
    00010 2:  XOR(I)
    00011 3:  ANDN(I)
    00100 4:  ROL(I)
    00101 5:  SLL(I)
    00110 6:  ROR(I)
    00111 7:  SRL(I)
    01000 8:  SEQ
    01001 9:  SLT
    01010 10: SLE
    01011 11: SCO
    01100 12: BEQZ
    01101 13: BNEZ
    01110 14: BLTZ
    01111 15: BGEZ
    10000 16: LBI
    10001 17: SLBI
    10010 18: BTR
  */
  
  wire [15:0] OShift, OAdd, OBtr;
  wire aLTb, aGTb, aNeg, aPos;
  reg [15:0] OutReg;
  wire OFs, OFu; 
  assign Out = OutReg;
  assign err = 0;
  
  always @* begin
  casex(Op)
   5'b0000x : OutReg = OAdd; // adder
   5'b00010 : OutReg = A ^ B; // XOR
   5'b00011 : OutReg = A & ~B; // ANDN
   5'b001xx : OutReg = OShift; // shifter
   5'b01000 : begin OutReg[15:1] = 15'b0; OutReg[0] = ~(aLTb | aGTb); end // SEQ
   5'b01001 : begin OutReg[15:1] = 15'b0; OutReg[0] = aLTb; end // SLT
   5'b01010 : begin OutReg[15:1] = 15'b0; OutReg[0] = ~aGTb; end // SLE
   5'b01011 : begin OutReg[15:1] = 15'b0; OutReg[0] = OFu; end // SCO
   5'b01100 : begin OutReg[15:1] = 15'b0; OutReg[0] = ~(aNeg | aPos); end // BEQZ
   5'b01101 : begin OutReg[15:1] = 15'b0; OutReg[0] = aNeg | aPos;  end // BNEZ
   5'b01110 : begin OutReg[15:1] = 15'b0; OutReg[0] = aNeg; end // BLTZ
   5'b01111 : begin OutReg[15:1] = 15'b0; OutReg[0] = ~aNeg; end // BGEZ
   5'b10000 : OutReg = B; // LBI
   5'b10001 : begin OutReg[15:8] = A[7:0]; OutReg[7:0] = B[7:0]; end // SLBI
   5'b10010 : OutReg = OBtr; // BTR
  endcase
  end
  
  // shifter: ROL, SLL, ROR, SRL
  shifter shift(.In (A), .Cnt (B[3:0]), .Op (Op[1:0]), .Out (OShift));
  // cla16: ADD, SUB, SCO
  cla16 adder(.A ((Op == 5'b00001) ? ~A : A), .B (B), .C (Op == 5'b00001),
              .Out (OAdd), .OFu (OFu), .OFs (OFs));
  // btr: BTR
  btr btr0(.In (A), .Out (OBtr));
  // compare 2 registers: SEQ, SLT, SLE
  compare compR(.A (A), .B (B), .LT (aLTb), .GT(aGTb));
  // compare register to zero: BEQZ, BNEZ, BLTZ, BGEZ
  compare compZ(.A (A), .B (16'b0), .LT (aNeg), .GT(aPos));

endmodule
