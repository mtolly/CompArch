// 5-bit D flip-flop with enable
module dffen5(q, d, en, clk, rst);
  output [4:0] q;
  input [4:0] d;
  input en;
  input clk;
  input rst;
  
  dffen dff0(.q (q[0]), .d (d[0]), .clk (clk), .rst (rst), .en (en));
  dffen dff1(.q (q[1]), .d (d[1]), .clk (clk), .rst (rst), .en (en));
  dffen dff2(.q (q[2]), .d (d[2]), .clk (clk), .rst (rst), .en (en));
  dffen dff3(.q (q[3]), .d (d[3]), .clk (clk), .rst (rst), .en (en));
  dffen dff4(.q (q[4]), .d (d[4]), .clk (clk), .rst (rst), .en (en));
  
endmodule
