`timescale 1ns / 1ps

module mergeALL(
    input btn0,
    input btn1,
    input [3:0] row,
    output [3:0] col, 
    input clk,
    output [15:0] led7_out,
    output [2:0] rgb,
    output lock_status,
    output eval,
    output success,
    output [2:0] state,
    output lock
    );
    wire [2:0] error_counter;
    wire [15:0] led_cnt16;
    wire [9:0] led_cnt;
    wire reset;
    wire [15:0] np_16bit;
    wire [15:0] value_16bit;
    wire [15:0] pw_16bit;
    wire [15:0] password;

    wire enough;
    wire [3:0] value_4bit;
    wire temp;
    assign lock = !enb_inp && temp; 
    assign clear = btn1 & !enb_lock & !enb_inp;
     l_seg_display L0(.clk_in (clk)
                    ,.confirm(btn0)
                    ,.reset(gen_rst | reset | clear)
                    ,.enb_count(enb_inp)
                    ,.led_cnt16(led_cnt16)
                    ,.lock(temp)
                    ,.value_4bit(value_4bit)
                    ,.led7_out(led7_out)
                    ,.pw_16bit(value_16bit)
                    ,.enough(enough)
                    );
                     
    a_main M1(
                .pw_16bit(value_16bit)
                ,.password(password)
                ,.disable_cnt(disable_cnt)
                ,.enough(enough)
                ,.reset(reset)               
                ,.enb_lock(enb_lock)
                ,.gen_stop(gen_stop)
                ,.error_counter(error_counter)
                ,.gen_rst(gen_rst)
                );
                
                
    d_main M2 (
                .enb_lock(enb_lock)                     //có ðúng hay không                 
                ,.disable_cnt(disable_cnt)              //có ðang trong mode nh?n mk m?i hay không
                ,.enb_cnt(lock_status)                  //ðang ? tr?ng thái m?  hay ðóng
                ,.ignore(btn0)                          //
                ,.gen_stop(gen_stop)                    //có ðang ? tr?ng thái ð?m ngý?c j kh, là tín hi?u hold
                ,.error_counter(error_counter)          //c?ng là tín hi?u hold
                ,.clk_in(clk)                           
                ,.enb_set(enb_set)                      //output ð? bi?t là có th? ðý?c vào mode ð?t l?i m?t kh?u   
                ,.enb_inp(enb_inp)                      //cho phép l_display ðc nh?n tín hi?u t? nút confirm 
                ,.reset(reset)                           //m?i tr?ng thái v? l?i idle ð?u s? cho reset
                ,.led_cnt(led_cnt)                  
                ,.rgb_out(rgb)
                ,.eval(eval)
                ,.evcp(evcp)
                ,.state(state)
                );    
                
    l_10_to_16bit L1(.led_cnt(led_cnt)
                    ,.led_cnt16(led_cnt16)
                    );   
                    
    h_newlock_v2 H0(.enb_inp(enb_inp)
                    ,.enb_set(enb_set)
                    ,.exit_button(btn1)
                    ,.enough(enough)
                    ,.value_16bit(value_16bit)
                    ,.confirm_button(btn0)
                    ,.clk_in(clk)
                    ,.disable_cnt(disable_cnt)
                    ,.password(password)
                    ,.success(success)
                    );
                
    h_un_lock H1(.clk_in(clk)
                    ,.enb_lock(enb_lock)
                    ,.disable_cnt(evcp)
                    ,.button(btn1)
                    ,.enb_cnt(lock_status)
                    );
    matkey mat_key (
        .clk(clk),
        .row(row),
        .col(col),
        .value_4bit(value_4bit),
        .lock(temp)
    );
    
endmodule
