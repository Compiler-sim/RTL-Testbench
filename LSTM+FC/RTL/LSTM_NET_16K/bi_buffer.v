module bi_buffer #(
  parameter D_WL = 24,
  parameter UNITS_NUM = 5
)(
   input [7:0] addr,
   output [UNITS_NUM*D_WL-1:0] w_o
);

wire [D_WL*UNITS_NUM-1:0] w_fix [0:5];
assign w_o = w_fix[addr];
assign w_fix[0]='h00024bffb2f4fff286000975ffc6ae;
assign w_fix[1]='hffe4d1fff192ffe85affe555001608;
assign w_fix[2]='hfff3b6ffe019ffe431ffd753ffe0df;
assign w_fix[3]='hffe8b7ffe7b4ffef0ffff2c8fff549;
assign w_fix[4]='hffe385fff65fffb256ffd636ffdafc;
assign w_fix[5]='hffe87afff556ffd0a1fff0a6000436;

endmodule