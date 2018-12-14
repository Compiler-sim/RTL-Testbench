module bo_buffer #(
  parameter D_WL = 24,
  parameter UNITS_NUM = 5
)(
   input [7:0] addr,
   output [UNITS_NUM*D_WL-1:0] w_o
);

wire [D_WL*UNITS_NUM-1:0] w_fix [0:5];
assign w_o = w_fix[addr];
assign w_fix[0]='h000ee1ffee0f00047200060ffff950;
assign w_fix[1]='hfff243fff578fff36d0001d20000eb;
assign w_fix[2]='hfff213fff2dbfff08f0009e6ffeae6;
assign w_fix[3]='hffee59ffe75700011e000ac6000491;
assign w_fix[4]='hfff027fffb2c00126afffbb8ffea99;
assign w_fix[5]='hffe980fff908fff497ffe8ff000f55;

endmodule