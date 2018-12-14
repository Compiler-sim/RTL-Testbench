`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/04 21:38:25
// Design Name: 
// Module Name: Interface
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Interface #(
   parameter CLK_Period=20000000,//the unit is Hz 
   parameter Buad_Rate =115200, //the unit is bits/s
   parameter D_WL      = 24 ,
   parameter INPUT_SIZE= 26 ,
   parameter TIME_STEP=148
)( 
     input              clk       ,
     input              rst_n     ,
     input              w_x_en    ,
     input              uart_rx   ,
     output             uart_tx   ,
     
     output             d_o_valid ,
     output [D_WL-1:0]  d_o       
);
wire tx_finish;
reg [7:0] tx_data;
wire [7:0] rx_data;
reg tx_en;
wire rx_finish;

localparam  IDLE = 4'b0000;
localparam  SEND_REQ = 4'b0001;
localparam  WAIT_D = 4'b0011;
localparam  GET_D = 4'b0010;
localparam  GET_FULL_D = 4'b0110;
localparam  WAIT_W_X_EN = 4'b1111;
localparam  GET_D_OUT = 4'b0111;

reg w_x_en_d;
always @( posedge clk )
  if( !rst_n )
    w_x_en_d <= 1'b0;
  else 
    w_x_en_d <= w_x_en;
wire w_x_en_rise;
assign  w_x_en_rise = (~w_x_en_d)&w_x_en;   

reg rx_finish_d;
always @( posedge clk )
  if( !rst_n )
    rx_finish_d <= 1'b0;
  else 
    rx_finish_d <= rx_finish;
wire rx_finish_rise;
assign  rx_finish_rise = (~rx_finish_d)&rx_finish;

reg [3:0]  state;
reg [3:0]  cnt1;
reg [11:0]  cnt2;
reg [11:0]  cnt3;
reg [7:0]   cnt4;

always @( posedge clk )
  if( !rst_n )
    cnt1 <= 'h0;
  else if( state == GET_D )
    cnt1 <= cnt1+1'b1;
  else if( state == GET_FULL_D )
    cnt1 <= 'h0;
    
wire get_full_d;
assign get_full_d = ( state ==  GET_FULL_D);   

reg get_d_req;
always @( posedge clk )
  if( d_o_valid || (!rst_n) )
     get_d_req<=1'b0;
   else if( w_x_en_rise )
     get_d_req <= 1'b1;

always @( posedge clk )
  if( !rst_n )
    cnt2 <= 'h0;
  else if( get_full_d && (cnt2!=INPUT_SIZE*TIME_STEP-1) )
    cnt2 <= cnt2+1'b1;
  else if( state == IDLE )
    cnt2 <= 'h0;
 
always @( posedge clk )
  if( !rst_n )
    state <= IDLE;
  else
    case(state)
    IDLE: begin
        state <=  WAIT_D;
    end
//    SEND_REQ: 
//      state <= WAIT_D;
    WAIT_D  : begin
      if( rx_finish_rise )
        state <= GET_D;
    end
    GET_D: begin
      if( cnt1 == D_WL/8-1 )
        state <= GET_FULL_D;
      else
        state <= WAIT_D;
    end
    GET_FULL_D: begin
      if( cnt2 == INPUT_SIZE*TIME_STEP-1 )
        state <= WAIT_W_X_EN;
      else
        state <= WAIT_D;  
    end  
    WAIT_W_X_EN: begin
      if( get_d_req )
        state <= GET_D_OUT;
    end
    GET_D_OUT: begin
      if( cnt3 == INPUT_SIZE*TIME_STEP-1 )
        state <= IDLE;
      else if( cnt4 == INPUT_SIZE-1 )
        state <= WAIT_W_X_EN;
    end
    default: state <= IDLE;
   endcase
   
always @( posedge clk )
  if( !rst_n )
    cnt4<='h0;
  else if( d_o_valid && ( cnt4 != INPUT_SIZE-1 ) )
    cnt4<=cnt4+1'b1;
  else
    cnt4 <= 'h0;
//always @( posedge clk )
//  if( !rst_n )
//    tx_en <= 1'b0;
//  else if( state == SEND_REQ )    
//    tx_en <= 1'b1;
//  else
//    tx_en <= 1'b0;
    
//always @( posedge clk )
//  if( !rst_n )
//    tx_data <= 'h0;
//  else if( state == SEND_REQ )    
//    tx_data <= 8'hff;

reg [D_WL-1:0] data_rev;

always @( posedge clk )
  if( !rst_n )
    cnt3 <= 'h00;
  else if( state == GET_D_OUT && (cnt3!=INPUT_SIZE*TIME_STEP-1))
    cnt3 <= cnt3+1'b1;
  else if(state==IDLE)
    cnt3 <= 'h0;
    
always @( posedge clk )
  if( !rst_n )
    data_rev <= 'h00;
  else if( rx_finish_rise )
    data_rev <= {rx_data,data_rev[D_WL-1:8]};

assign d_o_valid = ( state == GET_D_OUT )? 1'b1 : 1'b0;   
  
UART #(
  .CLK_Period(CLK_Period),//the unit is Hz
  .Buad_Rate(Buad_Rate) //the unit is bits/s
)UART_INST(
    .clk      (clk      ),
    .rst_n    (rst_n    ),
          
    .tx_data  (tx_data  ),
    .tx_en    (tx_en    ),
    .tx_finish(tx_finish),
    .uart_tx  (uart_tx  ),
            
    .uart_rx  (uart_rx  ),
    .rx_data  ( rx_data    ),
    .rx_finish(rx_finish)
);                     



RAM #(
   .DEPTH   (INPUT_SIZE*TIME_STEP ),
   .WIDTH_A (12),
   .WIDTH_D (D_WL)
)RAM_INST(
   .clk     (clk ),
   .rst_n   (rst_n ),

   .w_addr  (cnt2  ) ,   
   .w_data  (data_rev) ,
   .w_en    (get_full_d ) ,

   .r_addr  (cnt3  ) ,
   .r_en    (  ) ,
   .r_data  ( d_o  )
);               
    
endmodule
