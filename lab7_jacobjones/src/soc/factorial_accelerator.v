module factorial_accelerator(
        input wire clk,
        input wire reset,
        input wire [1:0] A,
        input wire WE1,
        input wire [3:0] WD,
        output wire RD
    );

    factorial #(4) factorial (
        .rst(reset),
        .clk(clk),
        .Go(),
        .n(),
        .Done(),
        .Error(),
        .product()
    );


endmodule