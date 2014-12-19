// 16-bit CLA
module cla16(
  input [15:0] A,
  input [15:0] B,
  input C,
  output [15:0] Out,
  output OFu,
  output OFs);
  wire CIn1, CIn2, CIn3;
  wire g0, g1, g2, g3, p0, p1, p2, p3;
  assign OFs = (Out[15] != A[15]) & (Out[15] != B[15]);
  wire nc1, nc2, nc3;
  assign CIn1 = g0 | (p0 & C);
  assign CIn2 = g1 | (p1 & CIn1);
  assign CIn3 = g2 | (p2 & CIn2);
  
  cla_4 submod0(.InA (A[3:0]),   .InB (B[3:0]),   .CIn (C),    .Out (Out[3:0]),   .Gen (g0), .Prop (p0), .COut (nc1));
  cla_4 submod1(.InA (A[7:4]),   .InB (B[7:4]),   .CIn (CIn1), .Out (Out[7:4]),   .Gen (g1), .Prop (p1), .COut (nc2));
  cla_4 submod2(.InA (A[11:8]),  .InB (B[11:8]),  .CIn (CIn2), .Out (Out[11:8]),  .Gen (g2), .Prop (p2), .COut (nc3));
  cla_4 submod3(.InA (A[15:12]), .InB (B[15:12]), .CIn (CIn3), .Out (Out[15:12]), .Gen (g3), .Prop (p3), .COut (OFu)); 
endmodule
