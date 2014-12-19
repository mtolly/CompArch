module cla_4 (
	input [3:0] InA,
	input [3:0] InB,
	input CIn,
	output [3:0] Out,
	output Gen, 
	output Prop,
	output COut);
	
	wire [3:0] p;
	wire [3:0] g;
	wire [4:0] c;
	
	assign c[0] = CIn;
	assign COut = c[4];
	
	assign p[0] = InA[0] | InB[0];
	assign p[1] = InA[1] | InB[1];
	assign p[2] = InA[2] | InB[2];
	assign p[3] = InA[3] | InB[3];
	
	assign g[0] = InA[0] & InB[0];
	assign g[1] = InA[1] & InB[1];
	assign g[2] = InA[2] & InB[2];
	assign g[3] = InA[3] & InB[3];
	
	assign c[1] = g[0] | p[0] & c[0];
	assign c[2] = g[1] | (g[0] & p[1]) | (c[0] & p[0] & p[1]);
	assign c[3] = g[2] | (g[1] & p[2]) | (g[0] & p[1] & p[2]) | (c[0] & p[0] & p[1] & p[2]);
	assign c[4] = g[3] | (g[2] & p[3]) | (g[1] & p[2] & p[3]) | (g[0] & p[1] & p[2] & p[3]) | (c[0] & p[0] & p[1] & p[2] & p[3]);
	
	assign Prop = p[0] & p[1] & p[2] & p[3];
	assign Gen = g[3] | (g[2] & p[3]) | (g[1] & p[2] & p[3]) | (g[0] & p[1] & p[2] & p[3]);
	
	assign Out[0] = InA[0] ^ InB[0] ^ c[0];
	assign Out[1] = InA[1] ^ InB[1] ^ c[1];
	assign Out[2] = InA[2] ^ InB[2] ^ c[2];
	assign Out[3] = InA[3] ^ InB[3] ^ c[3];
endmodule 
