module soc_addr_dec(
        input wire WE,
        input wire [31:0] A, // Check size
        output wire WE1,
        output wire WE2,
        output wire WEM,
        output wire [1:0] RdSel
    );

    reg [2:0] ctrl;
    reg [1:0] RdSel_ctrl;

    assign {WE1, WE2, WEM} = ctrl;
    assign RdSel = RdSel_ctrl;

    always @ (A, WE) begin
        if(WE) begin
        case (A[7:4])
            4'b0000: ctrl = 'b1_0_0;
            4'b0001: ctrl = 'b0_1_0;
            default: ctrl = 'b0_0_1;
        endcase
        end else ctrl = 'b0_0_0;
        case (A[7:4])
            4'b0000: RdSel_ctrl = 'b10;
            4'b0001: RdSel_ctrl = 'b11;
            default: RdSel_ctrl = 'b00;
        endcase
    end


endmodule