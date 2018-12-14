//�����ؼ��ģ��
module posedgeDetect(
input wire clk, //ʱ��
input wire I, //1bit��Чλ
output wire O //�����x�ľ���ֵ
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
.IN(net0),
.OUT(net1)
);

AND_2_1 AND_2_1_inst(
.IN_1(I),
.IN_0(net1),
.OUT(O)
);

endmodule