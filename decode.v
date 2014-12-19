module decode(
	input [15:0] instr, write_data,
	input clk, rst, wb_regwrite,
	input [2:0] wb_writesel,
	input valid,
	output jumpr, jumpi, jumpl, branch, memtoreg, memread, memwrite, ALU_Source, halt, regwrite,
	output [15:0] read1data, read2data, imm,
	output [2:0] writesel,
	output [4:0] ALU_op,
	output err);
	
	wire [1:0] regdest;
	//wire regwrite;
	wire [1:0] err_internal;
	wire imm8, zext;
	assign err = |err_internal;
	
	assign imm[4:0] = instr[4:0];
	assign imm[15:5] = jumpi ? ({{5{zext ? 1'b0 : instr[10]}}, instr[10:5]}) : imm8 ? ({{8{zext ? 1'b0 : instr[7]}}, instr[7:5]}) : ({11{zext ? 1'b0 : instr[4]}});
	
	control control0 (.instr (valid ? instr[15:11] : 5'b00001), .op (instr[1:0]), .branch(branch), .halt (halt),
					  .m2r(memtoreg), .memrd(memread), .memwr(memwrite), .ALU_op(ALU_op),
					  .ALU_src (ALU_Source), .jumpi(jumpi), .jumpr(jumpr), .jumpl (jumpl),
					  .regwrite(regwrite), .regdest(regdest), .err(err_internal[1]), .imm8 (imm8), .zext (zext));
					  
	assign writesel = regdest[1] ? (regdest[0] ? 3'b111 : instr[10:8]): regdest[0] ? instr[7:5] : instr[4:2];
	
	rf_bypass regFile0 (.read1data (read1data), .read2data (read2data), .err (err_internal[0]),
				 .clk (clk), .rst (rst), .read1regsel (instr[10:8]), .read2regsel (instr[7:5]),
				 .writeregsel (wb_writesel), .writedata (write_data), .write (wb_regwrite));
	
endmodule 
