`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2024 03:24:06 PM
// Design Name: 
// Module Name: matkey
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


module matkey(
    input clk,                // Clock t�n hi?u
    input [3:0] row,          // T�n hi?u ??u v�o t? c�c h�ng c?a b�n ph�m
    
    output reg [3:0] col=4'b0001,     // T�n hi?u ??u ra ??n c�c c?t c?a b�n ph�m
    output reg [3:0] value_4bit, // Gi� tr? 4-bit t??ng ?ng v?i ph�m nh?n
    output reg lock= 1'b0
    );
wire clk_1000hz;
reg [15:0] debounce_counter; // B? ??m debounce

//reg [3:0] value_4bit = 4'b0000;
clk_divider #(.DIV(28'd1000)) clk_1ms(clk, 'd0, clk_1000hz);  

always @(posedge clk_1000hz) begin
if (lock == 1'b1) begin
            debounce_counter <= debounce_counter + 1;
            if (debounce_counter >= 16'd700 ) 
            begin
            debounce_counter <= 16'd0;
            lock <= 1'b0; // Khi row ?n ??nh ? 0000 l�u
            end
         
        end
        
else if (lock == 1'b0) begin
    if (col == 4'b0001) begin // Qu�t c?t 1
        if (row[0] == 1) value_4bit <= 4'd1; // Ph�m 1
        else if (row[1] == 1) value_4bit <= 4'd4; // Ph�m 4
        else if (row[2] == 1) value_4bit <= 4'd7; // Ph�m 7
        else if (row[3] == 1) value_4bit <= 4'd13; // Ph�m * -> k hien gi
        if(row != 4'b0000) begin
        lock <= 1'b1;
        end
        col <= 4'b0010;
    end else if (col == 4'b0010) begin // Qu�t c?t 2
        if (row[0] == 1) value_4bit <= 4'd2; // Ph�m 2
        else if (row[1] == 1) value_4bit <= 4'd5; // Ph�m 5
        else if (row[2] == 1) value_4bit <= 4'd8; // Ph�m 8
        else if (row[3] == 1) value_4bit <= 4'd0; // Ph�m 0
        if(row != 4'b0000) begin
        lock <= 1'b1;
        end
        col <= 4'b0100;
    end else if (col == 4'b0100) begin // Qu�t c?t 3
        if (row[0] == 1) value_4bit <= 4'd3; // Ph�m 3
        else if (row[1] == 1) value_4bit <= 4'd6; // Ph�m 6
        else if (row[2] == 1) value_4bit <= 4'd9; // Ph�m 9
        else if (row[3] == 1) value_4bit <= 4'd14; // Ph�m # -> k hien gi
        if(row != 4'b0000) begin
        lock <= 1'b1;
        end
        col <= 4'b1000;
    end else if (col == 4'b1000) begin // Qu�t c?t 4
        if (row[0] == 1) value_4bit <= 4'd15; // Ph�m A
        else if (row[1] == 1) value_4bit <= 4'd15; // Ph�m B
        else if (row[2] == 1) value_4bit <= 4'd15; // Ph�m C
        else if (row[3] == 1) value_4bit <= 4'd15; // Ph�m D
        if(row != 4'b0000) begin
        lock <= 1'b1;
        end
        col <= 4'b0001;
    end
end  
    
    
    
end  
    
endmodule