// ¹«ÖÚºÅ: Ð¡ÓãFPGA
// Engineer: littlefish

module Receive_Control #(
  parameter CLK_Period=50000000,//the unit is Hz
  parameter Buad_Rate=9600 //the unit is bits/s
)(
  input            clk,	
  input            rst_n,

  input            uart_rx,
  output reg [7:0] rx_data,
  output            rx_finish,
  output           o_valid  
);

localparam IDLE=2'b00;
localparam GET_DATA=2'b01;
localparam END_BIT=2'b11;

wire Buad_clk;
wire rx_en;
BuadRate_set #(
  .CLK_Period(CLK_Period),//the unit is Hz
  .Buad_Rate (Buad_Rate) //the unit is bits/s
)
BuadRate_set_inst(
   .clk     (clk     ),
   .rst_n   (rst_n   ),
   .enable  (rx_en ),
   .Buad_clk(Buad_clk)
);

reg[5:0] get_start_bit;
always @( posedge clk )
  if( !rst_n )
    get_start_bit <= 6'b111111;
  else
    get_start_bit <= {get_start_bit[4:0],uart_rx};

reg start;
reg [1:0] state;
always @( posedge clk )
  if( !rst_n )
    start <= 1'b0;
  else if( state !=IDLE )
    start <= 1'b0;
  else if( get_start_bit==6'b111000 )
    start <= 1'b1;



reg [3:0] cnt;

always @( negedge Buad_clk or negedge rst_n )
  if( !rst_n )
    state <= IDLE;
  else
      case( state )
        IDLE: begin
            if( start )
              state <= GET_DATA;
          end
        GET_DATA: begin
                if( cnt=='d7 )
              state <= END_BIT;
        end
        END_BIT: begin
              state <= IDLE;
        end
        default: state <= IDLE;
      endcase

assign rx_en =( ~(start==1'b0 && state==IDLE) )? 1'b1:1'b0;

always @( negedge Buad_clk or negedge rst_n )
  if( !rst_n )
    rx_data <= 8'b0;
  else if( state == GET_DATA )
    rx_data <= {uart_rx,rx_data[7:1]};

always @( negedge Buad_clk )
  if( state!=GET_DATA )
    cnt <= 'd0;
  else 
    cnt <= cnt+1'b1;

assign rx_finish=(state==END_BIT);
reg finish_d;
always @( posedge clk or negedge rst_n )
  if( !rst_n )
    finish_d<=1'b0;
  else 
    finish_d<=rx_finish;

assign o_valid = rx_finish&(~finish_d);   

    
endmodule

