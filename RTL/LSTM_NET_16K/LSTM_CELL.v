module LSTM_CELL #(
    parameter INPUT_SIZE=26,
    parameter FL=12,
    //parameter O_WL=24,
    //parameter W_WL=18,
    parameter D_WL=16
    //parameter B_WL=18
    //parameter bi=0,
    //parameter bf=0,
    //parameter bg=0,
    //parameter bo=0    
    
)(
    input                 clk,
    input                 rst_n,
    input [D_WL-1:0]      x,
    input [D_WL-1:0]      wi,
    input [D_WL-1:0]      wf,
    input [D_WL-1:0]      wg,
    input [D_WL-1:0]      wo,
    input [D_WL-1:0]      bi,
    input [D_WL-1:0]      bf,
    input [D_WL-1:0]      bg,
    input [D_WL-1:0]      bo,
    input [D_WL-1:0]      pre_c,
//    input [D_WL-1:0]      ini_h_in,
    input                 in_valid,

    output reg            h_o_valid,
    output reg[D_WL-1:0]  h_o ,

    output                c_o_valid,
    output [D_WL-1:0]     c_o    
);                              

//reg [D_WL-1:0] ini_c;

wire[D_WL-1:0] pe_d_o_i;
wire[D_WL-1:0] pe_d_o_f;
wire[D_WL-1:0] pe_d_o_g;
wire[D_WL-1:0] pe_d_o_o;

wire  pe_o_valid_i;
wire  pe_o_valid_f;
wire  pe_o_valid_g;
wire  pe_o_valid_o;

PE #(
  .INPUT_SIZE(INPUT_SIZE),
  .FL        (FL        ),
  .D_WL      (D_WL      )
)
gate_i
(
   .clk     ( clk      ),
   .rst_n   ( rst_n    ),
   .x       ( x        ),
   .w       ( wi       ),
   .b       ( bi        ),
   .d_o     ( pe_d_o_i    ),
                      
   .in_valid( in_valid ),
   .o_valid ( pe_o_valid_i) 
);                             


PE #(
  .INPUT_SIZE(INPUT_SIZE), 
  .FL        (FL        ),
  .D_WL      (D_WL      )
)
gate_f
(
   .clk     ( clk      ),
   .rst_n   ( rst_n    ),
   .x       ( x        ),
   .w       ( wf       ),
   .b       ( bf        ),
   .d_o     ( pe_d_o_f      ),
                      
   .in_valid( in_valid ),
   .o_valid ( pe_o_valid_f  ) 
);

PE #(
  .INPUT_SIZE(INPUT_SIZE), 
  .FL        (FL        ),
  .D_WL      (D_WL      )
  //.bias(bg)
)
gate_g
(
   .clk     ( clk      ),
   .rst_n   ( rst_n    ),
   .x       ( x        ),
   .w       ( wg       ),
   .b       ( bg        ),
   .d_o     ( pe_d_o_g    ),
                      
   .in_valid( in_valid ),
   .o_valid ( pe_o_valid_g  ) 
);

PE #(
  .INPUT_SIZE(INPUT_SIZE), 
  .FL        (FL        ),
  .D_WL      (D_WL      )
  //.bias(bo)
)
gate_o
(
   .clk     ( clk      ),
   .rst_n   ( rst_n    ),
   .x       ( x        ),
   .w       ( wo       ),
   .b       ( bo       ),
   .d_o     ( pe_d_o_o    ),
                      
   .in_valid( in_valid ),
   .o_valid ( pe_o_valid_o) 
);

wire [D_WL-1:0] sig_d_o_i;
wire [D_WL-1:0] sig_d_o_f;
wire [D_WL-1:0] sig_d_o_o;
wire [D_WL-1:0] tanh_d_o_g;

wire sig_o_valid_i  ;  
wire sig_o_valid_f  ;
wire sig_o_valid_o  ;
wire tanh_o_valid_g ;

sigmoid_final #(
  .D_WL(D_WL),
  .D_FL(FL)
) sigmoid_i (
   .clk     ( clk         ),
   .rst_n   ( rst_n       ),
   .x       ( pe_d_o_i       ),
                      
   .in_valid( pe_o_valid_i   ),
   //.idle    ( idle_i         ),
   .o_valid ( sig_o_valid_i  ),
   .d_o     ( sig_d_o_i    ) 
);                       
                                                
sigmoid_final #(
  .D_WL(D_WL),
  .D_FL(FL)
) sigmoid_f (
   .clk     ( clk      ),
   .rst_n   ( rst_n    ),
   .x       ( pe_d_o_f),
                      
   .in_valid( pe_o_valid_f ),
   //.idle    ( idle_f   ),
   .o_valid ( sig_o_valid_f  ),
   .d_o     ( sig_d_o_f    ) 
);                       

sigmoid_final #(
  .D_WL(D_WL),
  .D_FL(FL)
) sigmoid_o (
   .clk     ( clk      ),
   .rst_n   ( rst_n    ),
   .x       (pe_d_o_o   ),
                      
   .in_valid( pe_o_valid_o ),
   //.idle    ( idle_o   ),
   .o_valid ( sig_o_valid_o  ),
   .d_o     ( sig_d_o_o   ) 
);       

tanh_final #(
  .D_WL(D_WL),
  .D_FL(FL)
) tanh_g (
   .clk     ( clk         ),
   .rst_n   ( rst_n       ),
   .x       ( pe_d_o_g    ),
                      
   .in_valid( pe_o_valid_g ),
   //.idle    ( idle_g       ),
   .o_valid ( tanh_o_valid_g  ),
   .d_o     ( tanh_d_o_g    ) 
); 

//wire  c_o_valid;
//wire [D_WL-1:0] c_d_o;

get_c #(
  .D_WL(D_WL),
  .D_FL(FL)
  //parameter O_WL=16
)
get_c_inst
(
    .clk     (clk            ),
    .rst_n   (rst_n          ),
    .in_valid(tanh_o_valid_g ),
    .g_f     (sig_d_o_f     ),
    .g_i     (sig_d_o_i     ),
    .g_g     (tanh_d_o_g     ),
    .ini_c   (pre_c   ), 
                      
    .o_valid (c_o_valid ), 
    .d_o     (c_o     ) 
);      

//always @( posedge clk )
//  if( !rst_n || prst )
//    ini_c <= ini_c_in;
//  else if( c_o_valid ) 
//    ini_c <= c_d_o;

wire tanh_o_valid_c;
wire signed [D_WL-1:0] tanh_d_o_c;
wire  idle_c;

tanh_final #(
  .D_WL(D_WL),
  .D_FL(FL)
) get_tanh_c (
   .clk     ( clk         ),
   .rst_n   ( rst_n       ),
   .x       ( c_o ),
                      
   .in_valid( c_o_valid ),
   //.idle    ( idle_c         ),
   .o_valid ( tanh_o_valid_c  ),
   .d_o     ( tanh_d_o_c    ) 
);  

wire signed [D_WL-1:0] g_o_ddd;

g_o_buffer #(
   .DW(D_WL)
)g_o_buffer_inst(
    .clk           (clk           ),
    .rst_n         (rst_n         ),
    .sig_o_valid_o (sig_o_valid_o ),
    .c_o_valid     (c_o_valid     ),
    .tanh_o_valid_c(tanh_o_valid_c),
    .g_o           (sig_d_o_o           ),
    .g_o_ddd       (g_o_ddd       )
);     

wire signed [2*D_WL-1:0] h;
assign h = g_o_ddd*tanh_d_o_c;

reg tanh_o_valid_c_d;  
always @( posedge clk )
  if( !rst_n )
    tanh_o_valid_c_d<=1'b0;
  else
    tanh_o_valid_c_d<=tanh_o_valid_c;  


always @( posedge clk )
  if( !rst_n )
    h_o_valid <= 1'b0;
  else
    h_o_valid <= tanh_o_valid_c_d;         

always @( posedge clk )
  if( !rst_n )
    h_o <= 'h00;
  else if( tanh_o_valid_c_d )
    h_o <= h[D_WL+FL-1:FL]; 






endmodule
