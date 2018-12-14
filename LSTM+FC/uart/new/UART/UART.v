// ¹«ÖÚºÅ: Ð¡ÓãFPGA
// Engineer: littlefish

module UART #(
  parameter CLK_Period=50000000,//the unit is Hz
  parameter Buad_Rate=9600 //the unit is bits/s
)(
    input        clk,
    input        rst_n,

    input  [7:0] tx_data,
    input        tx_en,
    output       tx_finish,
    output       uart_tx,

    input        uart_rx,
    output [7:0] rx_data,
    output      rx_finish
);                                                


Send_Control #(
  .CLK_Period(CLK_Period),//the unit is Hz
  .Buad_Rate (Buad_Rate) //the unit is bits/s
)
send_control_inst (
  .clk     ( clk      ),
  .rst_n   ( rst_n    ),
  .tx_en   ( tx_en    ),
  .tx_data ( tx_data  ),
  .tx_finish ( tx_finish  ),
  .uart_tx ( uart_tx  )
);

Receive_Control #(
  .CLK_Period(CLK_Period),//the unit is Hz
  .Buad_Rate (Buad_Rate ) //the unit is bits/s
)
Receive_inst
(
  .clk    (clk    ),	
  .rst_n  (rst_n  ),
  .uart_rx(uart_rx),
  .rx_data(rx_data),
  .rx_finish(rx_finish),
  .o_valid(o_valid)  
);


endmodule
