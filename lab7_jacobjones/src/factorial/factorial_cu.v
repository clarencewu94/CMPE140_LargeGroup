module factorial_cu #(parameter DATA_WIDTH = 32, CS_WIDTH = 3)(
    input Go,
    input clk, rst,
    input wire x_gt_1, x_gt_12,
    output reg Error,
    output reg Done,
    output reg ld_CNT, en_CNT, ld_REG, sel_MUX, OE_BUF 
);
    parameter   IDLE = 3'b000,
                S1 = 3'b001,
                S2 = 3'b010,
                S3 = 3'b011,
                S4 = 3'b100,
                S5 = 3'b101; 

    reg [CS_WIDTH-1:0] CS, NS = IDLE;


    always @(posedge clk, posedge rst) 
    begin
        if(rst) CS <= IDLE;
        else CS <= NS;
    end         

    always @(CS, Go, x_gt_1, x_gt_12)
    begin
        case(CS)
            IDLE: begin
                if(Go) NS <= S1;
                else NS <= IDLE;
            end
            S1: begin
                NS <= S2;
            end
            S2: begin
                if(x_gt_12) NS <= S3;
                else begin
                    if(x_gt_1) NS <= S4;
                    else NS <= S5;
                end
            end
            S3: begin
                NS <= IDLE;
            end
            S4: begin
                if(x_gt_1) NS <= S4;
                else NS <= S5;
            end
            S5: begin
                NS <= IDLE;
            end
            default: NS <= IDLE;
        endcase
    end

    // TODO: Write Output Signals to Datapath
    always @(CS)
    begin
        case(CS)
            IDLE: begin
                Done = 0;
                Error = 0;
                OE_BUF = 0;
                sel_MUX = 0;
                en_CNT = 0;
                ld_REG = 0;
                ld_CNT = 0;
            end
            S1: begin
                ld_CNT = 1;
                ld_REG = 1;
                en_CNT = 1;
                sel_MUX = 0;
            end
            S2: begin
                ld_CNT = 0;
                ld_REG = 0;
                en_CNT = 0;
                Done = 0;
            end
            S3: begin
                Error = 1;
            end
            S4: begin
                sel_MUX = 1;
                en_CNT = 1;
                ld_REG = 1;
            end
            S5: begin
                Done = 1;
                OE_BUF = 1;
            end
            default: Error = 1;
        endcase
    end



endmodule