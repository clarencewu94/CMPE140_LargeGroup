module datapath (
        input  wire        clk,
        input  wire        rst,
        input  wire        jal,
        input  wire        branch,
        input  wire        jump,
        input  wire        reg_jump,
        input  wire        reg_dst,
        input  wire        we_reg,
        input  wire        alu_src,
        input  wire [1:0]  dm2reg,
        input  wire        we_hilo,
        input  wire        alu_out_sel,
        input  wire        hilo_sel,
        input  wire        shift_mux_sel,
        input  wire [2:0]  alu_ctrl,
        input  wire [4:0]  ra3,
        input  wire [31:0] instr,
        input  wire [31:0] rd_dm,
        output wire [31:0] pc_current,
        output wire [31:0] alu_mux_out,
        output wire [31:0] wd_dm,
        output wire [31:0] rd3,
        output wire [31:0] wd_rf,
        output wire [4:0] rf_wa,
        
        
        output wire we_hilo_E,
        output wire alu_out_E,
        output wire shift_mux_sel_E,
        output wire jal_E,
        output wire hilo_sel_E,
        output wire reg_jump_E,
        output wire jump_E,
        output wire dm2reg_E,
        output wire we_dm_E,
        output wire branch_E,
        output wire alu_ctrl_E,
        output wire alu_src_E,

        output wire we_hilo_M,
        output wire alu_out_sel_M,
        output wire jal_M,
        output wire hilo_sel_M,
        output wire reg_jump_M,
        output wire jump_M,
        output wire dm2reg_M,
        output wire we_dm_M,
        output wire branch_M,

        output wire alu_out_sel_WB,
        output wire jal_WB,
        output wire reg_jump_WB,
        output wire jump_WB,
        output wire dm2reg_WB,
        output wire pc_src_WB
    );

    wire [4:0]  reg_addr;
    // wire [4:0]  rf_wa;
    wire        pc_src;
    wire [31:0] pc_plus4;
    wire [31:0] pc_pre;
    wire [31:0] pc_next;
    wire [31:0] pc_rj_plus4;
    wire [31:0] sext_imm;
    wire [31:0] ba;
    wire [31:0] bta;
    wire [31:0] jta;
    wire [31:0] rd1_out;
    wire [31:0] alu_pa;
    wire [31:0] alu_pb;
    wire [31:0] alu_mem_out;
    // wire [31:0] wd_rf;
    wire        zero;
    wire [64-1:0] hilo_d, hilo_q;
    wire [32-1:0] hi_q, lo_q;
    wire [32-1:0] alu_out_hi;
    wire [32-1:0] hilo_mux_out;
    wire [32-1:0] alu_out;
    // wire [31:0] shift_mul_mux_out;
    wire [4:0] shift_rd1_out;
    
    assign pc_src = branch & zero;
    assign ba = {sext_imm[29:0], 2'b00};
    assign jta = {pc_plus4[31:28], instr[25:0], 2'b00};
    
    // --- PC Logic --- //
    dreg pc_reg (
            .clk            (clk),
            .rst            (rst),
            .d              (pc_next),
            .q              (pc_current)
        );

    adder pc_plus_4 (
            .a              (pc_current),
            .b              (32'd4),
            .y              (pc_plus4)
        );

    adder pc_plus_br (
            .a              (pc_plus4),
            .b              (ba),
            .y              (bta)
        );

    mux2 #(32) pc_reg_jmp_mux (
            .sel            (reg_jump_WB), //change to reg_jump_WB
            .a              (pc_plus4),
            .b              (rd1_out),
            .y              (pc_rj_plus4)
        );

    mux2 #(32) pc_src_mux (
            .sel            (pc_src_WB),
            .a              (pc_rj_plus4), // pc_pre
            .b              (bta), //
            .y              (pc_pre)
        );

    mux2 #(32) pc_jmp_mux (
            .sel            (jump_WB),
            .a              (pc_pre),
            .b              (jta),
            .y              (pc_next)//pc jump + 4 on diagram
        );

    // --- RF Logic --- //
    mux2 #(5) rf_wa_mux (
            .sel            (reg_dst),
            .a              (instr[20:16]),
            .b              (instr[15:11]),
            .y              (reg_addr)
        );

    mux2 #(5) reg_addr_mux (
            .sel            (reg_jump_E),
            .a              (reg_addr),
            .b              (5'h1F),
            .y              (rf_wa)
        );

    regfile rf (
            .clk            (clk),
            .we             (we_reg),
            .ra1            (instr[25:21]),
            .ra2            (instr[20:16]),
            .ra3            (ra3),
            .wa             (rf_wa),
            .wd             (wd_rf),
            .rd1            (rd1_out),
            .rd2            (wd_dm),
            .rd3            (rd3)
        );

    signext se (
            .a              (instr[15:0]),
            .y              (sext_imm)
        );

    // --- ALU Logic --- //
    mux2 #(32) alu_pb_mux (
            .sel            (alu_src_E),
            .a              (wd_dm),
            .b              (sext_imm),
            .y              (alu_pb)
        );
    
    assign alu_pa = {rd1_out[31:5], shift_rd1_out};
    // assign alu_pa = {rd1_out[31:5], rd1_out[4:0]};
    // assign alu_pa = (shift_mux_sel) ? instr : rd1_out;
    
    mux2 #(5) shift_rd1_mux (
        .sel    (shift_mux_sel_E),
        .a      (rd1_out[4:0]),
        .b      (instr[10:6]),
        .y      (shift_rd1_out)
    );

    // mux2 #(32) shift_rd1_mux (
    //         .sel            (shift_mux_sel),
    //         .a              (rd1_out),
    //         .b              (instr),
    //         .y              (alu_pa)
    // );

    alu alu (
            .op             (alu_ctrl_E),
            .a              (alu_pa),
            .b              (alu_pb),
            .zero           (zero),
            .y              (alu_out),
            .y_hi           (alu_out_hi)
        );

    // --- MEM Logic --- //
    mux2 #(32) alu_mem_mux (
            .sel            (dm2reg_WB),
            .a              (alu_mux_out),
            .b              (rd_dm),
            .y              (alu_mem_out)
        );

    mux2 #(32) rf_wd_mux (
            .sel            (jal_WB),
            .a              (alu_mem_out),
            .b              (pc_plus4),
            .y              (wd_rf)
        );

    // HiLo Register & logic
    assign {hi_q, lo_q} = hilo_q;
    assign hilo_d = {alu_out_hi, alu_out};
    flopenr #(64) hilo_reg (
        .clk    (clk),
        .reset  (rst),
        .en     (we_hilo_M),
        .d      (hilo_d),
        .q      (hilo_q)
    );

    mux2 #(32) hilo_out_mux (
        .sel    (hilo_sel_M),
        .a      (lo_q),
        .b      (hi_q),
        .y    (hilo_mux_out)
    );

    mux2 #(32) alu_out_mux (
        .sel    (alu_out_sel_WB),
        .a      (alu_out),
        .b      (hilo_mux_out),
        .y    (alu_mux_out)
    );

    // Shifter Logic (MOVED TO ALU)
    // multi_shifter #(32, 5) shifter (
    //     .SLL     (SLL),
    //     .SLR     (SLR),
    //     .data   (rd2),
    //     .shamt  (instr[10:6]),
    //     .result (shift_result)
    // );
    Dreg fetch_to_decoder(

    ); 

endmodule
