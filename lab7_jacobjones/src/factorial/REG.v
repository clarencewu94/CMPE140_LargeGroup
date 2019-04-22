`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/06/2019 05:25:49 PM
// Design Name: 
// Module Name: REG
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


module REG(
    input [31:0] D,
    input LD, clk,
    output [31:0] Q
    );
    
    reg [31:0] data;
    
    always @ (posedge clk) begin
        if(LD) data <= D;
        else data = data;
    end
    
    assign Q = data;
    
    
endmodule
