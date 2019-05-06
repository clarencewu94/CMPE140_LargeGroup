module soc_addr_dec(
        input wire WE,
        input wire [31:0] A, // Check size
        output wire WE1,
        output wire WE2,
        output wire WEM,
        output wire [1:0] RdSel
    );

    reg [4:0] ctrl;

    assign {WE1, WE2, WEM, RdSel} = ctrl;

    always @ (A) begin
        case (A[7:4])
            4'b0000: ctrl = 'b1_0_0_10;
            4'b0001: ctrl = 'b0_1_0_11;
            default: ctrl = 'b0_0_1_00;
        endcase
    end


endmodule