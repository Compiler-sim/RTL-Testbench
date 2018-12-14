// ¹«ÖÚºÅ: Ğ¡ÓãFPGA
// Engineer: littlefish

module BuadRate_set #(
  parameter CLK_Period=50000000,//the unit is Hz
  parameter Buad_Rate=9600 //the unit is bits/s
)(
   input      clk,
   input      rst_n,
   input      enable,
   output     Buad_clk
);

localparam DIV_PEREM=CLK_Period/Buad_Rate/2;
reg[15:0] cnt;

always @( posedge clk )
  if( !rst_n )
    cnt <= 16'b0000;
  else if( enable ) begin
    if( cnt != DIV_PEREM )
      cnt <= cnt+1'b1;	  
    else	  
      cnt <= 16'h0000;
  end
  else
    cnt <= 16'h0000;

reg DIV_clk;

always @( posedge clk )
  if( !rst_n || !enable )
    DIV_clk <= 1'b1;
  else if(cnt==DIV_PEREM)
    DIV_clk <= ~DIV_clk;

assign Buad_clk = DIV_clk;
    
endmodule
