`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2024 10:24:02 AM
// Design Name: 
// Module Name: h_newlock_v2
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


module h_newlock_v2(
        input 	enb_inp,
                enb_set,
          		exit_button,
          		enough,
          		[15:0] value_16bit,
          		confirm_button,
         		clk_in,
        output 	reg disable_cnt = 'd0,
                reg [15:0] password = 16'd0,
                reg success = 1'b0
    );

           reg[3:0] three_time_counter=4'd0;
           wire button_push_confirm, button_push_exit, button_push_3s_exit;
           button_push B0(clk_in, confirm_button, button_push_confirm);
           button_push_v1 B1(clk_in, exit_button,button_push_exit);
           button_press B2(clk_in, exit_button,button_push_3s_exit);
//    clk_divider #(.DIV(28'd1000)) clock_1hz (clk_in, pulse_count, count);
    reg [30:0] counter = 0;
    reg dis_1 =1'd0;
    reg dis_2 =1'd0;
    reg dis_3 =1'd0;
    always @(posedge clk_in) begin 
        if (disable_cnt == 1 && enough == 1 && button_push_3s_exit && success == 0) begin
            success <= 1'b1;
            counter <= 'd0;
        end
        else if (success == 1) begin 
            counter <= counter + 1'b1;
            if (counter >= 'd250000000) begin
                success <= 0;
                counter <= 0;
            end
        end
        
    end
         
    always@(posedge button_push_confirm)
    begin
        if (enb_set == 1'd1 && enb_inp == 1'd1) begin
            if(button_push_confirm) begin
                three_time_counter <= three_time_counter + 4'd1;
            if(three_time_counter >= 4'd2) begin
                dis_1 <= ~dis_1;
                
                three_time_counter <= 4'd0;
                end   
            end
       end
    end
      always@(posedge button_push_3s_exit)
      begin
          if(button_push_3s_exit && enough) begin
            //password <= value_16bit;
            if(disable_cnt == 1'd1) begin
            password <= value_16bit;
            dis_2 <= ~dis_2;
            end
          else dis_2<= ~dis_2;
          end
          end
     always@(negedge button_push_exit)
      begin
       if(disable_cnt == 1'd1) begin
          if(!button_push_exit ) begin
            dis_3 <= ~dis_3;
            end
          else dis_3<= ~dis_3;
          end
                end         
       always@(posedge clk_in) begin
       if(dis_1 == 1'd1 && dis_2 == 1'd0 && dis_3 == 1'd0) disable_cnt=1'd1;
       else if(dis_1 == 1'd0 && dis_2 == 1'd0 && dis_3 == 1'd1) disable_cnt=1'd1;
       else if(dis_1 == 1'd0 && dis_2 == 1'd1 && dis_3 == 1'd0) disable_cnt=1'd1;
       else if(dis_1 == 1'd1 && dis_2 == 1'd1 && dis_3 == 1'd1) disable_cnt=1'd1;
       else  disable_cnt=1'd0;
      
      end
endmodule