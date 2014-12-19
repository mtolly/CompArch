module memory(
	input [15:0] ALU_out, mem_write_data,
	input mem_read, mem_write,
	input clk, rst,
	output [15:0] mem_out,
  output ready,
	output err);
	wire mem_done, stall, hit, createdump;
	/*stallmem  #(1) dmem(.data_out (mem_out), .data_in (mem_write_data),
    .addr ({ALU_out[15:1], 1'b0}), .enable (mem_read || mem_write),
    .wr (mem_write), .createdump (1'b0), .clk (clk), .rst (rst), .err (err),
    .ready (ready));*/
    assign ready = mem_done | ~stall;
    wire erro;
    assign err = erro;// | ((mem_read | mem_write) & ALU_out[0]);
    mem_system #(1) dmem (.DataOut (mem_out), .Done (mem_done), .Stall (stall), .CacheHit (hit), .err (erro), .Addr ({ALU_out[15:1], 1'b0}),
       			  .DataIn (mem_write_data), .Rd (~ALU_out[0] & mem_read), .Wr (~ALU_out[0] & mem_write), .createdump (createdump), .clk (clk), .rst (rst));

endmodule
