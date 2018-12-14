module LSTM_TOP #(
  parameter INPUT_SIZE   = 26,
  parameter ALL_CELL_NUM = 30,
  parameter TIME_STEP    = 148,
  parameter UNITS_NUM    = 5 ,
  parameter D_WL         = 24,
  parameter FL           = 14

)(
    input                clk         ,
    input                rst_n       ,
    input                f_in_valid  ,
    input [D_WL-1:0]     feature_in  ,

    output               w_x_en      , 
    output               h_to_full_en,
    output[D_WL-1:0]     h_to_full

);

wire             get_x_en         ;
wire             get_preh_en      ;
wire             one_timestep_over;
wire[7:0]        addr_x           ;
wire[7:0]        units_cnt        ; 
wire[7:0]        addr_preh        ;      
wire[7:0]        addr_h           ;
//wire             w_x_en           ;
//wire             h_to_full_en     ;
wire[7:0]        to_full_h_addr   ;
wire             prst             ;              
wire             h_mem_sel        ;
wire[D_WL-1:0]   pre_h            ;

wire[7:0]        r_addr_1;
wire[7:0]        r_addr_2;
wire             w_en_1  ;
wire             w_en_2  ;
wire[7:0]        w_addr_1;
wire[7:0]        w_addr_2;
wire[7:0]        c_addr  ;
wire[7:0]        xw_addr ;
wire[7:0]        hw_addr ;
wire[7:0]        b_addr  ;
wire[D_WL*UNITS_NUM-1:0] pre_c;

wire [D_WL*UNITS_NUM-1:0] wi_in;
wire [D_WL*UNITS_NUM-1:0] wf_in;
wire [D_WL*UNITS_NUM-1:0] wg_in;
wire [D_WL*UNITS_NUM-1:0] wo_in;
wire [D_WL*UNITS_NUM-1:0] wi;
wire [D_WL*UNITS_NUM-1:0] wf;
wire [D_WL*UNITS_NUM-1:0] wg;
wire [D_WL*UNITS_NUM-1:0] wo;

wire [D_WL*UNITS_NUM-1:0] ri;
wire [D_WL*UNITS_NUM-1:0] rf;
wire [D_WL*UNITS_NUM-1:0] rg;
wire [D_WL*UNITS_NUM-1:0] ro;
wire [D_WL*UNITS_NUM-1:0] bi;
wire [D_WL*UNITS_NUM-1:0] bf;
wire [D_WL*UNITS_NUM-1:0] bg;
wire [D_WL*UNITS_NUM-1:0] bo;

wire   c_o_valid;
wire[D_WL*UNITS_NUM-1:0] c_o;
wire   h_o_valid;
wire [D_WL*UNITS_NUM-1:0] h_o;  
wire   lstm_in_valid;


assign wi_in =  get_preh_en ? ri:wi;
assign wf_in =  get_preh_en ? rf:wf;
assign wg_in =  get_preh_en ? rg:wg;
assign wo_in =  get_preh_en ? ro:wo;

wire[D_WL-1:0] feature_o;
Buffer #(
  .D_WL (D_WL),
  .DEPTH(INPUT_SIZE)
)mfcc_buffer(
    .clk    ( clk         ),
    .rst_n  ( rst_n       ),
    .w_en   ( w_x_en      ),
    .w_addr ( addr_x      ),
    .r_addr ( addr_x      ),
    .d_in   ( feature_in  ),
    .d_o    ( feature_o   )
);                              

Control_state #(
   .INPUT_SIZE  ( INPUT_SIZE   ),   
   .UNITS_NUM   ( UNITS_NUM    ),
   .ALL_CELL_NUM( ALL_CELL_NUM ),
   .TIME_STEP   ( TIME_STEP    )
)Control_inst(
   .clk              ( clk               ), 
   .rst_n            ( rst_n             ),
   .d_ready          ( 1'b1              ),
   .x_in_valid       ( f_in_valid        ),
   .c_o_valid        ( c_o_valid         ), 
   .LSTM_o_valid     ( h_o_valid         ),
                                        
   .get_x_en         ( get_x_en          ), 
   .get_preh_en      ( get_preh_en       ),
   .one_timestep_over( one_timestep_over ),
   .addr_x           ( addr_x            ),
   .addr_preh        ( addr_preh         ),
   .units_cnt        ( units_cnt         ),
   .c_addr           ( c_addr            ),
   .xw_addr          ( xw_addr           ),
   .hw_addr          ( hw_addr           ),   
   .addr_h           ( addr_h            ),
   .b_addr           ( b_addr            ),
   .h_mem_sel        ( h_mem_sel         ), 
   .w_x_en           ( w_x_en            ),
   .h_to_full_en     ( h_to_full_en      ),
   .to_full_h_addr   ( to_full_h_addr    ),
   .prst             ( prst              )
);                                   
reg [D_WL-1:0] lstm_d_in;
wire [D_WL-1:0] h_pre_1;
wire [D_WL-1:0] h_pre_2;
always @( * )
  case( {w_x_en,get_x_en,get_preh_en} )
  3'b100: lstm_d_in = feature_in;
  3'b010: lstm_d_in = feature_o;
  3'b001: lstm_d_in = pre_h;
  default : lstm_d_in = 'h00;
  endcase

assign lstm_in_valid = (w_x_en&f_in_valid)|get_x_en|get_preh_en;

assign pre_h    = h_mem_sel ? h_pre_1:h_pre_2;
assign r_addr_1 = (h_to_full_en)? to_full_h_addr:addr_preh;
assign r_addr_2 = (h_to_full_en)? to_full_h_addr:addr_preh;

assign h_to_full= h_mem_sel ? h_pre_1:h_pre_2;

assign w_en_1   = h_mem_sel ? 1'b0 : h_o_valid;
assign w_en_2   = h_mem_sel ? h_o_valid : 1'b0;
assign w_addr_1 = h_mem_sel ? 'h00 : addr_h;
assign w_addr_2 = h_mem_sel ? addr_h : 'h00;

wi_buffer #( 
   .D_WL (24),
   .UNITS_NUM (5)
)wi_buffer(
    .addr( xw_addr ),
    .w_o ( wi )
);                    

wf_buffer #( 
   .D_WL (24),
   .UNITS_NUM (5)
)wf_buffer(
    .addr( xw_addr ),
    .w_o ( wf )
); 

wg_buffer #( 
   .D_WL (24),
   .UNITS_NUM (5)
)wg_buffer(
    .addr( xw_addr ),
    .w_o ( wg )
);                   

wo_buffer #( 
   .D_WL (24),
   .UNITS_NUM (5)
)wo_buffer(
    .addr( xw_addr ),
    .w_o ( wo )
);                   

ri_buffer #( 
   .D_WL (24),
   .UNITS_NUM (5)
)ri_buffer(
    .addr( hw_addr ),
    .w_o ( ri )
);                   

rf_buffer #( 
   .D_WL (24),
   .UNITS_NUM (5)
)rf_buffer(
    .addr( hw_addr ),
    .w_o ( rf )
);                   

rg_buffer #( 
   .D_WL (24),
   .UNITS_NUM (5)
)rg_buffer(
    .addr( hw_addr ),
    .w_o ( rg )
);                   

ro_buffer #( 
   .D_WL (24),
   .UNITS_NUM (5)
)ro_buffer(
    .addr( hw_addr ),
    .w_o ( ro )
);                   

bi_buffer #( 
   .D_WL (24),
   .UNITS_NUM (5)
)bi_buffer(
    .addr( b_addr ),
    .w_o ( bi )
);                      

bf_buffer #( 
   .D_WL (24),
   .UNITS_NUM (5)
)bf_buffer(
    .addr( b_addr ),
    .w_o ( bf )
);          

bg_buffer #( 
   .D_WL (24),
   .UNITS_NUM (5)
)bg_buffer(
    .addr( b_addr ),
    .w_o ( bg )
);          

bo_buffer #( 
   .D_WL (24),
   .UNITS_NUM (5)
)bo_buffer(
    .addr( b_addr ),
    .w_o ( bo )
);                      


LSTM_LAYER #(
    .INPUT_SIZE   ( INPUT_SIZE ),
    .ALL_CELL_NUM ( ALL_CELL_NUM),
    .UNITS_NUM    ( UNITS_NUM  ),
    .D_WL         ( D_WL       ),
    .FL           ( FL         )

)LSTM_LAYER_INST(
   .clk        ( clk           ),
   .rst_n      ( rst_n         ),
   .bi         ( bi            ),
   .bf         ( bf            ),
   .bg         ( bg            ),
   .bo         ( bo            ),
   .pre_c     ( pre_c         ),
                           
   .lstm_in_valid ( lstm_in_valid ),
   .x          ( lstm_d_in     ),
   .wi         ( wi_in            ),
   .wf         ( wf_in            ),
   .wg         ( wg_in            ),
   .wo         ( wo_in            ),
                           
   .h_o        ( h_o           ),
   .h_o_valid  ( h_o_valid     ),
   .c_o        ( c_o           ),
   .c_o_valid  ( c_o_valid     )
);             



Buffer_h #(
  .D_WL     (D_WL     ),
  .UNITS_NUM(UNITS_NUM),
  .DEPTH    (ALL_CELL_NUM)
)H_buffer_1(
    .clk    ( clk          ),
    .rst_n  ( rst_n&(~prst)),
    .w_en   ( w_en_1       ),
    .w_addr ( w_addr_1     ),
    .r_addr ( r_addr_1     ),
    .d_in   ( h_o          ),
    .d_o    ( h_pre_1      )
);      

Buffer_h #(
  .D_WL     (D_WL     ),
  .UNITS_NUM(UNITS_NUM),
  .DEPTH    (ALL_CELL_NUM)
)H_buffer_2(
    .clk    ( clk          ),
    .rst_n  ( rst_n&(~prst)),
    .w_en   ( w_en_2       ),
    .w_addr ( w_addr_2     ),
    .r_addr ( r_addr_2     ),
    .d_in   ( h_o          ),
    .d_o    ( h_pre_2      )
);                              


Buffer #(
  .D_WL (D_WL*UNITS_NUM),
  .DEPTH(ALL_CELL_NUM/UNITS_NUM)
)C_buffer(
    .clk    ( clk             ),
    .rst_n  ( rst_n&(~prst)   ),
    .w_en   ( c_o_valid       ),
    .w_addr ( c_addr        ),
    .r_addr ( c_addr        ),
    .d_in   ( c_o             ),
    .d_o    ( pre_c      )
);


endmodule
