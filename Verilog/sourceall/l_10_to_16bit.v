`timescale 1ns / 1ps

module l_10_to_16bit(
    input [9:0] led_cnt,  
    output reg [15:0] led_cnt16    
);
    reg [3:0] reg0;
    reg [3:0] reg1;   
    reg [3:0] reg2;   
    reg [3:0] reg3;
    integer temp;  
    always @(*) begin
        // Kh?i t?o giá tr? ban ??u c?a các thanh ghi
        reg0 = 'd0;
        reg1 = 'd0;   
        reg2 = 'd0;   
        reg3 = 'd0;
        temp = led_cnt;             

        if (temp >= 1000) begin
            reg0 = temp / 1000;     
            temp = temp % 1000;     
        end

        if (temp >= 100) begin      
            reg1 = temp / 100;      
            temp = temp % 100;      
        end

        if (temp >= 10) begin       
            reg2 = temp / 10;       
            temp = temp % 10;       
        end

        reg3 = temp;    
        
        led_cnt16 = {reg0, reg1, reg2, reg3};
    end

endmodule
