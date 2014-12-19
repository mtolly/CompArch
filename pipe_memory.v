//mem_out, alu_out, pc_incr, m2r
module pipe_memory(
	input [15:0] d_mem_out,
	input [15:0] d_ALU_out,
	input [15:0] d_PC_incr,
	input [15:0] d_PC_new,
	input d_memtoreg,
  input d_regwrite,
  input [2:0] d_writereg,
  input d_jumpl,
  input en,
  input d_halt,
  output q_jumpl,
  output [2:0] q_writereg,
  output q_regwrite,
	output [15:0] q_mem_out,
	output [15:0] q_ALU_out,
	output [15:0] q_PC_incr,
	output [15:0] q_PC_new,
	output q_memtoreg,
	output q_halt,
	input clk, rst);
	
	dffen reghalt(.q (q_halt), .d (d_halt), .en (en), .clk (clk), .rst (rst));
	dffen regjumpl(.q (q_jumpl), .d (d_halt ? 1'b0 : d_jumpl), .en (en), .clk (clk), .rst (rst));
    dffen3 regwritereg(.q (q_writereg), .d (d_halt ? 3'b0 : d_writereg), .en (en), .clk (clk), .rst (rst));
	dffen regregwr(.q (q_regwrite), .d (d_halt ? 1'b0 : d_regwrite), .en (en), .clk (clk), .rst (rst));
	dffen16 regmemout (.q (q_mem_out), .d (d_halt ? 16'b0 : d_mem_out), .en (en), .clk (clk), .rst (rst));
	dffen16 regaluout (.q (q_ALU_out), .d (d_halt ? 16'b0 : d_ALU_out), .en (en), .clk (clk), .rst (rst));
	dffen16 regpcincr (.q (q_PC_incr), .d (d_halt ? 16'b0 : d_PC_incr), .en (en), .clk (clk), .rst (rst));
	dffen16 regpcnew (.q (q_PC_new), .d (d_halt ? 16'b0 : d_PC_new), .en (en), .clk (clk), .rst (rst));
	dffen regm2r (.q (q_memtoreg), .d (d_halt ? 1'b0 : d_memtoreg), .en (en), .clk (clk), .rst (rst));
	
endmodule 
