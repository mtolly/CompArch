//ALU_out, PC_new, mem_write_data, mem_read, mem_write, memtoreg, PC_incr
module pipe_execute(
  input [15:0] d_PC_incr,
  input [15:0] d_PC_new,
  input [15:0] d_ALU_out,
  input [15:0] d_mem_write_data,
  input d_mem_read, d_mem_write, d_memtoreg,
  input clk, rst,
  input d_regwrite,
  input [2:0] d_writereg,
  input d_jumpl,
  input en,
  input d_halt,
  output q_jumpl,
  output [2:0] q_writereg,
  output q_regwrite,
  output [15:0] q_PC_incr,
  output [15:0] q_PC_new,
  output [15:0] q_ALU_out,
  output [15:0] q_mem_write_data,
	output q_halt,
  output q_mem_read, q_mem_write, q_memtoreg);
	
	dffen reghalt(.q (q_halt), .d (d_halt), .en (en), .clk (clk), .rst (rst));
  dffen regjumpl (.q (q_jumpl), .d (d_jumpl), .en (en), .clk (clk), .rst (rst));
  dffen3 regwritereg(.q (q_writereg), .d (d_writereg), .en (en), .clk (clk), .rst (rst));
  dffen regregwr(.q (q_regwrite), .d (d_regwrite), .en (en), .clk (clk), .rst (rst));
  dffen16 regpcincr (.q (q_PC_incr), .d (d_PC_incr), .en (en), .clk (clk), .rst (rst));
  dffen16 regpcnew (.q (q_PC_new), .d (d_PC_new), .en (en), .clk (clk), .rst (rst));
  dffen16 regaluout (.q (q_ALU_out), .d (d_ALU_out), .en (en), .clk (clk), .rst (rst));
  dffen16 regmemwrdata (.q (q_mem_write_data), .d (d_mem_write_data), .en (en), .clk (clk), .rst (rst));
  dffen regmemrd (.q (q_mem_read), .d (d_mem_read), .en (en), .clk (clk), .rst (rst));
  dffen regmemwr (.q (q_mem_write), .d (d_mem_write), .en (en), .clk (clk), .rst (rst));
  dffen regm2r (.q (q_memtoreg), .d (d_memtoreg), .en (en), .clk (clk), .rst (rst));
  
  
endmodule 
