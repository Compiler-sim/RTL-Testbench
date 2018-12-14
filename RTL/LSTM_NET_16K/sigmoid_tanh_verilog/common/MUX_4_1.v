//四输入选择器，输入为16bit数
module MUX_4_1 #(
parameter DW = 16
)(
input wire rst_n,
input wire clk, //时钟
input wire sel_0,
input wire sel_1,
input wire sel_2,
input wire sel_3,
input wire [(DW - 1) : 0] IN_0,
input wire [(DW - 1) : 0] IN_1,
input wire [(DW - 1) : 0] IN_2,
input wire [(DW - 1) : 0] IN_3,
output reg [(DW - 1) : 0] OUT,
output reg valid
);

wire [3:0] sel;

assign sel = {sel_3,sel_2,sel_1,sel_0};

always @(posedge clk) begin
    if(rst_n == 1'b0)
        valid <= 1'b0;
    else begin
        case(sel)
        4'b0000 :
            valid <= 1'b0;
        4'b0001 :
            valid <= 1'b1;
        4'b0010 :
            valid <= 1'b1;
        4'b0100 :
            valid <= 1'b1;
        4'b1000 :
            valid <= 1'b1;
        default :
            valid <= 1'b0;
        endcase
    end
end

always @(posedge clk) begin
    if(rst_n == 1'b0)
        OUT <= 'd0;
    else begin
        case(sel)
        4'b0001 :
            OUT <= IN_0;
        4'b0010 :
            OUT <= IN_1;
        4'b0100 :
            OUT <= IN_2;
        4'b1000 :
            OUT <= IN_3;
        default :
            OUT <= 'd0;
        endcase
    end
end

endmodule