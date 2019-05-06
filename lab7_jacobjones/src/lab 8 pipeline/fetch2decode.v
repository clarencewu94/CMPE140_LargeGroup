`timescale 1ns / 1ps

module fetch2decode(
    input wire clk,
	input wire rst,
	input wire imem,
	input wire  pc_plus4,

    output reg imem_D,
    output reg  pc_plus4_D
);
always @ (posedge clk, posedge rst) begin
if (rst)
begin
    imem_D 	<= 0;
	pc_plus4_D 	<= 0;
end
else
begin
	imem_D 	<= imem;
	pc_plus4_D 	<= pc_plus4;
end
end
endmodule