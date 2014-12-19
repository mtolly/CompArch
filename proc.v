// Main processor module
// CS 552, Ross Aiken & Michael Tolly
module proc ( err, clk, rst );

  input clk;
  input rst;

  output err;

  // err becomes true if any module signals an error.
  wire [4:0] err_all;
  assign err = |err_all;

  // assign haltxout = decode0.control0.halt;
  // assign memdata = m_read2data;

  wire [15:0] f_PC_new, f_PC_incr, f_instr;
  wire f_en, f_stall;

  wire [15:0] d_instr, d_read1data, d_read2data, d_imm, d_PC_incr;
  wire [4:0] d_ALU_op;
  wire [2:0] d_writereg;
  wire d_en, d_valid;
  wire d_jumpr, d_jumpi, d_jumpl, d_branch, d_m2r, d_memrd, d_memwr, d_ALU_src, d_halt, d_regwrite;

  wire [15:0] e_read1data, e_read2data, e_imm, e_PC_new, e_ALU_out, e_PC_incr;
  wire [15:0] e_read1data_bypass, e_read2data_bypass;
  wire [4:0] e_ALU_op;
  wire [2:0] e_writereg;
  wire e_en;
  wire e_jumpr, e_jumpi, e_jumpl, e_branch, e_m2r, e_memrd, e_memwr, e_ALU_src, e_halt, e_regwrite;
  wire [15:0] e_instr; // used for MEM->EX bypass
  wire flush;
  wire [15:0] m_PC_new, m_ALU_out, m_PC_incr, m_memdata, m_mem_out;
  wire [2:0] m_writereg;
  wire m_ready;
  wire m_en;
  wire m_jumpl, m_m2r, m_memrd, m_memwr, m_halt, m_regwrite;

  wire [15:0] w_write_data, w_ALU_out, w_mem_out, w_PC_incr, w_PC_new;
  wire w_jumpl, w_m2r, w_regwrite, w_halt;
  wire [2:0] w_writereg;

  /************************** * FETCH * ****************************************/
  // Assume an incremented PC unless a branch/jump has reached the execute stage.
  wire f_valid;
  assign f_PC_new = f_stall ? e_PC_new : f_PC_incr;
  fetch  fetch0 (.PC_new (f_PC_new), .PC_incr (f_PC_incr), .instr (f_instr),
    .halt (f_halt), .err (err_all[0]), .clk (clk), .rst (rst),
    .stall (f_stall | flush), .brjmp (e_branch | e_jumpi | e_jumpr),
    .ready (f_ready), .valid (f_valid));
			
  pipe_fetch pfetch0 (.d_valid (f_valid), .q_valid (d_valid), .d_PC_incr (f_PC_incr),
    .d_instr (f_stall | flush ? 16'b0000100000000000 : f_instr), .en (f_en),
    .clk (clk), .rst (rst), .q_PC_incr (d_PC_incr), .q_instr (d_instr));

/*************************** * DECODE * ***************************************/

  decode  decode0 (.valid (d_valid), .instr (d_instr), .jumpi (d_jumpi),
    .jumpr (d_jumpr), .jumpl (d_jumpl), .branch (d_branch), .halt (d_halt),
    .memtoreg (d_m2r), .memread (d_memrd), .memwrite (d_memwr), .ALU_op (d_ALU_op),
		.ALU_Source (d_ALU_src), .read1data (d_read1data), .read2data (d_read2data),
    .imm (d_imm), .writesel (d_writereg), .write_data(w_write_data),
    .regwrite (d_regwrite), .wb_regwrite(w_regwrite & ~mem_stall),
		.wb_writesel (w_writereg), .err (err_all[1]), .clk (clk), .rst (rst));
  // Note that writing to the register file (wb_regwrite) is disabled when we
  // receive a data memory stall.

  pipe_decode pdecode0 (.d_PC_incr (d_PC_incr), .en (d_en), .d_jumpr (d_jumpr),
    .d_jumpi (d_jumpi), .d_jumpl (d_jumpl), .d_branch (d_branch),
    .d_memtoreg (d_m2r), .d_memread (d_memrd), .d_memwrite (d_memwr),
    .d_ALU_Source (d_ALU_src),	.d_halt (d_halt), .d_read1data (d_read1data),
    .d_writereg (d_writereg), .d_read2data (d_read2data), .d_imm (d_imm),
		.d_ALU_op (d_ALU_op), .clk (clk), .rst (rst), .d_regwrite (d_regwrite),
    .q_regwrite (e_regwrite), .q_writereg (e_writereg), .q_jumpr (e_jumpr),
    .q_jumpi (e_jumpi), .q_jumpl (e_jumpl), .q_branch (e_branch),
		.q_memtoreg (e_m2r), .q_memread (e_memrd), .q_memwrite (e_memwr),
    .q_ALU_Source (e_ALU_src), .q_halt (e_halt), .q_read1data (e_read1data),
    .q_read2data (e_read2data), .q_imm (e_imm), .q_ALU_op (e_ALU_op),
    .q_PC_incr (e_PC_incr), .d_instr (d_instr), .q_instr (e_instr),
    .nopify(flush));

/**************************** * EXECUTE * *************************************/

  execute execute0 (.PC_incr (e_PC_incr), .PC_new (e_PC_new), .read1data (e_read1data_bypass),
		.read2data (e_read2data_bypass), .imm (e_imm),	.jumpr (e_jumpr), .jumpi (e_jumpi),
		.branch (e_branch), .ALU_source (e_ALU_src), .ALU_op (e_ALU_op), .ALU_out (e_ALU_out),
		.err (err_all[2]), .clk (clk), .rst (rst));

  pipe_execute pexecute0 (.en (e_en), .d_PC_incr (e_PC_incr), .d_PC_new (e_PC_new), .d_ALU_out (e_ALU_out),
		.d_mem_write_data (e_read2data_bypass), .d_mem_read (e_memrd), .d_jumpl (e_jumpl), .d_mem_write (e_memwr),
		.d_memtoreg (e_m2r), .clk (clk), .rst (rst), .d_regwrite (e_regwrite), .q_regwrite (m_regwrite),
		.q_PC_incr (m_PC_incr), .d_writereg (e_writereg), .q_writereg (m_writereg), .q_PC_new (m_PC_new),
		.q_ALU_out (m_ALU_out), .q_mem_write_data (m_memdata), .q_mem_read (m_memrd), .q_mem_write (m_memwr),
		.q_memtoreg (m_m2r), .q_jumpl (m_jumpl), .d_halt (e_halt), .q_halt (m_halt));

/**************************** * MEMORY * **************************************/

  memory  memory0(.ALU_out (m_ALU_out), .mem_write_data (m_memdata), .mem_read (m_memrd), .mem_write (m_memwr),
		.mem_out (m_mem_out), .err (err_all[3]), .clk (clk), .rst (rst), .ready (m_ready));

  pipe_memory pmemory0 (.en (m_en), .d_mem_out (m_mem_out), .d_ALU_out (m_ALU_out), .d_PC_incr (m_PC_incr), .d_PC_new (m_PC_new),
		.d_memtoreg (m_m2r), .d_jumpl (m_jumpl), .d_regwrite (m_regwrite), .d_writereg (m_writereg), .q_writereg (w_writereg),
		.q_regwrite (w_regwrite), .q_mem_out (w_mem_out), .q_ALU_out (w_ALU_out), .q_PC_incr (w_PC_incr),
		.q_PC_new (w_PC_new), .q_memtoreg (w_m2r), .q_jumpl (w_jumpl), .d_halt (m_halt | ((m_memwr | m_memrd) & m_ALU_out[0])), .q_halt (w_halt), .clk (clk), .rst (rst));

  /*************************** * WRITE * **************************************/

  write  write0 (.mem_out (w_mem_out), .ALU_out (w_ALU_out), .write_data (w_write_data), .jumpl (w_jumpl),
		.PC_incr (w_PC_incr), .err (err_all[4]), .memtoreg (w_m2r), .clk (clk), .rst (rst));

  /************************ * STALLING/FLUSHING * ************************/
  assign flush = e_jumpi | e_jumpr | (e_branch & e_ALU_out[0]);
  assign halt = w_halt;
  assign f_halt = d_halt;

  wire mem_stall = (m_memrd | m_memwr) & ~m_ready;

  assign f_en = ~d_halt & ~mem_stall;
  assign d_en = ~mem_stall;
  assign e_en = ~mem_stall;
  assign m_en = ~mem_stall;

  // When a jump/branch instruction is in the decode stage, insert a noop into
  // the decode stage for the next cycle, and stall whatever's currently in the
  // fetch stage. Next cycle, stall for one more cycle, while the jump/branch
  // is in the execute stage. So, two noops are inserted after the jump/branch.
  // By this time, the jump/branch new PC will be calculated and given to the
  // fetch stage, overwriting whatever instruction was previously in there.

  wire d_jump, e_jump;
  assign d_jump = d_jumpi | d_jumpr;
  assign e_jump = e_jumpi | e_jumpr;

  wire dhazard, reads_regs, reads_regt;
  assign f_stall = dhazard | d_branch | e_branch | d_jump | e_jump | mem_stall | ~(f_ready);
  // We only need to stall for a data hazard when instruction I is a load
  // (memory to register), and the instruction after I reads from that same register.
  assign dhazard = d_m2r & (reads_regs & (f_instr[10:8] == d_writereg) | reads_regt & (f_instr[7:5] == d_writereg));

  // Some basic decoding to figure out if instructions in the Fetch stage
  //actually read from the two source register positions.
  // Instructions that DON'T read from the register S (f_instr[10:8]):
  assign reads_regs = ~( ~|f_instr[15:13]                              // halt, noop, siic, rti
                       | ~|f_instr[15:14] & f_instr[13] & ~f_instr[11] // j, jal
                       | (f_instr[15:11] == 5'b11000)                  // lbi
                       | (f_instr[15:11] == 5'b10010) );               // slbi
  // Instructions that DO read from the register T (f_instr[7:5]):
  assign reads_regt = (f_instr[15:11] == 5'b10000)       // st
                    | (f_instr[15:11] == 5'b10011)       // stl
                    | &f_instr[15:14] & |f_instr[13:12]; // all 11xxx except lbi

  // MEM->EX and WB->EX bypasses
  assign e_read1data_bypass
    = (m_regwrite & (e_instr[10:8] == m_writereg))
    ? m_ALU_out
    : (w_regwrite & (e_instr[10:8] == w_writereg))
    ? w_write_data
    : e_read1data;
  assign e_read2data_bypass
    = (m_regwrite & (e_instr[7:5] == m_writereg))
    ? m_ALU_out
    : (w_regwrite & (e_instr[7:5] == w_writereg))
    ? w_write_data
    : e_read2data;

endmodule
