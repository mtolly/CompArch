// 16-bit 8-to-1 multiplexer
module mux8_1x16(A, B, C, D, E, F, G, H, S, Out);
  input [15:0] A, B, C, D, E, F, G, H;
  input [2:0] S;
  output [15:0] Out;
  
  assign Out =
    S[2]
      ? (S[1]
        ? (S[0] ? H : G)
        : (S[0] ? F : E))
      : (S[1]
        ? (S[0] ? D : C)
        : (S[0] ? B : A));
endmodule
