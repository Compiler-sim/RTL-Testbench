module get_c #(
  parameter D_WL=16,
  parameter D_FL=12
  //parameter O_WL=16
)(
  input             clk,
  input             rst_n,
  input             in_valid,
  input [D_WL-1:0]  g_f,
  input [D_WL-1:0]  g_i,
  input [D_WL-1:0]  g_g,
  input [D_WL-1:0]  ini_c, 

  output reg        o_valid,
  output reg [D_WL-1:0] d_o
);                           

reg signed [2*D_WL-1:0] g_f_in;
reg signed [2*D_WL-1:0] g_i_in;
reg signed [2*D_WL-1:0]   g_g_in;
reg signed [2*D_WL-1:0]   ini_c_in;

always @( posedge clk )
  if( !rst_n )
    g_f_in <= 'h0;
  else if( in_valid )
    g_f_in <= {{(D_WL){g_f[D_WL-1]}},g_f};

always @( posedge clk )
  if( !rst_n )
    g_i_in <= 'h0;
  else if( in_valid )
    g_i_in <= {{(D_WL){g_i[D_WL-1]}},g_i};

always @( posedge clk )
  if( !rst_n )
    ini_c_in <= 'h0;
  else if( in_valid )
    ini_c_in <={{(D_WL){ini_c[D_WL-1]}},ini_c};	  

always @( posedge clk )
  if( !rst_n )
    g_g_in <= 'h0;
  else if(in_valid)
    g_g_in <= {{(D_WL){g_g[D_WL-1]}},g_g};

reg signed [2*D_WL-1:0] fxc,ixg;

always @( posedge clk )
  if( !rst_n )
    fxc <= 'h0;
  else	  
    fxc<=g_f_in*ini_c_in;

always @( posedge clk )
  if( !rst_n )
    ixg<='h0;
  else	  
    ixg<=g_i_in*g_g_in;

wire signed [2*D_WL-1:0] c;
assign c = fxc[2*D_WL-1:0]+ixg[2*D_WL-1:0];

always @( posedge clk )
  if( !rst_n )
    d_o <= 'h0;
  else  
    d_o <= c[D_FL+D_WL-1:D_FL];

reg in_valid_d;
always @( posedge clk )
  if( !rst_n )
    in_valid_d <= 1'b0;
  else
    in_valid_d <= in_valid;

reg o_valid_p;
always @( posedge clk )
  if( !rst_n )
    o_valid_p <= 1'b0;
  else if( in_valid_d )
    o_valid_p <= 1'b1;
  else
    o_valid_p <= 1'b0;	  


always @( posedge clk )
  if( !rst_n )
    o_valid <= 1'b0;
  else
    o_valid <= o_valid_p;


endmodule
