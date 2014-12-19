module fetch(
	input [15:0] PC_new,
	input clk, rst, halt, stall,
	input brjmp,
	output [15:0] PC_incr,
	output [15:0] instr,
  output ready,
	output err,
	output valid);
  
	wire [15:0] pcCurrent;
	wire createdump, f_done, stallm, hit;
	assign createdump = ~&instr[15:11];
	assign valid = f_done;
	dffen16 pc (.q (pcCurrent), .d (PC_new), .en (~stall || brjmp), .clk (clk), .rst (rst)); 
	cla16 incrPC (.A (pcCurrent), .B (halt ? 16'b0 : 16'h2), .C (1'b0), .Out (PC_incr));
/*	mem_system #(0) imem (.data_in (16'b0), .data_out (instr), .addr (pcCurrent), .enable (1'b1),
				   .wr (1'b0), .clk (clk), .rst (rst), .createdump (createdump), .err (err),
           .ready (ready));*/
	wire erro;
	assign err = erro | pcCurrent[0];
        assign ready = f_done;// | ~stallm;
        mem_system #(0) imem (.DataOut (instr),
			 .Done (f_done),
			 .Stall (stallm),
			 .CacheHit (hit),
			 .err (erro),
			 .Addr ({pcCurrent[15:1], 1'b0}),
			 .DataIn (16'b0),
			 .Rd (1'b1),
			 .Wr (1'b0),
			 .createdump (createdump),
			 .clk (clk),
			 .rst (rst)
			 );

	
endmodule 
