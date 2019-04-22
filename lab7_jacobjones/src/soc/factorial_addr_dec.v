module factorial_addr_dec(
        input wire WE,
        input wire [1:0] A, // Check size
        output wire WE1,
        output wire WE2,
        output wire [1:0] RdSel
    );

    reg [3:0] ctrl;

    assign {WE1, WE2, RdSel} = ctrl;

    always @ (A) begin
        case (A)
            2'b00: ctrl = 'b1_0_00;
            2'b01: ctrl = 'b0_1_01;
            2'b10: ctrl = 'b0_0_10;
            2'b11: ctrl = 'b0_0_11;
            default: ctrl = 'bx_x_xx;
        endcase
    end


endmodule