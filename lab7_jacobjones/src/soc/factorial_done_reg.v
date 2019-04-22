module factorial_done_reg(
    input wire rst,
    input wire clk,
    input wire Done,
    input wire GoPulse,
    output reg ResDone
); 

    always @ (posedge clk, posedge rst) begin
        if(rst) ResDone <= 1'b0;
        else ResDone <= (~GoPulse) & (Done | ResDone);
    end
endmodule