`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2024 08:51:41 PM
// Design Name: 
// Module Name: h_lcd
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


module h_lcd(
input [2:0] state,
input eval,
input success,
input clk_in,
output rs,e,[7:0] data
    );
wire [127:0] lcd_h0;
wire [127:0] lcd_h1;
//wire clk;
clk_divider #(.DIV(28'd1000)) clk_1ms(clk_in,'d0, clk);        //ng?t 1ms
h_gandata IC1 (
        .state(state),
        .eval(eval),
        .success(success),
        .lcd_h0(lcd_h0),
        .lcd_h1(lcd_h1)
        );
        
h_khoitao_ht IC2(
        .clk(clk),
        .lcd_h0(lcd_h0),
        .lcd_h1(lcd_h1),
        .rs(rs),
        .e(e),
        .data(data)
        );
endmodule
