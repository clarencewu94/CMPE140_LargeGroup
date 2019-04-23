module factorial #(parameter DATA_WIDTH = 32)(
    input rst, clk,
    input Go,
    input wire [DATA_WIDTH-1:0] n,
    output wire Done, Error,
    output [DATA_WIDTH-1:0] product
    
);

    wire x_gt_1, x_gt_12;
    wire ld_CNT, en_CNT, ld_REG, sel_MUX, OE_BUF;

    factorial_cu #(.DATA_WIDTH(DATA_WIDTH)) FACT_CU(
        .Go(Go),
        .rst(rst),
        .clk(clk),
        .Error(Error),
        .Done(Done),
        .x_gt_1(x_gt_1),
        .x_gt_12(x_gt_12),
        .ld_CNT(ld_CNT),
        .ld_REG(ld_REG),
        .en_CNT(en_CNT),
        .sel_MUX(sel_MUX),
        .OE_BUF(OE_BUF)
    );

    factorial_dp FACT_DP(
        .clk(clk),
        .n(n),
        .x_GT_1(x_gt_1),
        .x_GT_12(x_gt_12),
        .product(product),
        .ld_CNT(ld_CNT),
        .ld_REG(ld_REG),
        .en_CNT(en_CNT),
        .sel_MUX(sel_MUX),
        .OE_BUF(OE_BUF)
    );


endmodule