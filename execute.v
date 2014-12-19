module execute(
	input [15:0] PC_incr, read1data, read2data, imm,
	input [4:0] ALU_op,
	input clk, rst,
	input ALU_source,
	input jumpr, jumpi, branch,
	output [15:0] ALU_out, PC_new,
	output err);
  wire [15:0] aluin2;
  wire nc1, nc2;
  
  cla16 jumpbr(.A (jumpr ? read1data : PC_incr),
               .B ((jumpr | jumpi | (branch & ALU_out[0])) ? imm : 16'b0),
               .C (1'b0), .Out (PC_new));

  assign aluin2 = ALU_source ? imm : read2data;
  alu alu0(.A (read1data), .B (aluin2), .Op (ALU_op), .err (err), .Out (ALU_out));

endmodule 
