// Register file
module rf ( read1data, read2data, err, // Outputs
            clk, rst, read1regsel, read2regsel, writeregsel, writedata, write // Inputs
          );
   input clk, rst;
   input [2:0]  read1regsel;
   input [2:0]  read2regsel;
   input [2:0]  writeregsel;
   input [15:0] writedata;
   input        write;

   output [15:0] read1data;
   output [15:0] read2data;
   output        err;

   wire [15:0] q0, q1, q2, q3, q4, q5, q6, q7;
   wire [15:0] d0, d1, d2, d3, d4, d5, d6, d7;
   
   assign err = 0;
   
   assign d0 = (writeregsel == 0) && write ? writedata : q0;
   assign d1 = (writeregsel == 1) && write ? writedata : q1;
   assign d2 = (writeregsel == 2) && write ? writedata : q2;
   assign d3 = (writeregsel == 3) && write ? writedata : q3;
   assign d4 = (writeregsel == 4) && write ? writedata : q4;
   assign d5 = (writeregsel == 5) && write ? writedata : q5;
   assign d6 = (writeregsel == 6) && write ? writedata : q6;
   assign d7 = (writeregsel == 7) && write ? writedata : q7;
   
   mux8_1x16 r1mux(.A (q0), .B (q1), .C (q2), .D (q3), .E (q4), .F (q5),
      .G (q6), .H (q7), .S (read1regsel), .Out (read1data));
   mux8_1x16 r2mux(.A (q0), .B (q1), .C (q2), .D (q3), .E (q4), .F (q5),
      .G (q6), .H (q7), .S (read2regsel), .Out (read2data));
   
   dffen16 reg0(.q (q0), .d (d0), .clk (clk), .rst (rst), .en (1'b1));
   dffen16 reg1(.q (q1), .d (d1), .clk (clk), .rst (rst), .en (1'b1));
   dffen16 reg2(.q (q2), .d (d2), .clk (clk), .rst (rst), .en (1'b1));
   dffen16 reg3(.q (q3), .d (d3), .clk (clk), .rst (rst), .en (1'b1));
   dffen16 reg4(.q (q4), .d (d4), .clk (clk), .rst (rst), .en (1'b1));
   dffen16 reg5(.q (q5), .d (d5), .clk (clk), .rst (rst), .en (1'b1));
   dffen16 reg6(.q (q6), .d (d6), .clk (clk), .rst (rst), .en (1'b1));
   dffen16 reg7(.q (q7), .d (d7), .clk (clk), .rst (rst), .en (1'b1));

endmodule
