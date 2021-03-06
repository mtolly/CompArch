module dff4(
	input [3:0] d,
	output [3:0] q,
	input clk, rst);
	
	dff d0(.d (d[0]), .q (q[0]), .rst (rst), .clk (clk));
	dff d1(.d (d[1]), .q (q[1]), .rst (rst), .clk (clk));
	dff d2(.d (d[2]), .q (q[2]), .rst (rst), .clk (clk));
	dff d3(.d (d[3]), .q (q[3]), .rst (rst), .clk (clk));

endmodule
