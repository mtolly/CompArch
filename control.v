module control(
	input [4:0] instr,
	input [1:0] op,
	output[1:0] regdest,
	output zext, imm8, jumpl, jumpr, jumpi, branch, m2r, memrd, memwr, ALU_src, regwrite, err, halt,
	output [4:0] ALU_op);
	
	reg [17:0] instr_demux;
	assign halt = instr_demux[17];
	assign regdest[1:0] = instr_demux[16:15];
	assign jumpl = instr_demux[14] & ~halt;
	assign jumpr = instr_demux[13] & ~halt;
	assign jumpi = instr_demux[12] & ~halt;
	assign branch = instr_demux[11] & ~halt;
	assign m2r = instr_demux[10];
	assign memrd = instr_demux[9];
	assign memwr = instr_demux[8] & ~halt;
	assign ALU_src = instr_demux[7];
	assign regwrite = instr_demux[6] & ~halt;
	assign err = instr_demux[5];
	assign ALU_op = instr_demux[4:0];
	assign imm8 = (instr[4:2] == 3'b011) || ({instr[4:2], instr[0]} == 4'b0011) || instr == 5'b11000 || instr == 5'b10010;
	assign zext = (instr==5'b01010) || (instr==5'b01011) || (instr==5'b10010);
	always @ (instr, op)
	 begin
	  casex (instr)				   //012345678901234567890123456789
		5'b00000 : instr_demux = 18'b100000000000000000; //HALT
		5'b00001 : instr_demux = 18'b000000000000000000; //NOP
		5'b0001x : instr_demux = 18'b000000000000100000; //Exception stuff, for now just throws err
		5'b00100 : instr_demux = 18'b000001000000000000; //J
		5'b00110 : instr_demux = 18'b011101000001000000; //JAL
		5'b00101 : instr_demux = 18'b000010000010000000; //JR
		5'b00111 : instr_demux = 18'b011110000011000000; //JALR
		5'b010xx : begin instr_demux[17:2] = 16'b0010000000110000; instr_demux[1:0] = instr[1:0]; end //ADDI, SUBI, XORI, ANDNI
		5'b011xx : begin instr_demux[17:2] = 16'b0000001000100011; instr_demux[1:0] = instr[1:0]; end //BEQZ, BNEZ, BLTZ, BGEZ
		5'b10000 : instr_demux = 18'b000000000110000000; //ST
		5'b10001 : instr_demux = 18'b001000011011000000; //LD
		5'b10010 : instr_demux = 18'b010000000011010001; //SLBI
		5'b10011 : instr_demux = 18'b010000000111000000; //STU
		5'b101xx : begin instr_demux[17:2] = 16'b0010000000110001; instr_demux[1:0] = instr[1:0]; end //ROLI, SLLI, RORI, SRLI
		5'b11000 : instr_demux = 18'b010000000011010000; //LBI
		5'b11001 : instr_demux = 18'b000000000001010010; //BTR
		5'b1101x : instr_demux = {15'b000000000001000, ~instr[0], op};
		5'b111xx : begin instr_demux[17:2] = 16'b0000000000010010; instr_demux[1:0] = instr[1:0]; end //SEQ, SLT, SLE, SCO
		5'b????? : instr_demux = 18'b000000000000000000; //NOP
	  endcase
	 end
endmodule 
