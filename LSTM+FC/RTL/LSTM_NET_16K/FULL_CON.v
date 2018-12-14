`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/02 18:57:55
// Design Name: 
// Module Name: FULL_CON
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


module FULL_CON #(
  parameter CLASS_NUM = 2,
  parameter INPUT_SIZE=30,
  parameter D_WL      =24,
  parameter FL        =14
)(
    input                       clk      ,
    input                       rst_n    ,
    input                       in_valid ,
    input [D_WL-1:0]            x        ,
    
    output                      o_valid  ,
    output [CLASS_NUM*D_WL-1:0] f_o       
);

wire [CLASS_NUM-1:0] full_o_valid;
wire [CLASS_NUM*D_WL-1:0] f_w;

f_w_buffer #(
   .D_WL       ( D_WL  )   ,
   .INPUT_SIZE (INPUT_SIZE),
   .UNITS_NUM  (CLASS_NUM)
)f_w_inst(
   .clk    (  clk )  ,
   .rst_n  ( rst_n)  ,
   .r_en   ( r_en )  ,
   .w_o    ( f_w  )
);   

wire [CLASS_NUM*D_WL-1:0] f_b;
assign f_b = 'hffe680001980;
    //wire [D_WL-1:0] f_o[0:CLASS_NUM-1];
    
    genvar j;
    generate
      for(j=0;j<CLASS_NUM;j=j+1)
      begin:full_connect_cell
        PE #(
          .INPUT_SIZE(INPUT_SIZE),
          .FL        (FL        ),
          .D_WL      (D_WL      )
        )
        full_connect_cell
        (
           .clk     ( clk      ),
           .rst_n   ( rst_n    ),
           .x       ( x   ),
           .w       ( f_w[j*D_WL+D_WL-1:j*D_WL]    ),
           .b       ( f_b[j*D_WL+D_WL-1:j*D_WL]    ),
           .d_o     ( f_o[j*D_WL+D_WL-1:j*D_WL]    ),
                              
           .in_valid( in_valid ),
           .o_valid ( full_o_valid[j]) 
        );
      end  
    endgenerate 
    
    assign o_valid = full_o_valid[0];    
    
endmodule
