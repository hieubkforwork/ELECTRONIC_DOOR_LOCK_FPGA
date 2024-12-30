`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2024 09:16:43 PM
// Design Name: 
// Module Name: h_khoitao_ht
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


module h_khoitao_ht(
input clk,
      [127:0] lcd_h0,
      [127:0] lcd_h1,
output rs,e,[7:0] data
    );
     parameter [3:0] 
        LCD_INIT = 4'b0000,
        LCD_ADDR_L0 = 4'b0001,
        LCD_DATA_L0 = 4'b0010,
        LCD_ADDR_L1 = 4'b0011,
        LCD_DATA_L1 = 4'b0100,
        LCD_IDLE = 4'b1001,
        LCD_PRE = 4'b1010;
        
     wire[7:0] lcd_h0b[0:15];
     wire[7:0] lcd_h1b[0:15];
     
     reg [3:0] state= LCD_INIT;
     reg [15:0] slx=15'd0;
     reg [3:0] ptr=4'd0;
     
     reg rsr;
     reg er;
     reg [7:0] datar;
     
     wire [7:0] cmd [0:6];
     
     assign e = er;
     assign rs = rsr;
     assign data= datar;
       
     assign cmd[0]=8'h30; //initialize
     assign cmd[1]=8'h38; //function set
     assign cmd[2]=8'h0C; //display off
     assign cmd[3]=8'h01; //display clear
     assign cmd[4]=8'h06; //entry mode set
     assign cmd[5]=8'h0F; //cursor blink
     
     generate
     genvar i;
     for(i=1;i<17;i=i+1)
     begin:for_name
        assign lcd_h0b[16-i] = lcd_h0[i*8-1: i*8-8];
        assign lcd_h1b[16-i] = lcd_h1[i*8-1: i*8-8];
    end
    endgenerate
    
    always@(negedge clk) begin
    case(state)
      LCD_PRE:
      begin  
        slx <= slx + 15'd1;
        if(slx == 15'd2000) begin
        slx <= 15'd0;
        state <= LCD_INIT;
        end
      end
      LCD_INIT:
        begin  
        slx <= slx + 15'd1;
        case (slx)
        15'd16: begin
            rsr <= 1'b0; // Command mode
            datar <= cmd[0]; // Initialize
        end
        15'd20: er <= 1'b1; // Enable pulse start
        15'd40: er <= 1'b0; // Enable pulse end

        15'd46: begin
            rsr <= 1'b0;
            datar <= cmd[0]; // Reinitialize
        end
        15'd50: er <= 1'b1; // Enable pulse start
        15'd70: er <= 1'b0; // Enable pulse end

        15'd96: begin
            rsr <= 1'b0;
            datar <= cmd[1]; // Function set
        end
        15'd100: er <= 1'b1;
        15'd120: er <= 1'b0;

        15'd140: begin
            rsr <= 1'b0;
            datar <= cmd[2]; // Display OFF
        end
        15'd145: er <= 1'b1;
        15'd165: er <= 1'b0;

        15'd185: begin
            rsr <= 1'b0;
            datar <= cmd[3]; // Display Clear
        end
        15'd190: er <= 1'b1;
        15'd195: er <= 1'b0;

        15'd510: begin
            rsr <= 1'b0;
            datar <= cmd[4]; // Entry Mode Set
        end
        15'd515: er <= 1'b1;
        15'd535: er <= 1'b0;

//        15'd550: begin
//            rsr <= 1'b0;
//            datar <= cmd[5]; // Cursor Blink
//        end
//        15'd555: er <= 1'b1;
//        15'd575: er <= 1'b0;
      
      
        15'd600: begin
            slx <= 15'd0;
            state <= LCD_ADDR_L0; // Transition to idle or next state
          end
          endcase
          end
        LCD_ADDR_L0:
        begin
            slx <= slx+15'd1;
            datar <= 8'h80; //Row 0, Col 0
            rsr <= 1'b0;
            if(slx==15'd10) er <= 1'b1; //e = 1
            else if(slx==15'd11) er <= 1'b0; //e = 0
            else if(slx==15'd12) begin
                slx <= 15'd0;
                ptr <= 4'd0;
                state <= LCD_DATA_L0;
            end
        end
        LCD_DATA_L0:
        begin
            slx <= slx+15'd1;
            datar <= lcd_h0b[ptr];
            rsr <= 1'b1;
            if(slx==15'd10) er <= 1'b1; //e = 1
            else if(slx==15'd11) er <= 1'b0; //e = 0
            else if(slx==15'd12) begin
                slx <= 15'd0;
                if(ptr==4'd15) state <= LCD_ADDR_L1;
                else ptr <= ptr+4'd1;
                end
        end
        LCD_ADDR_L1:
        begin
            slx <= slx+15'd1;
            datar <= 8'hc0; //Row 0, Col 0
            rsr <= 1'b0;
            if(slx==15'd10) er <= 1'b1; //e = 1
            else if(slx==15'd11) er <= 1'b0; //e = 0
            else if(slx==15'd12) begin
                slx <= 15'd0;
                ptr <= 4'd0;
                state <= LCD_DATA_L1;
            end
        end
        LCD_DATA_L1:
        begin
            slx <= slx+15'd1;
            datar <= lcd_h1b[ptr];
            rsr <= 1'b1;
            if(slx==15'd10) er <= 1'b1; //e = 1
            else if(slx==15'd11) er <= 1'b0; //e = 0
            else if(slx==15'd12) begin
                slx <= 15'd0;
                if(ptr==4'd15) state <= LCD_IDLE;
                else ptr <= ptr+4'd1;
                end
        end
        LCD_IDLE:
        begin
        slx <= slx+15'd1;
        if(slx == 15'd5) begin
            slx <= 15'd0;
            state <= LCD_ADDR_L0;
            end
        end  
        
        endcase
    end
     
       
endmodule
