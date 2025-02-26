// DO NOT MODIFY THE MODULE NAMES, SIGNAL NAMES, SIGNAL PROPERTIES
module battleship_tb();

  reg clk;
  reg rst;
  reg start;
  reg [1:0] X;
  reg [1:0] Y;
  reg pAb;
  reg pBb;
  wire [7:0] disp0;
  wire [7:0] disp1;
  wire [7:0] disp2;
  wire [7:0] disp3;
  wire [7:0] led;

  battleship  ba00 (
    .clk(clk),
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
  parameter HP = 5;
  parameter FP = (2*HP);

always #HP  clk = ~clk ;

initial begin
    //  * Our waveform is saved under this file.
    
    $dumpfile("battleship_tb.vcd"); 
    
    // * Get the variables from the module.

    $dumpvars(0,battleship_tb);

    $display("Simulation started.");
    
    clk = 1;
    rst = 1;
    start = 0;
    X = 0;
    Y = 0;
    pAb = 0;
    pBb = 0;
    #FP;
    rst = 0;
    #FP;
    start = 1;
    #(2*FP);
    start = 0;
    #(12*FP);
    
    

    /* Your testbench goes here. */
    // A inputs (0,0)
    X = 0;
    Y = 0;
    pAb = 1;
    #FP;
    pAb = 0;
    #FP;

    #(3*FP);

    // A inputs again (0,0) erro
    X = 0;
    Y = 0;
    pAb = 1;
    #FP;
    pAb = 0;
    #FP;

    #(3*FP);

    // A inputs (0,1)
    X = 0;
    Y = 1;
    pAb = 1;
    #FP;
    pAb = 0;
    #FP;

    #(3*FP);


    // A inputs (1,0)
    X = 1;
    Y = 0;
    pAb = 1;
    #FP;
    pAb = 0;
    #FP;

    #(3*FP);

    // A inputs (1,1)
    X = 1;
    Y = 1;
    pAb = 1;
    #FP;
    pAb = 0;
    #FP;

    #(3*FP);

    // B inputs (0,0)
    X = 0;
    Y = 0;
    pBb = 1;
    #FP;
    pBb = 0;
    #FP;

    #(3*FP);


    // B inputs (0,1)
    X = 0;
    Y = 1;
    pBb = 1;
    #FP;
    pBb = 0;
    #FP;
    
    #(3*FP);

    // B inputs (1,0)
    X = 1;
    Y = 0;
    pBb = 1;
    #FP;
    pBb = 0;
    #FP;

    #(3*FP);

    // B inputs again (1,0) erro
    X = 1;
    Y = 0;
    pBb = 1;
    #FP;
    pBb = 0;
    #FP;

    #(3*FP);


    // B inputs (1,1)
    X = 1;
    Y = 1;
    pBb = 1;
    #FP;
    pBb = 0;
    #FP;

    #(3*FP);

    // A Shoots (0,0)
    X = 0;
    Y = 0;
    pAb = 1;
    #FP;
    pAb = 0;
    #FP;

    #(3*FP);


    // B Shoots (0,0)
    X = 0;
    Y = 0;
    pBb = 1;
    #FP;
    pBb = 0;
    #FP;

    #(3*FP);


    // A Shoots (3,0)
    X = 3;
    Y = 0;
    pAb = 1;
    #FP;
    pAb = 0;
    #FP;

    #(3*FP);

    // B Shoots (1,0)
    X = 1;
    Y = 0;
    pBb = 1;
    #FP;
    pBb = 0;
    #FP;

    #(3*FP);

    // A Shoots (1,0)
    X = 1;
    Y = 0;
    pAb = 1;
    #FP;
    pAb = 0;
    #FP;

    #(3*FP);


    // B Shoots (0,1)
    X = 0;
    Y = 1;
    pBb = 1;
    #FP;
    pBb = 0;
    #FP;

    #(3*FP);

    // A Shoots (0,1)
    X = 0;
    Y = 1;
    pAb = 1;
    #FP;
    pAb = 0;
    #FP;

    #(3*FP);

    // B Shoots (1,1)
    X = 1;
    Y = 1;
    pBb = 1;
    #FP;
    pBb = 0;
    #FP;
    


    #(24*HP);

    rst = 1;
    X = 0;
    Y = 0;
    pAb = 0;
    pBb = 0;
    #FP;
    rst = 0;



    
    $display("Simulation finished.");
    $finish(); // Finish simulation.
end

endmodule