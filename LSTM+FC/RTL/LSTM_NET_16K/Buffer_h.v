module Buffer_h #(
  parameter UNITS_NUM=5,
  parameter D_WL =22,
  parameter DEPTH=26
)(
    input                        clk   ,
    input                        rst_n ,
    input                        w_en  ,
    input [7:0]                  w_addr,
    input [7:0]                  r_addr,
    input [UNITS_NUM*D_WL-1:0]    d_in ,
    output [D_WL-1:0]             d_o 
);                               

reg [D_WL-1:0]  mem [0:DEPTH-1];

integer i;
always @( posedge clk )
  if( !rst_n )
    for (i=0;i<DEPTH;i=i+1)
      mem[i] <= 'h0;
  else if( w_en ) begin
      mem[w_addr] <= d_in[D_WL-1:0];
      mem[w_addr+1] <= d_in[D_WL*2-1:D_WL];
      mem[w_addr+2] <= d_in[D_WL*3-1:D_WL*2];
      mem[w_addr+3] <= d_in[D_WL*4-1:D_WL*3];
      mem[w_addr+4] <= d_in[D_WL*5-1:D_WL*4];
  end

assign d_o = mem[r_addr];

endmodule


