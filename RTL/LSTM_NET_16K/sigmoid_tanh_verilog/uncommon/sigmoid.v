module sigmoid #(
parameter xDW = 24, //输入数据的总位宽
parameter xFL = 14, //输入数据的小数位宽
parameter oDW = 24, //输出数据的总位宽
parameter oFL = 14 //输出数据的小数位宽
)(
input wire clk,
input wire rst,
input wire IN_valid,
input wire signed [(xDW - 1) : 0] x_IN,
output wire signed [(oDW - 1) : 0] OUT, //有符号数，1位整数，14位小数
output wire OUT_valid
);

parameter aDW = 18; //斜率数据的总位宽
parameter aFL = 17; //斜率数据的小数位宽
parameter bDW = 18; //截距数据的总位宽
parameter bFL = 17; //截距数据的小数位宽
parameter numOfDots = 391; //所有切分点的个数，包括左右端点
parameter ML = 196; //以1为起点的中点位置标号
parameter MW = 8;  //表示ML需要的最大位宽

reg IN_valid_reg;

wire rst_n;
wire valid;

wire signed [(xDW - 1) : 0] x;
wire [(xDW - 1) : 0] xAbs;

wire [(aDW - 1) : 0] aHigh;
wire [(bDW - 1) : 0] bHigh;

wire [(aDW - 1) : 0] aLow;
wire [(bDW - 1) : 0] bLow;

wire [(MW - 1) : 0] M;
wire [(MW - 1) : 0] j; //记录当前寻找的区间标号
wire net0;wire net1;wire net2;wire net3;wire net4;wire net5;wire net6;wire net7;wire net8;wire net9;
wire net10;wire net11;wire net12;wire net13;wire net14;wire net15;wire net16;wire net17;wire net18;wire net19;
wire net20;wire net21;wire net22;wire net23;wire net24;wire net25;wire net26;wire net28;
wire net30;wire net32;wire net34;

wire [(aDW - 1) : 0] net39;
wire [(bDW - 1) : 0] net40;
wire [(aDW - 1) : 0] net41;
wire [(bDW - 1) : 0] net42;

wire net43;wire net44;
wire net45;wire net46; wire net47; 

wire net49;
wire net50;
wire net51;

wire [(oDW - 1) : 0] net48;

wire [MW : 0] net37;
wire [MW : 0] net38;

wire [(xDW - 1) : 0] net35;
wire [(xDW - 1) : 0] net36;

wire [(oDW - 1) : 0] net27;
wire [(oDW - 1) : 0] net29;
wire [(oDW - 1) : 0] net31;
wire [(oDW - 1) : 0] net33;

assign M = ML;

assign aHigh = 'd0;
assign bHigh = {1'b0, { (bDW - bFL - 1){1'b0} }, { (bFL){1'b1} }}; //+1

assign aLow = 'd0;
assign bLow = 'd0; //0


posedgeDetect posedgeDetect_inst_1(
.clk    (   clk         ),
.I      (   IN_valid    ),
.O      (   net45       )
);


Register #(
.QW     (   xDW     )
) Register_inst_IN(
.rst_n  (   rst     ),
.clk    (   clk     ),
.valid  (   net45   ),
.Q      (   x_IN    ),
.Q_reg  (   x       )
);


INV INV_inst_1(
.IN     (   net49   ),
.OUT    (   net50   )
);

AND_2_1 AND_2_1_inst_1(
.IN_1   (   rst     ),
.IN_0   (   net50   ),
.OUT    (   net51   )
);

Register #(
.QW     (   1       )
) Register_inst(
.rst_n  (   net51   ),
.clk    (   clk     ),
.valid  (   net45   ),
.Q      (   net45   ),
.Q_reg  (   net47   )
);


Register #(
.QW     (   oDW     )
) Register_inst_OUT(
.rst_n  (   rst     ),
.clk    (   clk     ),
.valid  (   net49   ),
.Q      (   net48   ),
.Q_reg  (   OUT     )
);


INV INV_inst_2(
.IN     (   net45   ),
.OUT    (   net46   )
);


AND_2_1 AND_2_1_inst_2(
.IN_1   (   rst     ),
.IN_0   (   net46   ),
.OUT    (   rst_n   )
);


abs #(
.DW     (   xDW      )
) abs_inst(
.x      (   x       ),
.xAbs   (   xAbs    )
);


forLoop #(
.jW         (   MW      )
) forLoop_inst(
.en         (   net2    ),
.rst_n      (   rst_n   ),
.clk        (   clk     ),
.forValid   (   net14   ),
.j          (   j       ),
.valid      (   net0    )
);


AND_2_1 AND_2_1_inst_3(
.IN_1       (   net0    ),
.IN_0       (   net3    ),
.OUT        (   net43   )
);


AND_2_1 AND_2_1_inst_4(
.IN_1       (   net0    ),
.IN_0       (   net4    ),
.OUT        (   net44   )
);


halfXListShift_sigmoid #(
.xDW        (   xDW     ),
.ML         (   ML      ),
.MW         (   MW      )
) halfXListShift_inst(
.j          (   j       ),
.half_j     (   net35   ),
.half_j_1   (   net36   )
);


biggerOrEqual #(
.xDW    (   xDW     )
) biggerOrEqual_inst_1(
.en     (   net47   ),
.rst_n  (   rst_n   ),
.clk    (   clk     ),
.x      (   x       ),
.OUT    (   net1    ),
.valid  (   net2    )
);


combLogic combLogic_inst_1(
.IN_0   (   net2    ),
.IN_1   (   net1    ),
.OUT_0  (   net3    ),
.OUT_1  (   net4    )
);


biggerOrEqualAndSmaller #(
.xDW    (   xDW   )
) biggerOrEqualAndSmaller_inst(
.en     (   net43   ),
.rst_n  (   rst_n   ),
.a      (   net35   ),
.b      (   net36   ),
.xAbs   (   xAbs    ),
.OUT    (   net5    ),
.valid  (   net6    )
);


biggerAndSmallerOrEqual #(
.xDW    (   xDW   )
) biggerAndSmallerOrEqual_inst(
.en     (   net44   ),
.rst_n  (   rst_n   ),
.a      (   net35   ),
.b      (   net36   ),
.xAbs   (   xAbs    ),
.OUT    (   net7    ),
.valid  (   net8    )
);


combLogic combLogic_inst_2(
.IN_0   (   net6    ),
.IN_1   (   net5    ),
.OUT_0  (   net9    ),
.OUT_1  (   net10   )
); 


combLogic combLogic_inst_3(
.IN_0   (   net8    ),
.IN_1   (   net7    ),
.OUT_0  (   net11   ),
.OUT_1  (   net12   )
); 


OR_2_1 OR_2_1_inst_1(
.IN_1   (   net9    ),
.IN_0   (   net11   ),
.OUT    (   net13   )
);


OR_2_1 OR_2_1_inst_2(
.IN_1   (   net10   ),
.IN_0   (   net12   ),
.OUT    (   net14   )
);   


equal #(
.MW     (   MW  )
) equal_inst(
.en     (   net13   ),
.rst_n  (   rst_n   ),
.clk    (   clk     ),
.M      (   M       ),
.j      (   j       ),
.OUT    (   net15   ),
.valid  (   net16   )
);


combLogic combLogic_inst_4(
.IN_0   (   net16   ),
.IN_1   (   net15   ),
.OUT_0  (   net17   ),
.OUT_1  (   net18   )
); 


bigger #(
.xDW    (   xDW     )
) bigger_inst(
.en     (   net17   ),
.rst_n  (   rst_n   ),
.clk    (   clk     ),
.x      (   x       ),
.OUT    (   net19   ),
.valid  (   net20   )
);


biggerOrEqual #(
.xDW    (   xDW     )
) biggerOrEqual_inst_2(
.en     (   net18   ),
.rst_n  (   rst_n   ),
.clk    (   clk     ),
.x      (   x       ),
.OUT    (   net21   ),
.valid  (   net22   )
);


calcIndex #(
.MW     (   MW      )
) calcIndex_inst(
.en     (   net18   ),
.rst_n  (   rst_n   ),
.M      (   M       ),
.j      (   j       ),
.i_0    (   net37   ),
.i_1    (   net38   )
);


createAandB_sigmoid #(
.aDW        (   aDW         ),
.bDW        (   bDW         ),
.numOfDots  (   numOfDots   ), //所有切分点的个数，包括左右端点
.MW         (   MW          )
) createAandB_inst_1(
.en         (   net25   ),
.rst_n      (   rst_n   ),
.i          (   net37   ),
.a          (   net39   ),
.b          (   net40   )
);


createAandB_sigmoid #(
.aDW        (   aDW         ),
.bDW        (   bDW         ),
.numOfDots  (   numOfDots   ), //所有切分点的个数，包括左右端点
.MW         (   MW          )
) createAandB_inst_2(
.en         (   net26   ),
.rst_n      (   rst_n   ),
.i          (   net38   ),
.a          (   net41   ),
.b          (   net42   )
);


combLogic combLogic_inst_5(
.IN_0   (   net20   ),
.IN_1   (   net19   ),
.OUT_0  (   net23   ),
.OUT_1  (   net24   )
);


combLogic combLogic_inst_6(
.IN_0   (   net22   ),
.IN_1   (   net21   ),
.OUT_0  (   net25   ),
.OUT_1  (   net26   )
); 


calcModule #(
.xDW    (   xDW   ),
.xFL    (   xFL   ),
.aDW    (   aDW   ),
.aFL    (   aFL   ),
.bDW    (   bDW   ),
.bFL    (   bFL   ),
.oDW    (   oDW   ),
.oFL    (   oFL   )
) calcModule_inst_1(
.en     (   net23   ),
.rst_n  (   rst_n   ),
.clk    (   clk     ),
.x      (   x       ),
.a      (   aHigh   ),
.b      (   bHigh   ),
.OUT    (   net27   ),
.valid  (   net28   )
);


calcModule #(
.xDW    (   xDW   ),
.xFL    (   xFL   ),
.aDW    (   aDW   ),
.aFL    (   aFL   ),
.bDW    (   bDW   ),
.bFL    (   bFL   ),
.oDW    (   oDW   ),
.oFL    (   oFL   )
) calcModule_inst_2(
.en     (   net24   ),
.rst_n  (   rst_n   ),
.clk    (   clk     ),
.x      (   x       ),
.a      (   aLow    ),
.b      (   bLow    ),
.OUT    (   net29   ),
.valid  (   net30   )
);


calcModule #(
.xDW    (   xDW   ),
.xFL    (   xFL   ),
.aDW    (   aDW   ),
.aFL    (   aFL   ),
.bDW    (   bDW   ),
.bFL    (   bFL   ),
.oDW    (   oDW   ),
.oFL    (   oFL   )
) calcModule_inst_3(
.en     (   net25   ),
.rst_n  (   rst_n   ),
.clk    (   clk     ),
.x      (   x       ),
.a      (   net39   ),
.b      (   net40   ),
.OUT    (   net31   ),
.valid  (   net32   )
);


calcModule #(
.xDW    (   xDW   ),
.xFL    (   xFL   ),
.aDW    (   aDW   ),
.aFL    (   aFL   ),
.bDW    (   bDW   ),
.bFL    (   bFL   ),
.oDW    (   oDW   ),
.oFL    (   oFL   )
) calcModule_inst_4(
.en     (   net26   ),
.rst_n  (   rst_n   ),
.clk    (   clk     ),
.x      (   x       ),
.a      (   net41   ),
.b      (   net42   ),
.OUT    (   net33   ),
.valid  (   net34   )
);


MUX_4_1 #(
.DW     (   oDW     )
) MUX_4_1_inst(
.rst_n  (   rst_n   ),
.clk    (   clk     ),
.sel_0  (   net28   ),
.sel_1  (   net30   ),
.sel_2  (   net32   ),
.sel_3  (   net34   ),
.IN_0   (   net27   ),
.IN_1   (   net29   ),
.IN_2   (   net31   ),
.IN_3   (   net33   ),
.OUT    (   net48   ),
.valid  (   valid   )
);


posedgeDetect posedgeDetect_inst_2(
.clk    (   clk     ),
.I      (   valid   ),
.O      (   net49   )
);


negedgeDetect negedgeDetect_inst(
.clk    (   clk         ),
.I      (   net49       ),
.O      (   OUT_valid   )
);


endmodule
