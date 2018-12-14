//1bit反相器
module INV(
input wire IN,
output wire OUT
);

assign OUT = ~IN;

endmodule