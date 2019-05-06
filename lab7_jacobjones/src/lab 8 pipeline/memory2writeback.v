module memory2writeback (
	input wire alu_out_sel_M,
	input wire jal_M,
	input wire reg_jump_M,
	input wire jump_M,
	input wire dm2reg_M,
	input wire pc_src,
	input wire [31:0] rd_dm,
	input wire [31:0] hilo_mux_out,
    input wire [31:0] alu_out_M,
	input wire rst, clk,

	output reg alu_out_sel_WB,
	output reg jal_WB,
	output reg reg_jump_WB,
	output reg jump_WB,
	output reg dm2reg_WB,
	output reg pc_src_WB,
	output reg [31:0] rd_dm_WB,
	output reg [31:0] hilo_mux_out_WB,
    output wire [31:0] alu_out_WB
);

always @(posedge clk, posedge rst) 
    begin
        if(rst)
            begin
                alu_out_sel_WB 	<= 0;
                jal_WB 			<= 0;
                reg_jump_WB 		<= 0;
                jump_WB 			<= 0;
                dm2reg_WB 		<= 0;
                pc_src_WB 			<= 0;
                rd_dm_WB 			<= 0;
                hilo_mux_out_WB       <=0;
            end
        else
            begin
                alu_out_sel_WB  <= 	alu_out_sel_M; 
                jal_WB          <=	jal_M;
                reg_jump_WB	  	<=	reg_jump_M; 
                jump_WB 	  	<=	jump_M;
                dm2reg_WB	  	<=	dm2reg_M;
                pc_src_WB       <=	pc_src;
                rd_dm_WB 		<= 	rd_dm;
                hilo_mux_out_WB  <= hilo_mux_out;
                
            end   
    end
endmodule