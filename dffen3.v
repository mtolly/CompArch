module dffen3(
	input [2:0] d,
	output [2:0] q,
	input en, clk, rst);
	
	dffen d0(.d (d[0]), .q (q[0]), .en (en), .rst (rst), .clk (clk));
	dffen d1(.d (d[1]), .q (q[1]), .en (en), .rst (rst), .clk (clk));
	dffen d2(.d (d[2]), .q (q[2]), .en (en), .rst (rst), .clk (clk));

endmodule 