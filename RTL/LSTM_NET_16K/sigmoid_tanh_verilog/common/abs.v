//求16位有符号数的绝对值
module abs #(
parameter DW = 16
)(
input wire signed [(DW - 1) : 0] x, //输入16位有符号数
output reg [(DW - 1) : 0] xAbs //输出的x的绝对值
);

always @* begin
    if(x < 0)
        xAbs = ~x + 1'b1;
    else
        xAbs = x;
end

endmodule