module bg_buffer #(
  parameter D_WL = 24,
  parameter UNITS_NUM = 5
)(
   input [7:0] addr,
   output [UNITS_NUM*D_WL-1:0] w_o
);

wire [D_WL*UNITS_NUM-1:0] w_fix [0:5];
assign w_o = w_fix[addr];
assign w_fix[0]='h00017cffedda00030800089afffabe;
assign w_fix[1]='h00021a000019fff8edfff21cfffde1;
assign w_fix[2]='h0007020000c4fffe3dfff826000302;
assign w_fix[3]='h00062e0005a700068500025f0005ba;
assign w_fix[4]='hfffba600017cfff2620003370003eb;
assign w_fix[5]='hfffd9e0001b200028cfffeadfff993;

endmodule