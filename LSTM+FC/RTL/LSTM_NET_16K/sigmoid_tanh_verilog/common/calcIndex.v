module calcIndex #(
parameter MW = 5
)(
input wire en,
input wire rst_n,
input wire [(MW - 1) : 0] M,
input wire [(MW - 1) : 0] j,
output reg [MW : 0] i_0,
output reg [MW : 0] i_1
);

wire EN;

AND_2_1    AND_2_1_inst(  .IN_1(en),    .IN_0(rst_n),    .OUT(EN));

always @* begin
    if(EN == 1'b1) begin
        i_0 = M + j - 1;
    end
    else begin
        i_0 = 'd0;
    end
end

always @* begin
    if(EN == 1'b1) begin
        i_1 = M - j;
    end
    else begin
        i_1 = 'd0;
    end
end

endmodule