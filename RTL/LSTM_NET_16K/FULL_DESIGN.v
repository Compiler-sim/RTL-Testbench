`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/02 19:18:56
// Design Name: 
// Module Name: FULL_DESIGN
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


module FULL_DESIGN #(
  parameter CLK_Period = 20000000,
  parameter Buad_Rate  = 115200,
  parameter INPUT_SIZE   = 26,
  parameter ALL_CELL_NUM = 30,
  parameter CLASS_NUM    = 2 ,
  parameter TIME_STEP    = 148,
  parameter UNITS_NUM    = 5 ,
  parameter D_WL         = 24,
  parameter FL           = 14
)(
    input                clk         ,
    input                rst_n       ,
//    output               uart_tx     ,
//    input                uart_rx     ,    
    input                f_in_valid ,
    input [D_WL-1:0]     feature_in ,
    output               w_x_en     ,
    output               o_valid     ,
    output               result              
);

//wire                f_in_valid ;
//wire [D_WL-1:0]     feature_in ;
//wire               w_x_en     ;
//Interface #(
//   .CLK_Period(20000000),//the unit is Hz 
//   .Buad_Rate (9600    ), //the unit is bits/s
//   .D_WL      ( 24     ),
//   .INPUT_SIZE( 26     ),
//   .TIME_STEP( TIME_STEP ) 
//)Interface_inst( 
//     .clk      (clk      ),
//     .rst_n    (rst_n    ),
//     .w_x_en   (w_x_en   ),
//     .uart_rx  (uart_rx  ),
//     .uart_tx  (uart_tx  ),
//          
//     .d_o_valid(f_in_valid),
//     .d_o      (feature_in )
//);


wire h_to_full_en;
wire [D_WL-1:0] h_to_full;
wire [CLASS_NUM*D_WL-1:0] f_o;

 LSTM_TOP #(
      .INPUT_SIZE   ( INPUT_SIZE  ),
      .ALL_CELL_NUM ( ALL_CELL_NUM),
      .TIME_STEP    ( TIME_STEP   ),
      .UNITS_NUM    ( UNITS_NUM   ),
      .D_WL         ( D_WL        ),
      .FL           ( FL          ) 
    )LSTM_INST(
        .clk         ( clk          ),
        .rst_n       ( rst_n        ),
        .f_in_valid  ( f_in_valid   ),
        .feature_in  ( feature_in   ),
                                   
        .w_x_en      ( w_x_en       ), 
        .h_to_full_en( h_to_full_en ),
        .h_to_full   ( h_to_full    ) 
    );   
    
    FULL_CON #(
      .CLASS_NUM   (CLASS_NUM  ),
      .INPUT_SIZE  (ALL_CELL_NUM ),
      .D_WL        (D_WL       ),
      .FL          ( FL        )
    )FULL_CON_INST(
        .clk         ( clk          ),
        .rst_n       ( rst_n        ),
        .in_valid    ( h_to_full_en ),
        .x           ( h_to_full     ),
        
        .o_valid     ( o_valid       ),
        .f_o         ( f_o           )       
    );
    
    wire [D_WL-1:0] f_o_1;
    wire [D_WL-1:0] f_o_2;
    assign f_o_1 = f_o[D_WL-1:0];
    assign f_o_2 = f_o[CLASS_NUM*D_WL-1:D_WL];
    
    assign result=($signed(f_o_2)>$signed(f_o_1))? 1'b0:1'b1;
    
endmodule
