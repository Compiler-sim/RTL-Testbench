module Buffer #(
  parameter D_WL =22,
  parameter DEPTH=26
)(
    input                        clk   ,
    input                        rst_n ,
    input                        w_en  ,
    input [7:0]                  w_addr,
    input [7:0]                  r_addr,
    input [D_WL-1:0]             d_in ,
    output [D_WL-1:0]             d_o 
);                               

reg [D_WL-1:0]  mem [0:DEPTH-1];

integer i;
always @( posedge clk )
  if( !rst_n )
    for (i=0;i<DEPTH;i=i+1)
      mem[i] <= 'h0;
  else if( w_en )
      mem[w_addr] <= d_in;

assign d_o = mem[r_addr];

endmodule


