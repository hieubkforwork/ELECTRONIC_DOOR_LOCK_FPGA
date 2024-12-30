`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2024 09:10:29 PM
// Design Name: 
// Module Name: h_gandata
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


module h_gandata(
input [2:0] state,
input eval,
input success,
output reg [127:0] lcd_h0,
output reg [127:0] lcd_h1
    );
    
localparam IDLE = 3'b000;
localparam WAIT = 3'b001;
localparam OPEN = 3'b010;
localparam CLOSE = 3'b011;
localparam NEW = 3'b100;
localparam EXIT = 3'b101;
localparam WRONG = 3'b110;
localparam WARNING = 3'b111;
always @(state) begin
    if (state == IDLE) begin
        lcd_h0="Enter password  ";
        lcd_h1="    to open     ";
    end
    else if (state == WAIT) begin
        lcd_h0="Correct, press #";
        lcd_h1="open or 3* new  ";
    end
    else if (state == NEW) begin
        lcd_h0="Enter new pass  ";
        lcd_h1="Save press # 3s ";
    end
    else if (state == EXIT && success == 1) begin
        lcd_h0="Successfully sav";
        lcd_h1="e new pass, EXIT";
    end
    else if (state == EXIT && success == 0) begin
        lcd_h0="Fail to save new";
        lcd_h1="pass, EXIT      ";
    end
    else if (state == OPEN && eval == 0) begin
        lcd_h0="Door opening    ";
        lcd_h1="To close press #";
    end
    else if (state == OPEN && eval == 1) begin
        lcd_h0="Open over 30s   ";
        lcd_h1="Please press #,*";
    end
    else if (state == CLOSE) begin
        lcd_h0="Door close in 10";
        lcd_h1="To open press # ";
    end
    else if (state == WARNING) begin
        lcd_h0="Wrong pass!     ";
        lcd_h1="Try again       ";
    end
    else if (state == WRONG) begin
        lcd_h0="Wrong pass!     ";
        lcd_h1="Wait after:     ";
    end
    else begin
        lcd_h0="                ";
        lcd_h1="      ^.^       ";
    end
end
endmodule
