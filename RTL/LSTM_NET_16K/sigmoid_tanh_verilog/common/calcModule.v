//计算a*x+b的值，输出也是16位数
module calcModule #(
parameter xDW = 16,
parameter xFL = 11,
parameter aDW = 16,
parameter aFL = 15,
parameter bDW = 16,
parameter bFL = 15,
parameter oDW = 16,
parameter oFL = 14
)(
input wire en, //使能端，=1工作，=0不工作且输出valid=0&OUT=0
input wire rst_n,
input wire clk, //时钟
input wire signed [(xDW - 1) : 0] x, //xDW位有符号数，输入，xDW - xFL - 1位整数，xFL位小数
input wire signed [(aDW - 1) : 0] a, //aDW位有符号数，斜率，aDW - aFL - 1位整数，aFL位小数
input wire signed [(bDW - 1) : 0] b, //bDW位有符号数，截距，bDW - bFL - 1位整数，bFL位小数
output reg [(oDW - 1) : 0] OUT, //输出，oDW位有符号数，oDW - oFL - 1位整数，oFL位小数
output reg valid //输出是否有效
);

parameter maxFL = (xFL > aFL) ? ((xFL > bFL) ? xFL : bFL) : ((aFL > bFL) ? aFL : bFL); //求出最大小数位宽

parameter xZL = xDW - xFL - 1;
parameter aZL = aDW - aFL - 1;
parameter bZL = bDW - bFL - 1;

parameter maxZL = (xZL > aZL) ? ((xZL > bZL) ? xZL : bZL) : ((aZL > bZL) ? aZL : bZL); //求出最大整数位宽

parameter totalW = maxZL + maxFL + 1;
parameter multiW = 2 * totalW;
parameter multiFL = 2 * maxFL;
parameter multiZL = 2 * maxZL;

wire EN;

wire signed [(multiW - 1) : 0] a_Multi_x;

wire signed [(totalW - 1) : 0] newX;
wire signed [(totalW - 1) : 0] newA;
wire signed [(multiW - 1) : 0] newB;
wire signed [multiW : 0] tempOut;

//wire [38:0] compOut;
//wire [37:0] b_abs;
//wire [37:0] a_Multi_x_abs;
//wire [38:0] a_Multi_x;
//wire sign_b;

AND_2_1 AND_2_1_inst(
.IN_1   (   en      ),
.IN_0   (   rst_n   ),
.OUT    (   EN      )
);

assign newX = {{ (maxZL - xZL){x[xDW - 1]} }, x, { (maxFL - xFL){1'b0} }}; //拼接20位有符号数，整数4位，小数15位
assign newA = {{ (maxZL - aZL){a[aDW - 1]} }, a, { (maxFL - aFL){1'b0} }}; //拼接20位有符号数，整数4位，小数15位

assign newB = {{ (multiZL - bZL + 1){b[bDW - 1]} }, b, { (multiFL - bFL){1'b0} }}; //拼接40位有符号数，整数8位，小数30位

assign a_Multi_x = newX * newA; //40位，最高2位均是符号位 剩下的38位中，整数8位，小数30位

assign tempOut = a_Multi_x + newB;

always @(posedge clk)begin
    if(EN == 1'b0)
        valid <= 1'b0;
    else
        valid <= 1'b1;
end

always @(posedge clk)begin
    if(EN == 1'b0)
        OUT <= 16'b0;
    else begin
        OUT <= {tempOut[multiW], tempOut[(multiFL - oFL + (oDW - 1) - 1) : (multiFL - oFL)]};
    end
end

//assign sign_a_Multi_x = a[15] ^ x[15]; //异或，求a*x的符号位
//assign a_Multi_x_abs = newA * newX; //求a*x不包括符号位的值，整数8位，小数30位
//assign a_Multi_x = (sign_a_Multi_x == 1'b0) ? {1'b0, a_Multi_x_abs} : {1'b1, (( ~a_Multi_x_abs ) + 1'b1)}; //求a*x的补码

//assign sign_b = b[15]; //b的符号位
//assign b_abs = {8'b0, b[14:0], 15'b0}; //b不包括符号位的值
//assign newB = (sign_b == 1'b0) ? {1'b0, b_abs} : {1'b1, (( ~b_abs ) + 1'b1)}; //求b的补码

//assign compOut = a_Multi_x + newB; //补码相加的结果还是补码
//assign tempOut = (compOut[38] == 1'b0) ? compOut[37:0] : (( ~compOut[37:0] ) + 1'b1); //求不包括符号的原码

//always @(posedge clk)begin
//    if(EN == 1'b0)
//        valid <= 1'b0;
//    else
//        valid <= 1'b1;
//end

//always @(posedge clk)begin
//    if(EN == 1'b0)
//        OUT <= 16'b0;
//    else begin
//        OUT <= {compOut[38], tempOut[30:16]};
//    end
//end

endmodule