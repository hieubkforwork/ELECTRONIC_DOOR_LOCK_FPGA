module clk_divider(
    input clk_ht, 
    input reset,
    output reg clk_di);
    reg [27:0] counter = 28'd0;
    localparam CLK = 28'd125000000; //1250000000
    parameter DIV = 28'd1;
    
    always @(posedge clk_ht)
    begin
        if (reset == 1'b0) begin
            counter <= counter + 28'd1;
            if(counter >= CLK/DIV - 1) 
            begin
                counter <= 28'd0;
            end
            clk_di <= (counter<CLK/(2*DIV))?1'b1:1'b0; 
        end
        else if (reset == 1'b1) begin
            clk_di <= 1'b0;
            counter <= 28'd0;
        end
    end
    
    
    
endmodule