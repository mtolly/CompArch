module mem_system_fsm (
	input [15:0] mem_out, cache_out, data_in, addr,
	input [3:0] busy,
	input [4:0] tag_out, 
	input mem_stall, hit, dirty, valid, rd, wr, rst, clk,
	output memwr, memrd, enable, comp, write, valid_in, done_out, stall, cache_hit, err,
	output [2:0] word,
	output [4:0] tag_in,
	output [7:0] index,
	output [15:0] data_out, mem_addr, mem_in, cache_in);
	
	wire done;
	wire [3:0] mw;
	wire [5:0] mr;
	wire [1:0] wstate;
	wire [1:0] wword;
   //fsm:
   wire [1:0] state;
   wire erro;
   assign erro=0;
   wire mem_done, d_done, q_done, memwrite, md, cwrwait, cwr, mem_done2, cache_done, c_hit;
   assign c_hit = hit & valid;
	assign wstate = state;
//   always@(state, rst, rd, wr, cache_hit, mem_done, q_done, clk)
//	casex (state)
//		
//		2'b00:  begin /*$display("idle"); */state = (rd ^ wr) ? 2'b01 : 2'b00; erro = 1'b0; end 
//
//		2'b01:	begin /*$display("cache"); */state = /*mem_done & wr & hit ? 2'b01 :*/ cache_done ? (hit & valid ? 2'b11 : 2'b10) : 2'b01; erro = 1'b0; end//cache
//
//		2'b10:	begin /*$display("mema"); */state = mem_done ? 2'b01 : 2'b10; erro = 1'b0; end //memory access - starts the clock-aligned memory access dff state machine
//						
//		2'b11:	begin /*$display("done"); */state = q_done ? 2'b00 : 2'b11; erro = 1'b0; end //done
//		
//		2'b??:  begin /*$display("yo"); */state = 2'b00; end
//		//default: erro=1;
//	endcase*/
/*	reg read, Write;
	always@ (posedge rd, posedge wr)
		casex({rd, wr})
		  2'b00: begin read = 1'b0; Write=1'b0; end
		  2'b01: begin read = 1'b0; Write=1'b1; end
		  2'b10: begin read = 1'b1; Write=1'b0; end
		  2'b11: begin read = 1'b1; Write=1'b1; end
		endcase*/
	wire read, Write;
	assign read = rd;
	assign Write = wr;
	wire idle, cache, mema, finish, memw, rw, idld, cachd;
	assign rw = rd ^ wr;
	assign state = idle ? 2'b00 : cache ? 2'b01 : mema ? 2'b10 : 2'b11;
	assign idle = idld & ~rw;
	assign cache = cachd | idld & rw;
	dff didle (.d ((!(rw) & idle) | (cache & c_hit) | state==2'b11), .q (idld), .clk (clk), .rst (rst));
	dff dcache(.d ((idle & rw) | (mema & mem_done)), .q (cachd), .clk (clk), .rst (rst));
	dff dmema (.d (cache & ~c_hit | (mema & ~mem_done)), .q (mema), .clk (clk), .rst (rst));
	dff dmemw (.d (mema), .q (memw), .clk (clk), .rst (rst));
//	dff ddone (.d (), .q (finish), .clk (clk), .rst (rst));
	wire memwrk;
//	assign d_done = (state == 2'b11) & ~q_done;
	dff ddone (.d (d_done), .q (q_done), .clk (clk), .rst (rst));
	dff nohit (.d (/*state==2'b00 ? 1'b0 : (q_nohit | |mw | |mr)*//*mr[5]*/md), .q (q_nohit), .clk (clk), .rst (rst));  
	wire wr2;
	dff dwr2  (.d (wr), .q (wr2), .clk (clk), .rst (rst));
	//assign memwrite = wr & !(hit&valid) & (state==2'b10) & !((|mw) | (|mr));
	wire memwip;
	assign memwip = |mw | |mr;
	assign memwrite = ~memwip & state==2'b10 & (wr | (rd & valid & dirty)) & ~mem_done;
	//assign memwrk = |mw | |mr | mem_done;
	//assign memwrite = state==2'b10 & (wr | rd & valid) & !memwrk;//wr & !(hit&valid) & (state==2'b10) & !((|mw) | (|mr));
	dff dmw0 (.d (memwrite), .q (mw[0]), .clk (clk), .rst (rst));
	dff dmw1 (.d (mw[0]), .q (mw[1]), .clk (clk), .rst (rst));
	dff dmw2 (.d (mw[1]), .q (mw[2]), .clk (clk), .rst (rst));
	dff dmw3 (.d (mw[2]), .q (mw[3]), .clk (clk), .rst (rst));
	
//	wire mwd;
//	dff dmwd (.d (mw[3]), .q (mwd), .clk (clk), .rst (rst));
	//dff dmr0 (.d (state==2'b10 & !(memwrk | memwrite) | mw[3]), .q (mr[0]), .clk (clk), .rst (rst));
	//dff dmr0 (.d ((rd & (!hit | !valid)) & (state == 2'b10) & !(|mr) | mw[3] ), .q (mr[0]), .clk (clk), .rst (rst));
	wire memread;
	assign memread=((~(memwip | memwrite) & state == 2'b10 & rd) | mw[3]) & ~mem_done;
	dff dmr0 (.d (memread), .q (mr[0]), .clk (clk), .rst (rst));
	dff dmr1 (.d (mr[0]), .q (mr[1]), .clk (clk), .rst (rst));
	dff dmr2 (.d (mr[1]), .q (mr[2]), .clk (clk), .rst (rst));
	dff dmr3 (.d (mr[2]), .q (mr[3]), .clk (clk), .rst (rst));
	dff dmr4 (.d (mr[3]), .q (mr[4]), .clk (clk), .rst (rst));
	dff dmr5 (.d (mr[4]), .q (mr[5]), .clk (clk), .rst (rst));
	dff dmd  (.d (mr[5]), .q (mem_done), .clk (clk), .rst (rst));
	dff dmd2 (.d (mem_done), .q(mem_done2), .clk (clk), .rst (rst));
	//assign mem_done = mr[5];
	
	//assign stall = done | (^state); //Stalls whenever not idle or done
	//assign md = mem_done | /*(mem_done2 & wr & hit) |*/ (md & (state[1] | state[0]));
	//assign memwr = |mw;
	//assign memrd = |mr[3:0];
	//assign done_out = /*(rd | wr)*/ & done;
	//assign done = (q_done | (state == 2'b11));
	//assign cache_hit = (state == 2'b11) & (hit) & (~md);//q_nohit);
	//assign comp = state==2'b01 | ((wr/* | wr2*/) & state == 2'b11);//1'b0;//~(|mr | |mw);//(state == 2'b01);
	//assign comp = (state==2'b01) | (state==2'b10 && word[2:1]==addr[2:1] & wr & |mr[5:2]);//1'b0;//~(|mr | |mw);//(state == 2'b01);
	//cache inputs: tag_in, valid_in, enable, comp, write, cache_in
	assign {tag_in, index} = addr[15:3];
	assign word = {state == 2'b10 ? mr[2] | mw[0] ? 2'b00 : (mr[3] | mw[1]) ? 2'b01 : (mr[4] | mw[2]) ? 2'b10 : 2'b11 : addr[2:1], 1'b0};
	assign memwr = |mw & (dirty ? 1'b1 : (wword == addr[2:1]) & ~(memrd | memwrite));
	assign memrd = |mr[3:0];
	assign wword = mw[0] | mr[0] ? 2'b00 : (mw[1] | mr[1]) ? 2'b01 : (mw[2] | mr[2]) ? 2'b10 : 2'b11;
	assign mem_addr = (|mw & dirty) ? {tag_out, addr[10:3], wword, 1'b0} : {addr[15:3], wword, 1'b0};
	assign enable = 1'b1; //!(|mw) & (|mw | (|mr[5:2]) | (state == 2'b01) | state == 2'b11);
	assign cache_in = |mr ? mem_out : data_in;
	assign mem_in = dirty ? cache_out : data_in;
	assign data_out = cache_out;
	assign err = erro;
	assign comp = state==2'b01;
	assign done_out = cache & c_hit;
	assign valid_in = |mr[5:2] | (write & comp);
	assign cache_hit= cache & c_hit & ~memw;
	assign write = (comp & Write) | //Compare writes during the cache state
		       (|mr[5:2]);   //Access writes when retreiving a block from memory
	assign stall = ~idle;
	//assign valid_in = |mr[5:2] | write & comp;
	//assign write = (wr/* | wr2*/) & state/*[0]*/==/*1*/2'b11 | (|mr[5:2]);
	//assign cache_in = (|mr & !(word[2:1]==addr[2:1] & wr))  ? mem_out : data_in;
//	always @(state, mw, mr, rd, wr)	
	/* $display("state:%d mw:%b mr:%b rd:%b wr:%b r/w:%b stall: %b hit: %b mem_done: %b",
		state,
		mw,
		mr,
		rd,
		wr,
		rd ^ wr, 
		stall, 
		hit,
		mem_done,
		);*/

//	output [2:0] word,
//	output memwr, memrd, enable, comp, write, valid_in, done_out, stall, cache_hit, err,
//	output [7:0] index,
//	output [4:0] tag_in,
//	output [15:0] data_out, mem_addr, mem_in, cache_in);

endmodule 
