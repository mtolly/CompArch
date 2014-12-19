/* $Author: karu $ */
/* $LastChangedDate: 2009-04-24 09:28:13 -0500 (Fri, 24 Apr 2009) $ */
/* $Rev: 77 $ */

module mem_system(/*AUTOARG*/
   // Outputs
   DataOut, Done, Stall, CacheHit, err, 
   // Inputs
   Addr, DataIn, Rd, Wr, createdump, clk, rst
   );
   
   input [15:0] Addr;
   input [15:0] DataIn;
   input        Rd;
   input        Wr;
   input        createdump;
   input        clk;
   input        rst;
   
   output [15:0] DataOut;
   output Done;
   output Stall;
   output CacheHit;
   output err;

   /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
   parameter mem_type = 0;
   
   // your code here

   // You must pass the mem_type parameter 
   // and createdump inputs to the 
   // cache modules
   
   wire [15:0] mem_out, mem_addr, mem_in, cache_in, cache_out;
   wire [7:0] index;
   wire [4:0] tag_in, tag_out;
   wire [3:0] mem_busy;
   wire [2:0] word;
   wire mem_stall, hit, dirty, valid, memwr, memrd, comp, write, valid_in;
   
	mem_system_fsm msfm0 (.mem_out (mem_out), .cache_out (cache_out), .data_in (DataIn), .addr (Addr), .busy (mem_busy), 
		.tag_out (tag_out), .mem_stall (mem_stall), .hit (hit), .dirty (dirty), .valid (valid), .rd (Rd), .wr (Wr), 
		.rst (rst), .clk (clk), .memwr (memwr), .memrd (memrd), .enable (enable), .comp (comp), .write (write), 
		.valid_in (valid_in), .done_out (Done), .stall (Stall), .cache_hit (CacheHit), .err (fsm_err), .word (word), 
		.tag_in (tag_in), .index (index), .data_out (DataOut), .mem_addr (mem_addr), .mem_in (mem_in), .cache_in (cache_in));
		
	four_bank_mem memory0 (.clk (clk), .rst (rst), .createdump (createdump), .addr (mem_addr), .data_in (mem_in), .wr (memwr),
		.rd (memrd), .data_out (mem_out), .stall (mem_stall), .busy (mem_busy), .err (mem_err));
	wire victim, write0, write1, valid0, valid1, valid_in0, valid_in1, hit0, hit1, dirty0, dirty1, cache_err0, cache_err1, victimway, victimh;
	wire [4:0] tag_out0, tag_out1;
	wire [15:0] cache_out0, cache_out1;
	wire h0, h1;
	assign h0 = hit0 & valid0;
	assign h1 = hit1 & valid1;
	assign cache_out = h0 ? cache_out0 : h1 ? cache_out1 : victim ? cache_out1 : cache_out0;
	assign hit = (h0) | (h1);
	assign enable0 = enable;
	assign enable1 = enable;
	assign victim = ~(valid0 | valid1) ? 1'b0 : 
		  	  valid0 & ~valid1 ? 1'b1 :
			  ~valid0 & valid1 ? 1'b0 : victimway;
	assign err = cache_err0 | cache_err1;
	assign write0 = comp ? write & h0 : ~(victimh) &/* (Rd | Wr) & */write;
	assign write1 = comp ? write & h1 :   victimh  & /*(Rd | Wr) &*/ write;
	//assign valid = hit1 ? valid1 : hit0 ? valid0 : 1'b0;
	assign valid = valid1 | valid0;
	//assign valid = (hit1 & valid1) | (hit0 & valid0);
	assign dirty = valid1 ? dirty1 : valid0 ? dirty0 : 1'b0;
	assign tag_out = h0 ? tag_out0 : h1 ? tag_out1 : 5'b0;
	dff dvw (.d (~victimway), .q (victimway), .clk (Rd | Wr | (rst & clk)), .rst(rst));
	dff dv  (.d (victim), .q (victimh), .clk (Rd | Wr | (rst & clk)), .rst (rst));
	cache  #(0 + mem_type) cache0 (.enable (enable0), .clk (clk), .rst (rst), .createdump (createdump), .tag_in (tag_in), .index (index),
		.offset (word), .data_in (cache_in), .comp (comp), .write (write0), .valid_in (valid_in), .tag_out (tag_out0),
		.data_out (cache_out0), .hit (hit0), .dirty (dirty0), .valid (valid0), .err (cache_err0));
	
	cache  #(2 + mem_type) cache1 (.enable (enable1), .clk (clk), .rst (rst), .createdump (createdump), .tag_in (tag_in), .index (index),
		.offset (word), .data_in (cache_in), .comp (comp), .write (write1), .valid_in (valid_in), .tag_out (tag_out1),
		.data_out (cache_out1), .hit (hit1), .dirty (dirty1), .valid (valid1), .err (cache_err1));
	//assign err = mem_err | fsm_err | cache_err;
   
endmodule // mem_system

   


// DUMMY LINE FOR REV CONTROL :9:
