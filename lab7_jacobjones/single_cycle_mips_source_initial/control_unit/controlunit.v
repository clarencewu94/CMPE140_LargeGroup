module controlunit (
        input  wire [5:0]  opcode,
        input  wire [5:0]  funct,
        output wire        jal,
        output wire        branch,
        output wire        jump,
        output wire        reg_jump,
        output wire        reg_dst,
        output wire        we_reg,
        output wire        alu_src,
        output wire        we_dm,
        output wire        dm2reg,
        output wire        hilo_sel,
        output wire        alu_out_sel,
        output wire        we_hilo,
        output wire        shift_mux_sel,
        output wire [2:0]  alu_ctrl
    );
    
    wire [1:0] alu_op;
    wire we_reg_main, we_reg_aux;

    mux2 #(1) we_reg_mux (
            .sel            (we_reg_aux),
            .a              (we_reg_main),
            .b              (1'b0),
            .y              (we_reg)
        );
    // wire hilo_sel;
    // wire dm2reg_0;
    // assign dm2reg = {hilo_sel, dm2reg_0};

    maindec md (
        .opcode         (opcode),
        .jal            (jal),
        .branch         (branch),
        .jump           (jump),
        .reg_dst        (reg_dst),
        .we_reg         (we_reg_main),
        .alu_src        (alu_src),
        .we_dm          (we_dm),
        .dm2reg         (dm2reg),
        .alu_op         (alu_op)
    );

    auxdec ad (
        .alu_op         (alu_op),
        .funct          (funct),
        .alu_ctrl       (alu_ctrl),
        .hilo_sel       (hilo_sel),
        .alu_out_sel    (alu_out_sel),
        .we_hilo        (we_hilo),
        .reg_jump       (reg_jump),
        .shift_mux_sel  (shift_mux_sel),
        .we_reg_aux      (we_reg_aux)
    );

endmodule