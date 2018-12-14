

module RAM #(
   parameter DEPTH = 256,
   parameter WIDTH_A = 8,
   parameter WIDTH_D = 16
)(
  input                    clk,
  input                    rst_n,
                           
  input [WIDTH_A-1:0]      w_addr,   
  input [WIDTH_D-1:0]             w_data,
  input                    w_en,
  
  input [WIDTH_A-1:0]      r_addr,
  input                    r_en,
  
  output [WIDTH_D-1:0]         r_data
);


reg [WIDTH_D-1:0]  mem[0:DEPTH-1];

integer i;
always @( posedge clk )
  if( !rst_n )
    for(i=0;i<DEPTH;i=i+1)
      mem[i] <= 'h0000;
  else if( w_en )
    mem[w_addr] <= w_data;
    
//always @( posedge r_clk )
//  if( !rst_n )
//    r_data <= 'h0000;
//  else if( r_en )
assign  r_data = mem[r_addr];
    
endmodule  