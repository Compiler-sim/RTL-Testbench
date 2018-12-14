module f_w_buffer #(
   parameter D_WL      =24,
   parameter INPUT_SIZE=30,
   parameter UNITS_NUM =2
)(
   input                          clk  ,
   input                          rst_n,
   input                          r_en ,
   output   [UNITS_NUM*D_WL-1:0]  w_o
);                                        

reg [7:0] addr;
wire [D_WL*UNITS_NUM-1:0] w_fix[0:INPUT_SIZE-1];
always @( posedge clk )
  if( !rst_n )
    addr <= 'h00;
  else if( r_en ) begin
    if( addr!=INPUT_SIZE-1 )
      addr = addr+1'b1;
    else
      addr = 'h00;
  end

assign w_o=w_fix[addr];

assign w_fix[0]='h00334affcdca;
assign w_fix[1]='hffd2fa002d48;
assign w_fix[2]='hffc45f003b82;
assign w_fix[3]='h0014a2ffeba8;
assign w_fix[4]='hffe1d1001e97;
assign w_fix[5]='hfff2f8000ccc;
assign w_fix[6]='h000767fff862;
assign w_fix[7]='h001341ffedaf;
assign w_fix[8]='h003547ffca45;
assign w_fix[9]='hffc8b300375c;
assign w_fix[10]='hffe57f001b0e;
assign w_fix[11]='h0026e5ffd907;
assign w_fix[12]='hffd90f002722;
assign w_fix[13]='hfff2dc000c7a;
assign w_fix[14]='hfff0cb000e31;
assign w_fix[15]='hfffaac00064e;
assign w_fix[16]='hffc31e003c83;
assign w_fix[17]='hffbad6004562;
assign w_fix[18]='hffdee900210d;
assign w_fix[19]='hffe65f001829;
assign w_fix[20]='h0022bcffde26;
assign w_fix[21]='hffc1a9003ec1;
assign w_fix[22]='h004472ffbc30;
assign w_fix[23]='hffd76b002896;
assign w_fix[24]='h003ef6ffc0bd;
assign w_fix[25]='h001de2ffe2b6;
assign w_fix[26]='h000350fffbe4;
assign w_fix[27]='hffe9e800159a;
assign w_fix[28]='hffdb9400239a;
assign w_fix[29]='h001529ffea7d;

endmodule
