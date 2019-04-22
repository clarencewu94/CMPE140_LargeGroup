module multi_shifter #(parameter DATA_WIDTH = 32, SHIFT_WIDTH = 5)(
    input wire SLL, SLR;
    input wire [DATA_WIDTH-1:0] data;
    input wire [SHIFT_WIDTH-1:0] shamt;
    output wire [DATA_WIDTH-1:0] result;
);

    always @ (shamt, data) begin
        if(SLL) result = data << shamt;
        else if (SLR) result = data >> shamt;
    end

endmodule