// 16-bit Comparator
module compare(A, B, LT, GT);
  input [15:0] A, B;
  output LT, GT;
  wire [15:0] diff;
  wire posA, posB, posDiff;
  wire negA, negB, negDiff;
  wire nc1, nc2;
  
  assign negA = A[15];
  assign negB = B[15];
  assign negDiff = diff[15];
  assign posA = (! negA);// && (A != 0);
  assign posB = (! negB);// && (B != 0);
  assign posDiff = (! negDiff) && (diff != 0);
  
  assign LT = (negA && posB) || (negDiff && !(posA && negB));
  assign GT = (posA && negB) || (posDiff && !(negA && posB));
  
  cla16 adder(.A (A), .B (~B), .C (1'b1), .Out (diff), .OFu (nc1), .OFs (nc2));
  
endmodule
