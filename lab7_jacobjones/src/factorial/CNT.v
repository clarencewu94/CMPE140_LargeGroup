`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/06/2019 05:00:18 PM
// Design Name: 
// Module Name: factorial_dp
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CNT(
    input [31:0] D,
    input clk, en, ld,
    output reg [31:0] Q
    );
    
    always @ (posedge clk) begin
        if(!en) Q <= Q;
        else if (ld) Q <= D;
        else Q <= Q-1;
    end
endmodule