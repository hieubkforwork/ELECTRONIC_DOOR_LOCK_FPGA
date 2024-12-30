`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2024 06:06:48 PM
// Design Name: 
// Module Name: lock
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


module lock(
    input btn0,
    input btn1,
    input [3:0] row,
    output [3:0] col, 
    input clk,
    output rs,e,[7:0] data,
    output [15:0] led7_out,
    output [2:0] rgb,
    output lock_status,
    output eval,
    output lock
    );
    wire [2:0] state;
    mergeALL M0 (
    .btn0(btn0),
    .btn1(btn1),
    .row(row),
    .col(col), 
    .clk(clk),
    .led7_out(led7_out),
    .rgb(rgb),
    .lock_status(lock_status),
    .eval(eval),
    .success(success),
    .lock(lock),
    .state(state)
     );
     
     
    h_lcd (
    .state(state),
    .eval(eval),
    .success(success),
    .clk_in(clk),
    .rs(rs),
    .e(e),
    .data(data));
endmodule

