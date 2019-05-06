module gpio(
        input wire clk,
        input wire reset,
        input wire [1:0] A,
        input wire WE,
        input wire [31:0] WD,
        input wire [31:0] gpi0,
        input wire [31:0] gpi1,
        output wire [31:0] RD,
        output wire [31:0] gpo0,
        output wire [31:0] gpo1
    );

    wire WE1;
    wire WE2;
    wire [1:0] RdSel;
    wire [31:0] gpo0_out;
    wire [31:0] gpo1_out;

    assign gpo0 = gpo0_out;
    assign gpo1 = gpo1_out;

    gpio_addr_dec gpio_addr_dec(
        .WE(WE),
        .A(A),
        .WE1(WE1),
        .WE2(WE2),
        .RdSel(RdSel)
    );

    gpio_reg #(32) gpo0_reg(
        .clk(clk),
        .rst(reset),
        .D(WD),
        .EN(WE1),
        .Q(gpo0_out)
    );

    gpio_reg #(32) gpo1_reg(
        .clk(clk),
        .rst(reset),
        .D(WD),
        .EN(WE2),
        .Q(gpo1_out)
    );

    mux4 #(32) read_data_mux(
        .sel(RdSel),
        .in0(gpi0),
        .in1(gpi1),
        .in2(gpo0_out),
        .in3(gpo1_out),
        .out(RD)
    );

endmodule