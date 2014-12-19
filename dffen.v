// D flip-flop with enable
module dffen(q, d, en, clk, rst);
  output q;
  input d;
  input en;
  input clk;
  input rst;
  
  dff dff(.q (q), .d (en ? d : q), .clk (clk), .rst (rst));
  
endmodule
