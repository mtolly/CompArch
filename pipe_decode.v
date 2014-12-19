// The pipeline stage between decode and execute
module pipe_decode(
  input [15:0] d_PC_incr,
  input en,
  input d_jumpr, d_jumpi, d_jumpl, d_branch, d_memtoreg, d_memread, d_memwrite, d_ALU_Source, d_halt,
  input [15:0] d_read1data, d_read2data, d_imm,
  input [4:0] d_ALU_op,
  input clk,
  input rst,
  input d_regwrite,
  input [2:0] d_writereg,
  input [15:0] d_instr,
  input nopify,
  output [2:0] q_writereg,
  output q_regwrite,
  output q_jumpr, q_jumpi, q_jumpl, q_branch, q_memtoreg, q_memread, q_memwrite, q_ALU_Source, q_halt,
  output [15:0] q_read1data, q_read2data, q_imm,
  output [4:0] q_ALU_op,
  output [15:0] q_PC_incr,
  output [15:0] q_instr);
  
  dffen3 regwritereg(.q (q_writereg), .d (nopify ? 3'b000 : d_writereg), .en (en), .clk (clk), .rst (rst));
  dffen16 regpci(.q (q_PC_incr), .d (nopify ? 16'h0000 : d_PC_incr), .en (en), .clk (clk), .rst (rst));
  dffen regregwr(.q (q_regwrite), .d (nopify ? 1'b0 : d_regwrite), .en (en), .clk (clk), .rst (rst));
  dffen regji(.q (q_jumpi), .d (nopify ? 1'b0 : d_jumpi), .en (en), .clk (clk), .rst (rst));
  dffen regjr(.q (q_jumpr), .d (nopify ? 1'b0 : d_jumpr), .en (en), .clk (clk), .rst (rst));
  dffen regjl(.q (q_jumpl), .d (nopify ? 1'b0 : d_jumpl), .en (en), .clk (clk), .rst (rst));
  dffen regbr(.q (q_branch), .d (nopify ? 1'b0 : d_branch), .en (en), .clk (clk), .rst (rst));
  dffen regm2r(.q (q_memtoreg), .d (nopify ? 1'b0 : d_memtoreg), .en (en), .clk (clk), .rst (rst));
  dffen regmemrd(.q (q_memread), .d (nopify ? 1'b0 : d_memread), .en (en), .clk (clk), .rst (rst));
  dffen regmemwr(.q (q_memwrite), .d (nopify ? 1'b0 : d_memwrite), .en (en), .clk (clk), .rst (rst));
  dffen regalusrc(.q (q_ALU_Source), .d (nopify ? 1'b0 : d_ALU_Source), .en (en), .clk (clk), .rst (rst));
  dffen reghalt(.q (q_halt), .d (nopify ? 1'b0 : d_halt), .en (en), .clk (clk), .rst (rst));
  dffen16 regr1d(.q (q_read1data), .d (nopify ? 16'h0000 : d_read1data), .en (en), .clk (clk), .rst (rst));
  dffen16 regr2d(.q (q_read2data), .d (nopify ? 16'h0000 : d_read2data), .en (en), .clk (clk), .rst (rst));
  dffen16 regimm(.q (q_imm), .d (nopify ? 16'h0000 : d_imm), .en (en), .clk (clk), .rst (rst));
  dffen5 regaluop(.q (q_ALU_op), .d (nopify ? 5'b00000 : d_ALU_op), .en (en), .clk (clk), .rst (rst));
  dffen16 reginstr(.q (q_instr), .d (nopify ? 16'h0000 : d_instr), .en (en), .clk (clk), .rst (rst));
  
endmodule 
