`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/02 08:57:24
// Design Name: 
// Module Name: LSTM_TB
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


module LSTM_TB;
  
parameter INPUT_SIZE  = 26 ;
parameter ALL_CELL_NUM= 30 ;
parameter TIME_STEP   = 148;
parameter UNITS_NUM   = 5  ;
parameter D_WL        = 24 ;
parameter FL          = 14 ;

logic            clk         ;
logic            rst_n       ;
logic            f_in_valid  ;
logic [D_WL-1:0] feature_in  ;

logic            w_x_en      ;
logic            o_valid     ;
logic            result      ;

FULL_DESIGN #(
  .INPUT_SIZE   ( INPUT_SIZE  ),
  .ALL_CELL_NUM ( ALL_CELL_NUM),
  .TIME_STEP    ( TIME_STEP   ),
  .UNITS_NUM    ( UNITS_NUM   ),
  .D_WL         ( D_WL        ),
  .FL           ( FL          ) 
)FULL_DESIGN_INST(
    .clk         ( clk          ),
    .rst_n       ( rst_n        ),
    .f_in_valid  ( f_in_valid   ),
    .feature_in  ( feature_in   ),
                               
    .w_x_en      ( w_x_en       ), 
    .o_valid     ( o_valid      ),
    .result      ( result       ) 
);
reg [D_WL-1:0] mel [0:3847];
initial begin
  $readmemh("mel_txt.txt",mel);
end

always #3 clk = ~clk;
integer i=0,j=0;
initial begin
  clk = 0;
  rst_n = 0;
  f_in_valid = 0;
  feature_in='h00;
  j=0;
  #50
  rst_n = 1;
  j=0;
  forever begin
    if( j!=INPUT_SIZE*TIME_STEP-1 )
    @(posedge w_x_en)
    for(i=0;i<INPUT_SIZE;i=i+1) begin
      @(negedge clk);
      f_in_valid = 1;
      feature_in=mel[j+i];
    end
    @(negedge clk)
    f_in_valid=0;
    j=j+INPUT_SIZE;
  end
end

initial begin
  forever begin
    wait(o_valid)
      $finish();
  end
end




endmodule
