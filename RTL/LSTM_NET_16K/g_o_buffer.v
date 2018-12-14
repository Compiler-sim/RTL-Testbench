module  g_o_buffer #(
   parameter DW=16
)(
    input              clk,
    input              rst_n,
    input              sig_o_valid_o ,
    input              c_o_valid     ,
    input              tanh_o_valid_c,
    input [DW-1:0]     g_o,
    output reg[DW-1:0] g_o_ddd
);                                    

reg [DW-1:0] g_o_d;
reg [DW-1:0] g_o_dd;

    always @( posedge clk )
      if( !rst_n )
        g_o_d<='h0;
      else if(sig_o_valid_o)
	g_o_d<=g_o;

    always @( posedge clk )
      if( !rst_n )
	g_o_dd<='h0;
      else if( c_o_valid )
	g_o_dd<=g_o_d;

    always @( posedge clk )
      if( !rst_n )
        g_o_ddd<='h0;
      else if( tanh_o_valid_c )
	g_o_ddd<=g_o_dd;

endmodule
