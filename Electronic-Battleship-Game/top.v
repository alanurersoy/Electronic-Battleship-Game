// DO NOT CHANGE THE NAME OR THE SIGNALS OF THIS MODULE

module top (
  input        clk    ,
  input  [3:0] sw     ,
  input  [3:0] btn    ,
  output [7:0] led    ,
  output [7:0] seven  ,
  output [3:0] segment
);

/* Your module instantiations go to here. */

// Wires for internal connections
wire pAb;
wire rst;
wire start;
wire pBb;


wire [1:0] X;
assign X[1] = sw[3];
assign X[0] = sw[2];
wire [1:0] Y;
assign Y[1] = sw[1];
assign Y[0] = sw[0];

wire [7:0] disp0;
wire [7:0] disp1;
wire [7:0] disp2;
wire [7:0] disp3;

wire divClk;

// Instantiate the clock divider
clk_divider clk_div_inst (
  .clk_in(clk),
  .divided_clk(divClk)
);

// Instantiate the debouncers for the buttons
debouncer db1 (
  .clk(divClk),
  .rst(1'b0),
  .noisy_in(btn[3]),
  .clean_out(pAb)
);

debouncer db2 (
  .clk(divClk),
  .rst(1'b0),
  .noisy_in(btn[2]),
  .clean_out(rst)
);

debouncer db3 (
  .clk(divClk),
  .rst(1'b0),
  .noisy_in(btn[1]),
  .clean_out(start)
);

debouncer db4 (
  .clk(divClk),
  .rst(1'b0),
  .noisy_in(btn[0]),
  .clean_out(pBb)
);

// Instantiate the battleship module
battleship battleship_inst (
  .clk(divClk),
  .rst(rst),
  .start(start),
  .X(X),
  .Y(Y),
  .pAb(pAb),
  .pBb(pBb),
  .disp0(disp0),
  .disp1(disp1),
  .disp2(disp2),
  .disp3(disp3),
  .led(led)
);

// Instantiate the SSD module
ssd ssd_inst (
  .clk(clk),
  .disp0(disp0),
  .disp1(disp1),
  .disp2(disp2),
  .disp3(disp3),
  .seven(seven),
  .segment(segment)
);

endmodule