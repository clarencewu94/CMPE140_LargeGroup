module tb_system;

    reg         clk;
    reg         rst;
    reg [31:0]  gpi0;
    reg [31:0]  gpi1;
    wire [31:0] gpo0;
    wire [31:0] gpo1;

    // For Testing
    wire [31:0] pc_current = DUT.pc_current;


    integer error_count = 0;

    system DUT(
        .clk(clk),
        .rst(rst),
        .gpi0(gpi0),
        .gpi1(gpi1),
        .gpo0(gpo0),
        .gpo1(gpo1)
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

    initial begin
        reset;
        gpi0 = 32'b0101;
        gpi1 = 32'b0110;
        // run_test;
        while(pc_current != 32'h58) 
        begin
            tick;
        end
        $display("Error Count: ", error_count);
        $finish;
    end

endmodule
