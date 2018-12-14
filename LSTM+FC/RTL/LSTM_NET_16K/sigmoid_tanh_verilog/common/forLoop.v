//控制for循环的起止
module forLoop #(
parameter jW = 5
)(
input wire en, //使能端，=1工作，=0不工作且输出valid=0&OUT=0
input wire rst_n,
input wire clk, //时钟
input wire forValid, //=0则保持j，=1则将j加1
output reg [(jW - 1) : 0] j, //第j次for循环，j从1开始
output reg valid //输出是否有效
);

wire EN;

AND_2_1 AND_2_1_inst(
.IN_1   (   en      ),
.IN_0   (   rst_n   ),
.OUT    (   EN      )
);

always @(posedge clk)begin
    if(EN == 1'b0)
        valid <= 1'b0;
    else
        valid <= 1'b1;
end

always @(posedge clk)begin
    if(EN == 1'b0)
        j <= 'd1; //j从1开始
    else begin
        if(forValid == 1'b1)
            j <= j + 'd1;
        else
            j <= j;
    end
end

endmodule