`timescale 1ns / 1ps

module d_module_led_rgb(
    input rgb_toggle,
    input [2:0] led_rgb,
    input clk_in,
    input idle,
    output reg [2:0] rgb_out = 3'b0
    );
        //LED RGB:
    localparam OFF = 3'b000;
    localparam RED = 3'b001;
    localparam GREEN = 3'b010;
    localparam YELLOW = 3'b011;
    localparam WHITE = 3'b111;
    localparam BLUE = 3'b100;
    
    clk_divider #(.DIV(28'd4)) clock_1HZ (clk_in, idle, clk_1hz);
    always @(posedge clk_1hz) begin 
        if (rgb_toggle == 1'b1) begin 
            if (rgb_out == OFF) begin
                rgb_out <= led_rgb;
            end
            else begin
                rgb_out <= OFF;
            end
        end
        else begin
            rgb_out <= led_rgb;
        end
    end
endmodule
