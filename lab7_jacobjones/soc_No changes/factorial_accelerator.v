module factorial_accelerator(
        input wire clk,
        input wire reset,
        input wire [1:0] A,
        input wire WE,
        input wire [3:0] WD,
        output wire [31:0] RD
    );

    wire WE1;
    wire WE2;
    wire [1:0] RdSel;
    wire go_out;
    wire [3:0] n_out;
    wire GoPulseIn;
    wire GoPulseOut;
    wire Done;
    wire Err;
    wire [31:0] product;
    wire [31:0] result;
    wire ResDone;
    wire ResErr;
    wire [31:0] ctrl_out;
    wire [31:0] n_out_mux;
    wire [31:0] go_out_mux;

    assign GoPulseIn = WD[0] & WE2;
    assign ctrl_out = {30'b0, ResErr, ResDone};
    assign n_out_mux = {28'b0, n_out};
    assign go_out_mux = {31'b0, go_out};

    factorial_addr_dec factorial_addr_dec(
        .WE(WE),
        .A(A),
        .WE1(WE1),
        .WE2(WE2),
        .RdSel(RdSel)
    );

    factorial_reg #(1) go_reg(
        .clk(clk),
        .rst(reset),
        .D(WD[0]),
        .EN(WE2),
        .Q(go_out)
    );

    factorial_reg #(1) go_pulse_reg(
        .clk(clk),
        .rst(reset),
        .D(GoPulseIn),
        .EN(1'b1),
        .Q(GoPulseOut)
    );

    factorial_reg #(4) n_reg(
        .clk(clk),
        .rst(reset),
        .D(WD),
        .EN(WE1),
        .Q(n_out)
    );

    factorial #(4) factorial (
        .rst(reset),
        .clk(clk),
        .Go(GoPulseOut),
        .n(n_out),
        .Done(Done),
        .Error(Err),
        .product(product)
    );

    factorial_reg #(32) product_reg(
        .clk(clk),
        .rst(reset),
        .D(product),
        .EN(Done),
        .Q(result)
    );

    factorial_done_reg factorial_done_reg (
        .rst(reset),
        .clk(clk),
        .Done(Done),
        .GoPulse(GoPulseIn),
        .ResDone(ResDone)
    );

    factorial_err_reg factorial_err_reg (
        .rst(reset),
        .clk(clk),
        .Err(Err),
        .GoPulse(GoPulseIn),
        .ResErr(ResErr)
    );

    mux4 #(32) read_data_mux(
        .sel(RdSel),
        .in0(n_out_mux),
        .in1(go_out_mux),
        .in2(ctrl_out),
        .in3(result),
        .out(RD)
    );

endmodule