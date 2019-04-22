module mips_top (
        input  wire        clk,
        input  wire        rst,
        input  wire [4:0]  ra3,
        output wire        we_dm,
        output wire [31:0] pc_current,
        output wire [31:0] instr,
        output wire [31:0] alu_out,
        output wire [31:0] wd_dm,
        output wire [31:0] rd_dm,
        output wire [31:0] rd3,
        output wire [31:0] wd_rf,
        output wire [4:0] rf_wa
    );

    wire [31:0] DONT_USE;
    wire WE1;
    wire WE2;
    wire WEM;
    wire [1:0] RdSel;
    wire [31:0] RdDM; 
    wire [31:0] RdFA; 
    wire [31:0] RdGPIO; 

    mips mips (
            .clk            (clk),
            .rst            (rst),
            .ra3            (ra3),
            .instr          (instr),
            .rd_dm          (rd_dm),
            .we_dm          (we_dm),
            .pc_current     (pc_current),
            .alu_out        (alu_out),
            .wd_dm          (wd_dm),
            .rd3            (rd3),
            .wd_rf          (wd_rf),
            .rf_wa          (rf_wa)
        );

    imem imem (
            .a              (pc_current[7:2]),
            .y              (instr)
        );

    dmem dmem (
            .clk            (clk),
            .we             (WEM),
            .a              (alu_out[7:2]),
            .d              (wd_dm),
            .q              (RdDM)
        );

    gpio gpio (
        .clk(clk),
        .reset(rst),
        .A(alu_out[3:2]),
        .WE2(WE2),
        .WD(wd_dm),
        .RD(RdGPIO)
    );

    factorial_accelerator factorial_accelerator (
        .clk(clk),
        .reset(rst),
        .A(alu_out[3:2]),
        .WE1(WE1),
        .WD(wd_dm[3:0]),
        .RD(RdFA)
    );

    soc_addr_dec soc_addr_dec (
        .WE(we_dm),
        .A(alu_out),
        .WE1(WE1),
        .WE2(WE2),
        .WEM(WEM),
        .RdSel(RdSel)
    );

    mux4 #(32) read_data_mux(
        .sel(RdSel),
        .in0(RdDM),
        .in1(RdDM),
        .in2(RdFA),
        .in3(RdGPIO),
        .out(rd_dm)
    );

endmodule