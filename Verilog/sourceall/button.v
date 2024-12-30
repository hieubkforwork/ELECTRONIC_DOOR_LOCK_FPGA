`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2024 10:10:43 AM
// Design Name: 
// Module Name: button
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module button_push(
    input clk_in, button_in,
    output reg button_out = 'd0
);

reg [27:0] counter = 28'd0;
wire clk_1000hz;
clk_divider #(.DIV(28'd1000)) clk_1ms(clk_in, 'd0, clk_12500hz);        

always @(posedge clk_12500hz) begin
    if (button_in) begin
        counter <= counter + 28'd1;
        if (counter >= 28'd50) begin // counter dem 250 = 20ms
            button_out <= 1'd1;
        end
        if (counter >= 28'd1000) begin // do dai tin hieu = 20ms
            button_out <= 1'd0;
        end
    end
    else begin
        counter <=28'd0;
        button_out <= 1'd0;
    end
end

endmodule

module button_push_v1(
    input clk_in, button_in,
    output reg button_out = 'd0
);

reg [27:0] counter = 28'd0;
reg tog = 'd0;

wire clk_1000hz;
clk_divider #(.DIV(28'd1000)) clk_1ms(clk_in, 'd0, clk_12500hz);        //ng?t 1ms
always @(posedge clk_12500hz) begin
    if (!button_in && !tog) begin
        button_out <= 1'b1;
    end
    else if (!button_in && tog) begin
        counter <= counter + 1'b1;
        if (counter >= 'd0 && counter <= 'd20) begin
            button_out <= 1'b0;
        end
        else if (counter > 'd20) begin
            tog <= 'b0;
            counter <= 'd0;
        end
    end
    else begin
        tog <= 1'b1;
    end
end

endmodule


module button_press(
    input clk_in, button_in,
    output reg button_out = 'd0
);

reg [27:0] counter = 28'd0;
wire clk_1000hz;
clk_divider #(.DIV(28'd1000)) clk_1ms(clk_in, 'd0, clk_12500hz);        //ng?t 1ms
always @(posedge clk_12500hz) begin
    if (button_in) begin
        counter <= counter + 28'd1;
        if (counter >= 28'd3000) begin // counter dem 250 = 20ms
            button_out <= 1'd1;
            if (counter > 28'd3020) begin // do dai tin hieu = 20ms
                button_out <= 1'd0;
            end
        end 
    end
    else begin
        counter <=28'd0;
        button_out <= 1'd0;
    end
end

endmodule

