// DO NOT MODIFY THE MODULE NAMES, SIGNAL NAMES, SIGNAL PROPERTIES

module battleship (
  input            clk  ,
  input            rst  ,
  input            start,
  input      [1:0] X    ,
  input      [1:0] Y    ,
  input            pAb  ,
  input            pBb  ,
  output reg [7:0] disp0,
  output reg [7:0] disp1,
  output reg [7:0] disp2,
  output reg [7:0] disp3,
  output reg [7:0] led
);

/* Your design goes here. */
reg [1:0] A_IN_COUNT = 2'b0;
reg [15:0] A_MATRIX = 16'b0;
reg [2:0] A_SCORE = 3'b0;


reg [1:0] B_IN_COUNT = 2'b0;
reg [15:0] B_MATRIX = 16'b0;
reg [2:0] B_SCORE = 3'b0;

reg Z = 0;
reg [2:0]led_dance_time = 3'b0;

reg [3:0] state;
reg [19:0] timer_limit = 0;

parameter IDLE_STATE = 0;
parameter SHOW_A = 1, A_IN = 2, ERROR_A = 3;
parameter A_SHOOT = 4, A_SINK = 5, A_WIN = 6;
parameter SHOW_B = 7, B_IN = 8, ERROR_B = 9;
parameter B_SHOOT = 10, B_SINK = 11, B_WIN = 12;
parameter SHOW_SCORE = 13;

/* Your design goes here. */
  always @(posedge clk) begin
    timer_limit <= timer_limit + 1;
  end

  always @(posedge clk) begin
    if (led_dance_time == 3'b111) begin
       led_dance_time <= 3'b0; 
    end
    else begin
      led_dance_time <= led_dance_time + 3'b001;
    end
      
  end

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      state = IDLE_STATE;

      A_MATRIX <= 16'b0;
      B_MATRIX <= 16'b0;
      A_SCORE <= 3'b0;
      B_SCORE <= 3'b0;
      timer_limit <= 0;
      //LED&SSD
      led = 8'b0;
      disp3 = 8'b0;
      disp2 = 8'b0;
      disp1 = 8'b0;
      disp0 = 8'b0;
      A_IN_COUNT <= 2'b0;
      B_IN_COUNT <= 2'b0;
    end

    else begin
      
      case(state)
    
      //IDLE_STATE START
      IDLE_STATE: 
    begin
      A_MATRIX <= 16'b0;
      B_MATRIX <= 16'b0;
      //LED&SSD
      led[7] = 1;
      led[4] = 1;
      led[3] = 1;
      led[0] = 1;
      disp3 = 8'b00000110;
      disp2 = 8'b00111111;
      disp1 = 8'b00111000;
      disp0 = 8'b01111001;
      if (start) begin
        state = SHOW_A;
        timer_limit <= 0;
      end
    end
    //IDLE_STATE END

    //SHOW_A START
    SHOW_A:
    begin
      //LED&SSD
      led = 8'b10011001;
      disp3 = 8'b01110111;
      disp2 = 8'b0;
      disp1 = 8'b0;
      disp0 = 8'b0;
      
      if(timer_limit >= 3) begin 
        state = A_IN;
      end
      
    end
    //SHOW_A END
    
    //A_IN START
    A_IN:
    begin

      timer_limit <= 0;

      
      case (A_IN_COUNT)
        0: 
          begin
            led = 8'b10000000;
          end
        1:
          begin
            led = 8'b10010000;
          end
        2:
          begin
            led = 8'b10100000;
          end
        3:
          begin
            led = 8'b10110000;
          end
      endcase
      
      // SSD
      disp3 = 0;
      disp2 = 0;
      // disp1 based on X
      case (X)
        0: 
          begin
            disp1 = 8'b00111111;
          end
        1:
          begin
            disp1 = 8'b00000110;
          end
        2:
          begin
            disp1 = 8'b01011011;
          end
        3:
          begin
            disp1 = 8'b01001111;
          end
      endcase

      // disp0 based on Y
      case (Y)
        0: 
          begin
            disp0 = 8'b00111111;
          end
        1:
          begin
            disp0 = 8'b00000110;
          end
        2:
          begin
            disp0 = 8'b01011011;
          end
        3:
          begin
            disp0 = 8'b01001111;
          end
      endcase

      if (pAb) begin
        if (A_MATRIX[(4*X) + Y] == 1'b1) begin
          state = ERROR_A;
        end
        else begin
          if (A_IN_COUNT > 2) begin
            A_MATRIX[(4*X) + Y] <= 1'b1;
            state = SHOW_B;
          end
          else begin
            A_MATRIX[(4*X) + Y] <= 1'b1;
            A_IN_COUNT <= A_IN_COUNT +1'b1;
          end
        end
      end
    end
    //A_IN END

    //ERROR_A START
    ERROR_A:
    begin
      //LED&SSD
      led[7] = 1;
      led[5] = 0;
      led[4] = 1;
      led[3] = 1;
      led[0] = 1;
      disp3 = 8'b01111001;
      disp2 = 8'b01010000;
      disp1 = 8'b01010000;
      disp0 = 8'b01011100;
      
      if(timer_limit >= 12) begin 
        state = A_IN;
      end
    end
    //ERROR_A END

    
    //SHOW_B START
    SHOW_B:
    begin
      //LED&SSD
      led[7] = 1;
      led[5] = 0;
      led[4] = 1;
      led[3] = 1;
      led[0] = 1;
      disp3 = 8'b01111100;
      disp2 = 8'b0;
      disp1 = 8'b0;
      disp0 = 8'b0;
      if(timer_limit >= 12) begin 
        state = B_IN;
      end
    end
    //SHOW_B END

    //B_IN START
    B_IN:
    begin
      timer_limit <= 0;

      //LED&SSD
      led[7] = 0;
      led[4] = 0;
      led[3] = 0;
      led[0] = 1;

      
      case (B_IN_COUNT)
        0: 
          begin
            led[3] = 0;
            led[2] = 0;
          end
        1:
          begin
            led[3] = 0;
            led[2] = 1;
          end
        2:
          begin
            led[3] = 1;
            led[2] = 0;
          end
        3:
          begin
            led[3] = 1;
            led[2] = 1;
          end
      endcase

      // SSD
      disp3 = 0;
      disp2 = 0;
      // disp1 based on X
      case (X)
        0: 
          begin
            disp1 = 8'b00111111;
          end
        1:
          begin
            disp1 = 8'b00000110;
          end
        2:
          begin
            disp1 = 8'b01011011;
          end
        3:
          begin
            disp1 = 8'b01001111;
          end
         
      endcase

      // disp0 based on Y
      case (Y)
        0: 
          begin
            disp0 = 8'b00111111;
          end
        1:
          begin
            disp0 = 8'b00000110;
          end
        2:
          begin
            disp0 = 8'b01011011;
          end
        3:
          begin
            disp0 = 8'b01001111;
          end
         
      endcase


      if (pBb) begin
        if (B_MATRIX[(4*X) + Y] == 1'b1) begin
          state = ERROR_B;
        end
        else begin
          if (B_IN_COUNT > 2) begin
            B_MATRIX[(4*X) + Y] <= 1'b1;
            state = SHOW_SCORE;
          end
          else begin
            B_MATRIX[(4*X) + Y] <= 1'b1;
            B_IN_COUNT <= B_IN_COUNT +1'b1;
          end
        end
      end
    end
    //B_IN END

    //ERROR_B START
    ERROR_B:
    begin
      //LED&SSD
      led[7] = 1;
      led[4] = 1;
      led[3] = 1;
      led[2] = 0;
      led[0] = 1;
      disp3 = 8'b01111001;
      disp2 = 8'b01010000;
      disp1 = 8'b01010000;
      disp0 = 8'b01011100;
      
      if(timer_limit >= 12) begin 
        state = B_IN;
      end
      
    end
    //ERROR_B END

    //SHOW_SCORE START
    SHOW_SCORE:
    begin
      
      //LED&SSD
      led[7] = 1;
      led[6] = 0;
      led[5] = 0;
      led[4] = 1;
      led[3] = 1;
      led[2] = 0;
      led[1] = 0;
      led[0] = 1;
      disp3 = 8'b0;
      disp2 = 8'b00111111;
      disp1 = 8'b01000000;
      disp0 = 8'b00111111;
      
      if(timer_limit >= 12) begin 
        state = A_SHOOT;
      end
    end
    
    //SHOW_SCORE END
    
    //A_SHOOT START
    A_SHOOT:
    begin
      timer_limit <= 0;
      //LED
      led[7] = 1;
      led[6] = 0;
      led[5] = 0;
      led[4] = 0;
      led[3] = 0;
      led[2] = 0;
      led[1] = 0;
      led[0] = 0;
      //SSD
      disp3 = 0;
      disp2 = 0;
      // disp1 based on X
      case (X)
        0: 
          begin
            disp1 = 8'b01111111;
          end
        1:
          begin
            disp1 = 8'b00000110;
          end
        2:
          begin
            disp1 = 8'b01011011;
          end
        3:
          begin
            disp1 = 8'b01001111;
          end
         
      endcase

      // disp0 based on Y
      case (Y)
        0: 
          begin
            disp0 = 8'b01111111;
          end
        1:
          begin
            disp0 = 8'b00000110;
          end
        2:
          begin
            disp0 = 8'b01011011;
          end
        3:
          begin
            disp0 = 8'b01001111;
          end
         
      endcase

      if (pAb) begin
        if (B_MATRIX[4*X + Y] == 1) begin
          A_SCORE <= A_SCORE + 1;
          Z <= 1;
          B_MATRIX[4*X + Y] <= 0;
        end
        else begin
          A_SCORE <= A_SCORE;
          Z <= 0;
        end
      end
    
      case (A_SCORE)
        0: 
          begin
            led[5] = 0;
            led[4] = 0;
          end
        1:
          begin
            led[5] = 0;
            led[4] = 1;
          end
        2:
          begin
            led[5] = 1;
            led[4] = 0;
          end
        3:
          begin
            led[5] = 1;
            led[4] = 1;
          end
      endcase

      case (B_SCORE)
        0: 
          begin
            led[3] = 0;
            led[2] = 0;
          end
        1:
          begin
            led[3] = 0;
            led[2] = 1;
          end
        2:
          begin
            led[3] = 1;
            led[2] = 0;
          end
        3:
          begin
            led[3] = 1;
            led[2] = 1;
          end
      endcase

      

      state = A_SINK;
    end
    //A_SHOOT END
    
    //A_SINK START
    A_SINK:
    begin
      // SHOWING SCORES
      case (A_SCORE)
        0: 
          begin
            disp2 = 8'b01111111;
          end
        1:
          begin
            disp2 = 8'b00000110;
          end
        2:
          begin
            disp2 = 8'b01011011;
          end
        3:
          begin
            disp2 = 8'b01001111;
          end
        4:
          begin
            disp2 = 8'b01100110;
          end
         
      endcase
      disp1 = 8'b01000000;
      case (B_SCORE)
        0: 
          begin
            disp0 = 8'b01111111;
          end
        1:
          begin
            disp0 = 8'b00000110;
          end
        2:
          begin
            disp0 = 8'b01011011;
          end
        3:
          begin
            disp0 = 8'b01001111;
          end
        4:
          begin
            disp0 = 8'b01100110;
          end
         
      endcase

      if(timer_limit < 3) begin 
        if (Z) begin
          led = 8'b11111111;
          state = A_SINK;
          if (A_SCORE == 3'b100) begin
            state = A_WIN;
          end
        end
        else begin
          led = 8'b0;
          state = A_SINK;
          if (A_SCORE == 3'b100) begin
            state = A_WIN;
          end
        end
      end
      else begin
        if (A_SCORE == 3'b100) begin
          state = A_WIN;
        end
        else begin
          state = B_SHOOT;
        end
      end
    end
    //A_SINK END
    
    //A_WIN START
    A_WIN:
    begin
      disp3 = 8'b01110111;
      // SHOWING SCORES
      case (A_SCORE)
        0: 
          begin
            disp2 = 8'b01111111;
          end
        1:
          begin
            disp2 = 8'b00000110;
          end
        2:
          begin
            disp2 = 8'b01011011;
          end
        3:
          begin
            disp2 = 8'b01001111;
          end
        4:
          begin
            disp2 = 8'b01100110;
          end
         
      endcase
      disp1 = 8'b01000000;
      case (B_SCORE)
        0: 
          begin
            disp0 = 8'b01111111;
          end
        1:
          begin
            disp0 = 8'b00000110;
          end
        2:
          begin
            disp0 = 8'b01011011;
          end
        3:
          begin
            disp0 = 8'b01001111;
          end
        4:
          begin
            disp0 = 8'b01100110;
          end
         
      endcase
      //LEDDDDANCCEEEEEEEEE
      case (led_dance_time)
        0: 
        begin
        led = 8'b10000001;
        end
        1:
        begin
         led = 8'b01000010;
        end
        2:
        begin
         led = 8'b00100100;
        end
        3:
        begin
         led = 8'b00011000;
        end
        4:
        begin
        led = 8'b00011000;
        end
        5:
        begin
        led = 8'b00100100;
        end
        6:
        begin
        led = 8'b01000010;
        end
        7:
        begin
        led = 8'b10000001;
        end
        endcase

    end
    //A_WIN END
    
    
    //B_SHOOT START
    B_SHOOT:
    begin
      timer_limit <= 0;
      //LED
      led[7] = 0;
      led[6] = 0;
      led[5] = 0;
      led[4] = 0;
      led[3] = 0;
      led[2] = 0;
      led[1] = 0;
      led[0] = 1;
      //SSD
      disp3 = 0;
      disp2 = 0;
      // disp1 based on X
      case (X)
        0: 
          begin
            disp1 = 8'b01111111;
          end
        1:
          begin
            disp1 = 8'b00000110;
          end
        2:
          begin
            disp1 = 8'b01011011;
          end
        3:
          begin
            disp1 = 8'b01001111;
          end
         
      endcase

      // disp0 based on Y
      case (Y)
        0: 
          begin
            disp0 = 8'b01111111;
          end
        1:
          begin
            disp0 = 8'b00000110;
          end
        2:
          begin
            disp0 = 8'b01011011;
          end
        3:
          begin
            disp0 = 8'b01001111;
          end
         
      endcase
    
      if (pBb) begin
        if (A_MATRIX[4*X + Y] == 1) begin
          B_SCORE <= B_SCORE + 1;
          Z <= 1;
          A_MATRIX[4*X + Y] <= 0;
        end
        else begin
          B_SCORE <= B_SCORE;
          Z <= 0;
        end
      end

      case (A_SCORE)
        0: 
          begin
            led[5] = 0;
            led[4] = 0;
          end
        1:
          begin
            led[5] = 0;
            led[4] = 1;
          end
        2:
          begin
            led[5] = 1;
            led[4] = 0;
          end
        3:
          begin
            led[5] = 1;
            led[4] = 1;
          end
      endcase

      case (B_SCORE)
        0: 
          begin
            led[3] = 0;
            led[2] = 0;
          end
        1:
          begin
            led[3] = 0;
            led[2] = 1;
          end
        2:
          begin
            led[3] = 1;
            led[2] = 0;
          end
        3:
          begin
            led[3] = 1;
            led[2] = 1;
          end
      endcase

      

      state <= B_SINK;
    end
    //B_SHOOT END
    
        
    //B_SINK START
    B_SINK:
    begin
      // SHOWING SCORES
      case (A_SCORE)
        0: 
          begin
            disp2 = 8'b01111111;
          end
        1:
          begin
            disp2 = 8'b00000110;
          end
        2:
          begin
            disp2 = 8'b01011011;
          end
        3:
          begin
            disp2 = 8'b01001111;
          end
        4:
          begin
            disp2 = 8'b01100110;
          end
         
      endcase
      disp1 = 8'b01000000;
      case (B_SCORE)
        0: 
          begin
            disp0 = 8'b01111111;
          end
        1:
          begin
            disp0 = 8'b00000110;
          end
        2:
          begin
            disp0 = 8'b01011011;
          end
        3:
          begin
            disp0 = 8'b01001111;
          end
        4:
          begin
            disp0 = 8'b01100110;
          end
         
      endcase

      if(timer_limit < 3) begin 
        if (Z) begin
          led = 8'b11111111;
          state = B_SINK;
          if (B_SCORE == 3'b100) begin
            state = B_WIN;
          end
        end
        else begin
          led = 8'b0;
          state = B_SINK;
          if (B_SCORE == 3'b100) begin
            state = B_WIN;
          end
        end
      end
      else begin
        if (B_SCORE == 3'b100) begin
          state = B_WIN;
        end
        else begin
          state = A_SHOOT;
        end
      end
    end
    //B_SINK END

    //B_WIN START
    B_WIN:
    begin
      disp3 = 8'b01111100;
      // SHOWING SCORES
      case (A_SCORE)
        0: 
          begin
            disp2 = 8'b01111111;
          end
        1:
          begin
            disp2 = 8'b00000110;
          end
        2:
          begin
            disp2 = 8'b01011011;
          end
        3:
          begin
            disp2 = 8'b01001111;
          end
        4:
          begin
            disp2 = 8'b01100110;
          end
         
      endcase
      disp1 = 8'b01000000;
      case (B_SCORE)
        0: 
          begin
            disp0 = 8'b01111111;
          end
        1:
          begin
            disp0 = 8'b00000110;
          end
        2:
          begin
            disp0 = 8'b01011011;
          end
        3:
          begin
            disp0 = 8'b01001111;
          end
        4:
          begin
            disp0 = 8'b01100110;
          end
      endcase

      case (led_dance_time)
        0: 
        begin
        led = 8'b10000001;
        end
        1:
        begin
         led = 8'b01000010;
        end
        2:
        begin
         led = 8'b00100100;
        end
        3:
        begin
         led = 8'b00011000;
        end
        4:
        begin
        led = 8'b00011000;
        end
        5:
        begin
        led = 8'b00100100;
        end
        6:
        begin
        led = 8'b01000010;
        end
        7:
        begin
        led = 8'b10000001;
        end
        endcase
    end
    //B_WIN END
    endcase
  end // else
end // posedge



endmodule