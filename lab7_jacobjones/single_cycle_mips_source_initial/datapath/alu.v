module alu (
        input  wire [2:0]  op,
        input  wire [31:0] a,
        input  wire [31:0] b,
        output wire        zero,
        output wire  [31:0] y,
        output wire  [31:0] y_hi
    );

    reg [63:0] y_total;
    
    assign {y_hi, y} = y_total;
    assign zero = (y == 0);

    always @ (op, a, b) begin
        case (op)
            3'b000: y_total = a & b;
            3'b001: y_total = a | b;
            3'b010: y_total = a + b;
            3'b011: y_total = a * b; // TODO: Change to pipelined
            3'b100: y_total = b << a[4:0]; // TODO: Change to pipelined
            3'b101: y_total = b >> a[4:0]; // TODO: Change to pipelined
            3'b110: y_total = a - b;
            3'b111: y_total = (a < b) ? 1 : 0;
        endcase
    end

endmodule