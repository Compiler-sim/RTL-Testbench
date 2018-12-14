//判断16位有符号数是否大于等于0
module biggerOrEqual #(
parameter xDW = 16
)(
input wire en, //使能端，=1工作，=0不工作且输出valid=0&OUT=0
input wire rst_n,
input wire clk, //时钟
input wire signed [(xDW -1 ) : 0] x, //输入16位有符号数
output reg OUT, //输出，判断为真=1，假=0
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
        OUT <= 1'b0;
    else begin
        if(x >= 0)
            OUT <= 1'b1;
        else
            OUT <= 1'b0;
    end
end

endmodule