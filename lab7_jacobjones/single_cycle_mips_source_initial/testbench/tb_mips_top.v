module tb_mips_top;

    reg         clk;
    reg         rst;
    wire        we_dm;
    wire [31:0] pc_current;
    wire [31:0] instr;
    wire [31:0] alu_mux_out;
    wire [31:0] wd_dm;
    wire [31:0] rd_dm;
    wire [31:0] DONT_USE;
    wire [31:0] wd_rf;
    wire [4:0]  rf_wa;
    
    // Debug
    wire shift_mux_sel = DUT.mips.shift_mux_sel;
    wire alu_out_sel = DUT.mips.alu_out_sel;
    wire hilo_sel = DUT.mips.hilo_sel;
    wire dm2reg = DUT.mips.dm2reg;
    wire we_hilo = DUT.mips.we_hilo;
    wire jal = DUT.mips.jal;
    wire we_reg = DUT.mips.we_reg;
    wire reg_jump = DUT.mips.reg_jump;
    wire reg_dst = DUT.mips.reg_dst;
    wire alu_src = DUT.mips.alu_src;
    wire jump = DUT.mips.jump;
    wire branch = DUT.mips.branch;
    wire [63:0] hilo_d = DUT.mips.dp.hilo_d;
    wire [63:0] hilo_q = DUT.mips.dp.hilo_q;
    wire [31:0] alu_pa = DUT.mips.dp.alu_pa;
    wire [31:0] alu_out = DUT.mips.dp.alu_out;
    wire [31:0] pc_plus4 = DUT.mips.dp.pc_plus4;
    wire [31:0] rd1_out = DUT.mips.dp.rd1_out;
    wire [2:0] alu_ctrl = DUT.mips.dp.alu_ctrl;
    wire [4:0] ra1 = instr[25:21];
    // wire [31:0] instr = DUT.mips.dp.instr;
    // wire [4:0] shift_rd1_out = DUT.mips.dp.shift_rd1_out;
    // wire [31:0] shift_rd1_mux_a = DUT.mips.dp.shift_rd1_mux.a;
    // wire [31:0] shift_rd1_mux_b = DUT.mips.dp.shift_rd1_mux.b;
    // wire [31:0] shift_rd1_mux_y = DUT.mips.dp.shift_rd1_mux.y;
    // wire pc_next = DUT.mips.pc_next;
    wire [31:0] pc_next = DUT.mips.dp.pc_next;
    wire [31:0] alu_out_hi = DUT.mips.dp.alu_out_hi;


    integer error_count = 0;
    integer a, b;
    reg [63:0] expected_product;
    integer expected_jmp_value; // JR and JAL check
    integer reg1_value;

    
    mips_top DUT (
            .clk            (clk),
            .rst            (rst),
            .we_dm          (we_dm),
            .ra3            (5'b00000),
            .pc_current     (pc_current),
            .instr          (instr),
            .alu_out        (alu_mux_out),
            .wd_dm          (wd_dm),
            .rd_dm          (rd_dm),
            .rd3            (DONT_USE),
            .wd_rf          (wd_rf),
            .rf_wa          (rf_wa)
        );
    
    task tick; 
    begin 
        clk = 1'b0; #5;
        clk = 1'b1; #5;
    end
    endtask

    task reset;
    begin 
        rst = 1'b0; #5;
        rst = 1'b1; #5;
        rst = 1'b0;
    end
    endtask

    task CHECK_MULTU;
    begin
        a = 2;
        b = 4;
        expected_product = a*b;
        if({alu_out_hi, alu_mux_out} != expected_product) begin
            error_count = error_count + 1;
            $display("Error: MULTU - Product");
        end 
    end
    endtask

    task CHECK_MFHI;
    begin
        if(wd_rf[31:0] != expected_product[63:32]) begin
            error_count = error_count + 1;
            $display("Error: MFHI - Value");
        end 
    end
    endtask

    task CHECK_MFLO;
    begin
        if(wd_rf[31:0] != expected_product[31:0]) begin
            error_count = error_count + 1;
            $display("Error: MFLO - Value");
        end 
    end
    endtask

    task CHECK_JR;
    begin
        expected_jmp_value = 'h1c;
        if(pc_next != expected_jmp_value) begin
            error_count = error_count + 1;
            $display("Error: CHECK_JR - Value");
        end 
    end
    endtask

    task CHECK_JAL;
    begin
        if(pc_next[27:2] != instr[25:0]) begin
            error_count = error_count + 1;
            $display("Error: CHECK_JAL - Value");
        end 
    end
    endtask

    task CHECK_SLL;
    begin
        reg1_value = 1;
        if(alu_mux_out != (reg1_value << instr[10:6])) begin
            error_count = error_count + 1;
            $display("Error: CHECK_SLL - Value");
        end 
    end
    endtask

    task CHECK_SRL;
    begin
        reg1_value = 8;
        if(alu_mux_out != (reg1_value >> instr[10:6])) begin
            error_count = error_count + 1;
            $display("Error: CHECK_SRL - Value");
        end 
    end
    endtask

    task run_test;
    begin
        tick;
        tick;
        tick;
        CHECK_MULTU;
        tick; 
        CHECK_MFLO;
        tick;
        CHECK_JR;
        tick;
        CHECK_JAL;
        tick; // addi
        tick;
        CHECK_SLL;
        tick;
        CHECK_SRL;
        tick;
        
    end
    endtask

    
    initial begin
        reset;
        // run_test;
        while(pc_current != 32'h58) 
        begin
            tick;
        end
        $display("Error Count: ", error_count);
        $finish;
    end


endmodule