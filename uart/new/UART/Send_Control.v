// ¹«ÖÚºÅ: Ð¡ÓãFPGA
// Engineer: littlefish

module Send_Control #(
  parameter CLK_Period=50000000,//the unit is Hz
  parameter Buad_Rate=9600 //the unit is bits/s
)(
  input        clk,
  input        rst_n,
  input        tx_en,
  input [7:0]  tx_data,
  output       tx_finish,
  output       uart_tx
);
localparam IDLE=2'b00;
localparam EN_TX=2'b10;
localparam END_BIT=2'b11;
wire Buad_clk;
wire Buad_en;
BuadRate_set #(
  .CLK_Period(CLK_Period),//the unit is Hz
  .Buad_Rate (Buad_Rate) //the unit is bits/s
)
BuadRate_set_inst(
   .clk     (clk     ),
   .rst_n   (rst_n   ),
   .enable  (Buad_en ),
   .Buad_clk(Buad_clk)
);

reg [8:0] data_to_send; 

reg [1:0] state;
reg [3:0] cnt;
always @( posedge clk )
  if( !rst_n )
    state <= IDLE;
  else
    case(state)
    IDLE:if( tx_en )
         state <= EN_TX;
    EN_TX: if( cnt=='d9 )
         state <= END_BIT;
    END_BIT: if( cnt=='d0 )
         state <= IDLE;
    default: state <= IDLE;
    endcase

assign Buad_en = (state == EN_TX || state == END_BIT);    

always @( posedge Buad_clk or negedge rst_n)
  if( !rst_n )
    cnt <= 4'b000;
  else begin
    if( cnt!=4'd9)
      cnt <= cnt + 1'b1;
    else 
      cnt <= 4'b0000;
  end	 

always @( posedge Buad_clk or negedge rst_n )
  if( !rst_n )
    data_to_send <= 8'hff;
  else if( cnt == 'd0 )
    data_to_send <= {tx_data,1'b0}; 
  else
    data_to_send <= {1'b1,data_to_send[8:1]};

assign uart_tx = (Buad_en)?data_to_send[0]:1'b1;	
assign tx_finish = (state == IDLE)? 1'b1:1'b0;

endmodule
    	  
