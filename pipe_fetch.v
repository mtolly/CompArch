// The pipeline stage between fetch and decode.
module pipe_fetch(
	input [15:0] d_PC_incr,
  input [15:0] d_instr,
  input d_valid,
  input en,
  input clk,
  input rst,
  output q_valid,
  output [15:0] q_PC_incr,
  output [15:0] q_instr);
  
  dffen regvalid(.q (q_valid), .d (d_valid), .en (en), .clk (clk), .rst (rst));
  dffen16 regpci(.q (q_PC_incr), .d (d_PC_incr), .en (en), .clk (clk), .rst (rst));
  dffen16 reginst(.q (q_instr), .d (d_instr), .en (en), .clk (clk), .rst (rst));
endmodule 
