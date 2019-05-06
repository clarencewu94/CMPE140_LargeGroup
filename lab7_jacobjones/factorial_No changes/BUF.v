`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/06/2019 05:17:08 PM
// Design Name: 
// Module Name: BUF
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


module BUFFER(
    input [31:0] in,
    input wire OE,
    output [31:0] out
    );
    
    assign out = (OE==1'b0) ? 32'bz:in;
endmodule
