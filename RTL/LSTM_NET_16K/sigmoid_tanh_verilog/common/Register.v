//ÊäÈë´æ´¢Ä£¿é
module Register #(
parameter QW = 16
)(
input wire rst_n,
input wire clk, //Ê±ÖÓ
input wire valid,
input wire [(QW - 1) : 0] Q,
output reg [(QW - 1) : 0] Q_reg
);

always @(posedge clk) begin
    if(rst_n == 0)
        Q_reg <= 'd0;
    else
        if(valid == 1)
            Q_reg <= Q;
        else
            Q_reg <= Q_reg;
end

endmodule