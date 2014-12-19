// register file with bypass
// Lets you read & write to the same register in one cycle, where the data read
// is the data you are writing.
module rf_bypass (read1data, read2data, err,
    clk, rst, read1regsel, read2regsel, writeregsel, writedata, write);
  input clk, rst;
  input [2:0] read1regsel;
  input [2:0] read2regsel;
  input [2:0] writeregsel;
  input [15:0] writedata;
  input        write;

  output [15:0] read1data;
  output [15:0] read2data;
  output        err;
  
  wire [15:0] r1d, r2d;
  
  assign read1data = (write && (read1regsel == writeregsel)) ? writedata : r1d;
  assign read2data = (write && (read2regsel == writeregsel)) ? writedata : r2d;
  
  rf rf0(.clk (clk), .rst (rst),
    .read1regsel (read1regsel),
    .read2regsel (read2regsel),
    .writeregsel (writeregsel),
    .writedata (writedata), .write (write), .err (err),
    .read1data (r1d), .read2data (r2d));
endmodule
