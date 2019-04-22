module gpio_reg #(parameter DATA_WIDTH = 32)(
    input [DATA_WIDTH-1:0] D,
    input EN, clk, rst,
    output [DATA_WIDTH-1:0] Q
    );
    
    reg [DATA_WIDTH-1:0] data;
    
    always @ (posedge clk) begin
        if(rst) data <= 0;
        else if(EN) data <= D;
        else data = data;
    end
    
    assign Q = data;
endmodule