module LSTM_LAYER #(
  parameter INPUT_SIZE=26,
  parameter UNITS_NUM=5,
  parameter ALL_CELL_NUM=30,
  parameter D_WL = 22,
  parameter FL   = 12

)(
   input                           clk           ,
   input                           rst_n         ,
   input [UNITS_NUM*D_WL-1:0]      bi            ,
   input [UNITS_NUM*D_WL-1:0]      bf            ,
   input [UNITS_NUM*D_WL-1:0]      bg            ,   
   input [UNITS_NUM*D_WL-1:0]      bo            ,
   input [UNITS_NUM*D_WL-1:0]      pre_c         ,

   input                           lstm_in_valid ,
   input [D_WL-1:0]                x             ,
   input [UNITS_NUM*D_WL-1:0]      wi            ,
   input [UNITS_NUM*D_WL-1:0]      wf            ,
   input [UNITS_NUM*D_WL-1:0]      wg            ,
   input [UNITS_NUM*D_WL-1:0]      wo            ,

   output [UNITS_NUM*D_WL-1:0]     h_o           ,
   output                          h_o_valid     ,
   output                          c_o_valid     ,
   output [UNITS_NUM*D_WL-1:0]     c_o          
);                                            

wire [UNITS_NUM-1:0] h_o_valid_in;
wire [UNITS_NUM-1:0] c_o_valid_in;

genvar i;
generate
  for(i=0;i<UNITS_NUM;i=i+1)
  begin:LSTM_CELL
    LSTM_CELL #(
        .INPUT_SIZE(INPUT_SIZE+ALL_CELL_NUM),
        .FL(FL),
        .D_WL(D_WL)
        
    )LSTM_CELL_INST(
        .clk      ( clk       ),
        .rst_n    ( rst_n     ),
        .x        ( x         ),
        .wi       ( wi[i*D_WL+D_WL-1:i*D_WL]        ),
        .wf       ( wf[i*D_WL+D_WL-1:i*D_WL]        ),
        .wg       ( wg[i*D_WL+D_WL-1:i*D_WL]        ),
        .wo       ( wo[i*D_WL+D_WL-1:i*D_WL]        ),
        .bi       ( bi[i*D_WL+D_WL-1:i*D_WL]        ),
        .bf       ( bf[i*D_WL+D_WL-1:i*D_WL]        ),
        .bg       ( bg[i*D_WL+D_WL-1:i*D_WL]        ),
        .bo       ( bo[i*D_WL+D_WL-1:i*D_WL]        ),
        .pre_c    ( pre_c[i*D_WL+D_WL-1:i*D_WL]     ),
        .in_valid ( lstm_in_valid ),
                            
        .h_o_valid  ( h_o_valid_in[i]  ),
        .h_o      ( h_o[((i+1)*D_WL-1):D_WL*i]      ),
        .c_o      ( c_o[((i+1)*D_WL-1):D_WL*i]      ),
        .c_o_valid( c_o_valid_in[i]                    )	
    );                            
   end
endgenerate

assign h_o_valid = h_o_valid_in[0];
assign c_o_valid = c_o_valid_in[0];

endmodule


