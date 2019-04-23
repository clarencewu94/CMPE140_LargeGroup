module gpio_addr_dec(
        input wire WE,
        input wire [1:0] A, // Check size
        output wire WE1,
        output wire WE2,
        output wire [1:0] RdSel
    );

    reg [1:0] ctrl;

    assign {WE1, WE2} = ctrl;

    always @ (A, WE) begin
        if(WE) begin
        case (A)
            2'b00: ctrl = 'b0_0;
            2'b01: ctrl = 'b0_0;
            2'b10: ctrl = 'b1_0;
            2'b11: ctrl = 'b0_1;
            default: ctrl = 'bx_x;
        endcase
        end else ctrl = 'b0_0;
    end

    assign RdSel = A;


endmodule