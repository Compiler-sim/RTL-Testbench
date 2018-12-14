//组合逻辑
module combLogic(
input wire IN_0,
input wire IN_1,
output wire OUT_0,
output wire OUT_1
);
wire net0; 

AND_2_1                    AND_2_1_inst_1(                .IN_1(IN_1),        .IN_0(IN_0),    .OUT(OUT_0));
INV                        INV_inst(                      .IN(IN_1),          .OUT(net0));
AND_2_1                    AND_2_1_inst_2(                .IN_1(IN_0),        .IN_0(net0),    .OUT(OUT_1));

endmodule