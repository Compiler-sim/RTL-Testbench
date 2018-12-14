module PE #(
  parameter INPUT_SIZE=226,
  parameter FL=12,
  parameter D_WL=16
 // parameter O_WL=20,
 // parameter W_WL=18,
  //parameter D_WL=18,
 // parameter B_WL=18
  //parameter bias=0        
)(
   input             clk,
   input             rst_n,
   input [D_WL-1:0]  x,
   input [D_WL-1:0]  w,
   input [D_WL-1:0]  b,
   output reg[D_WL-1:0]  d_o,

   input             in_valid,
   output reg        o_valid
);                             

wire signed [2*D_WL-1:0] x_in;
assign x_in = {{(D_WL){x[D_WL-1]}},x};
wire signed [2*D_WL-1:0] w_in;
assign w_in = {{(D_WL){w[D_WL-1]}},w};
wire signed [2*D_WL-1:0] b_in;
assign b_in = {{(D_WL-FL){b[D_WL-1]}},b,{(FL){1'b0}}};

reg[7:0] cnt;
always @( posedge clk ) 
  if( !rst_n )
    cnt<='h0;
  else if( in_valid ) begin
    if( cnt!=INPUT_SIZE-1 )	  
      cnt<=cnt+1'b1;
    else 
      cnt<='h0;	    
  end                       
  //else
    //cnt<=8'h00;

reg signed [2*D_WL-1:0] d_o_d;
wire signed [2*D_WL-1:0] XW;
//wire signed [2*O_WL-1:0] dd;
assign XW=x_in*w_in;
//assign dd=XW[O_WL+FL-1:FL];

always @( posedge clk )
  if( !rst_n )
    d_o_d<=b_in;
  else if( in_valid ) begin
    if( cnt==8'h00 )
      d_o_d <= XW+b_in;
    else
      d_o_d <= d_o_d+XW;
  end

reg o_valid_p;
always @( posedge clk )
  if( !rst_n )
    o_valid_p <= 1'b0;
  else if( cnt==INPUT_SIZE-1 && in_valid )
    o_valid_p <= 1'b1;
  else
    o_valid_p <= 1'b0;	  

always @( posedge clk )
  if( !rst_n )
    d_o <= 'h0;
  else if( o_valid_p )
    d_o = d_o_d[D_WL+FL-1:FL];

always @( posedge clk )
  if( !rst_n )
   o_valid <= 1'b0;
  else
   o_valid <= o_valid_p;	  

endmodule	  
    	  
