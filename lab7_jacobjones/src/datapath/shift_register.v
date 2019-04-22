module shift_register #(parameter WIDTH = 4)(
    input wire CLK, RST, SL, SR, LD, LeftIn, RightIn,
    input wire [WIDTH-1:0] D,
    output reg [WIDTH-1:0] Q
    );
    
    always@(posedge CLK)
        begin
            if(RST)//reset
                Q = 0;
            else if(LD)//load data
                Q = D;
            else if(SL)//shift left
                begin
                    Q[WIDTH-1:1] = Q[WIDTH-2:0];
                    Q[0] = RightIn;
                end
            else if(SR)//shift right
                begin
                    Q[WIDTH-2:0] = Q[WIDTH-1:1];
                    Q[WIDTH-1] = LeftIn;
                end
            else    
                Q[WIDTH-1:0] = Q[WIDTH-1:0]; //hold
        end
    
endmodule