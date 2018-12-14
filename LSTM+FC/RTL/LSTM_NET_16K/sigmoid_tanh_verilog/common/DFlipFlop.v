//D ´¥·¢Æ÷
module DFlipFlop #(
parameter DW = 1
) (
input wire clk, //Ê±ÖÓ
input wire [(DW - 1) : 0] D,
output reg [(DW - 1) : 0] OUT
);

always @(posedge clk)begin
    OUT <= D;
end

endmodule