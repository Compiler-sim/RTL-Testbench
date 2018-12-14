module bf_buffer #(
  parameter D_WL = 24,
  parameter UNITS_NUM = 5
)(
   input [7:0] addr,
   output [UNITS_NUM*D_WL-1:0] w_o
);
//6*5=30；
wire [D_WL*UNITS_NUM-1:0] w_fix [0:5];
assign w_o = w_fix[addr];
assign w_fix[0]='h002f410042040062760057ed004aed;
assign w_fix[1]='h0043b4003a83002da5005625004b44;
assign w_fix[2]='h002c300039db003b6b0050f0003824;
assign w_fix[3]='h0038ea004863005a0e003bf4005cec;
assign w_fix[4]='h00390a004d8900778a004ddd0020b8;
assign w_fix[5]='h002d1f004ad4003ec50032a200456a;

endmodule