//下降沿检测模块
module negedgeDetect(
input wire clk, //时钟
input wire I, //1bit有效位
output wire O //输出的x的绝对值
);

wire net0, net1;

DFlipFlop #(
.DW     (   1   )
) DFlipFlop_inst(
.clk    (   clk     ),
.D      (   I       ),
.OUT    (   net0    )
);

INV INV_inst(  
.IN(I),
.OUT(net1)
);

AND_2_1 AND_2_1_inst(
.IN_1(net0),
.IN_0(net1),
.OUT(O)
);

endmodule