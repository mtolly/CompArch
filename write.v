module write(
	input [15:0] mem_out, ALU_out, PC_incr,
    input memtoreg,
	input clk, rst, jumpl,
	output [15:0] write_data,
	output err);
	
	assign write_data = jumpl ? PC_incr : (memtoreg ? mem_out : ALU_out);
  assign err = 0;
endmodule
