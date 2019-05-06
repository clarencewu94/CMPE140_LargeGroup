module decode2execute(
	input wire clk,
	input wire rst,
	input wire [31:0] rd1out_D,
	input wire [31:0] wd_dm_D,
	input wire [31:0] sext_imm_D, 
	input wire [31:0] pc_plus4_D,
//	input wire  alu_out_sel_D,
//	input wire	shift_mux_sel_D,
//    input wire  jal_D,
//    input wire  hilo_sel_D,
//    input wire  reg_jump_D,
//    input wire  jump_D,
//    input wire  dm2reg_D,
//    input wire  we_dm_D,
//    input wire  branch_D,
//    input wire  alu_src_D,
//    input wire  reg_dst_D,
//    input wire  we_reg_D,
//    input wire  alu_ctrl_D,
	

	output reg [31:0] rd1out_E, 
	output reg [31:0] wd_dm_E,
	output reg [31:0] sext_imm_E,
	output reg [31:0] pc_plus4_E,
	
	
	//control unit signals
	input wire we_hilo, alu_out_sel, shift_mux_sel, jal, hilo_sel, reg_jump, jump, we_dm, branch, alu_src,
	input wire [1:0] dm2reg,
	input wire [2:0] alu_ctrl,
	
	output reg we_hilo_E, alu_out_sel_E, shift_mux_sel_E, jal_E, hilo_sel_E, reg_jump_E, jump_E, we_dm_E, branch_E, alu_src_E,
	output reg [1:0] dm2reg_E,
	output reg [2:0] alu_ctrl_E
);

always @ (posedge clk, posedge rst) begin
if (rst)
begin
	rd1out_E 	<= 0;
	wd_dm_E 	<= 0;
	sext_imm_E 	<= 0;
	pc_plus4_E  <= 0;
	
	//CONTROL UNIT
	we_hilo_E 		<= 0;
	alu_out_sel_E 	<= 0;
	shift_mux_sel_E <= 0;
	jal_E 			<= 0;
	hilo_sel_E 		<= 0;
	reg_jump_E 		<= 0;
	jump_E 			<= 0;
	dm2reg_E 		<= 0;
	we_dm_E 		<= 0;
	branch_E 		<= 0;
	alu_src_E 		<= 0;
	alu_ctrl_E 		<= 0;
end
else
begin
	rd1out_E 	<= rd1out_D;
	wd_dm_E 	<= wd_dm_D;
	sext_imm_E 	<= sext_imm_D;
	pc_plus4_E  <= pc_plus4_D;
	
	//CONTROL UNIT
	we_hilo_E 		<= we_hilo;
	alu_out_sel_E 	<= alu_out_sel;
	shift_mux_sel_E <= shift_mux_sel;
	jal_E 			<= jal;
	hilo_sel_E 		<= hilo_sel;
	reg_jump_E 		<= reg_jump;
	jump_E 			<= jump;
	dm2reg_E 		<= dm2reg;
	we_dm_E 		<= we_dm;
	branch_E 		<= branch;
	alu_src_E 		<= alu_src;
	alu_ctrl_E 		<= alu_ctrl;
	
	
	
//		we_hilo_E 		<= we_hilo_D;
//    alu_out_sel_E     <= alu_out_sel_D;
//    shift_mux_sel_E <= shift_mux_sel_D;
//    jal_E             <= jal_D;
//    hilo_sel_E         <= hilo_sel_D;
//    reg_jump_E         <= reg_jump_D;
//    jump_E             <= jump_D;
//    dm2reg_E         <= dm2reg_D;
//    we_dm_E         <= we_dm_D;
//    branch_E         <= branch_D;
//    alu_src_E         <= alu_src_D;
//    alu_ctrl_E         <= alu_ctrl_D;
end
end
endmodule