module factorial_err_reg(
    input wire rst,
    input wire clk,
    input wire Err,
    input wire GoPulse,
    output reg ResErr
); 

    always @ (posedge clk, posedge rst) begin
        if(rst) ResErr <= 1'b0;
        else ResErr <= (~GoPulse) & (Err | ResErr);
    end
endmodule