//1bit或门
module OR_2_1(
input wire IN_1,
input wire IN_0,
output wire OUT
);

assign OUT = IN_1 | IN_0;

endmodule