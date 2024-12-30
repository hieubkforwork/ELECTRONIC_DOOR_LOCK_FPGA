`timescale 1ns / 1ps

module d_module_timer(
    input enb_lock,                         
    input disable_cnt,                      
    input enb_cnt,
    input ignore,
    input gen_stop,
    input [2:0] error_counter,
    input clk_in,                          //128Mhz
    output reg enb_set = 1'b0,                         
    output reg enb_inp = 1'b0,                         
    output reg reset = 'd0,                           
    output reg [9:0] led_cnt = 'd0,
    output reg [2:0] led_rgb = 'd0,
    output reg rgb_toggle = 'd0,
    output reg idle = 'd0,
    output reg eval = 1'b0
    ,output reg evcp = 1'b0
    ,output reg [2:0] state = 'd0
    );
    //States
    localparam IDLE = 3'b000;
    localparam WAIT = 3'b001;
    localparam OPEN = 3'b010;
    localparam CLOSE = 3'b011;
    localparam NEW = 3'b100;
    localparam EXIT = 3'b101;
    localparam WRONG = 3'b110;
    localparam WARNING = 3'b111;
    
    //LED RGB:
    localparam OFF = 3'b000;
    localparam RED = 3'b100;
    localparam GREEN = 3'b010;
    localparam YELLOW = 3'b110;
    localparam WHITE = 3'b111;
    localparam BLUE = 3'b001;
    
//    reg [2:0] state;
    reg evop = 1'd0;
    reg exit = 1'b0;
    reg evig = 1'b0;
    //Timer
    reg [4:0] cw10 = 'd10;
    reg [4:0] cl10 = 'd10;
    reg [4:0] co30 = 'd30;
    reg [2:0] exittime = 'd2;
    reg [2:0] pre_state = IDLE;
    reg flash = 1'd1;
    reg pulse_count = 'd0;
    //Wrong case
    reg [9:0] wrong_timer_minus = 'd0;
//    reg idle = 'd0;
    button_push B2 (clk_in, ignore, ignore_sta);
    
    always @(posedge enb_cnt, posedge idle) begin 
        if (idle) begin
            evop <= 'd0;   
        end
        else if (enb_lock == 1'b1 && enb_cnt == 1'b1 && disable_cnt == 1'b0 && evop == 1'b0 && evcp == 1'b0 && state == WAIT) evop <= 1'b1;
        
    end
    
    always @(posedge disable_cnt, posedge idle) begin 
        if (idle) begin
            evcp <= 'd0;            
        end
        else if (enb_lock == 1'b1 && enb_cnt == 1'b0 && disable_cnt == 1'b1 && evop == 1'b0 && evcp == 1'b0 && state == WAIT) evcp <= 1'b1;        
    end
    
    always @(posedge clk_in) begin    
        if (idle == 1'b1) begin 
            state <= IDLE;
            pre_state <= state;
            reset <= 1'b1;    
        end
        else begin
            if (reset) begin 
                reset <=1'b0;
            end   
            
            //TODO: IDENTIFY CORRECT CASES
            if (enb_lock == 1'b1) begin 
                //TODO: WAIT
                if (!evop && !evcp ) begin
                    state <= WAIT;
                    pre_state <= state;
                end
                 //TODO: EXIT
                else if (!evop && evcp && !disable_cnt) begin 
                    state <= EXIT;
                    pre_state <= state;
                end 
                //TODO: NEW PASS
                else if (!evop && evcp && disable_cnt) begin 
                    state <= NEW;
                    pre_state <= state;
                end
                 
                //TODO: CLOSE 
                else if (evop && !evcp && !disable_cnt) begin 
                    if (enb_cnt == 1'b0) begin 
                        state <= CLOSE;
                        pre_state <= state;
                    end
                //TODO: OPEN
                    else begin 
                        state <= OPEN;
                        pre_state <= state;
                    end                
                end
                //ANOTHER CASE INVALID
                else begin end 
            end 
            //TODO: IDENTIFY WRONG CASES
            else begin 
                //TODO: WRONG 1st, 2nd time
                if (gen_stop == 1'b1 && (error_counter == 'd1 || error_counter == 'd2)) begin 
                    state = WARNING;
                    pre_state <= state;
                end
                //TODO: WRONG 3 times continously above
                else if (gen_stop == 1'b1 && error_counter > 'd2) begin 
                    state <= WRONG;
                    pre_state <= state;
                end
            end 
        end  
        if (pulse_count) pulse_count <= 'd0;
        if (pre_state != state) begin
            pulse_count <= 1'b1;
        end    
    end
    
   
    //TODO: There are 2 types of 1Hz clock, non-stop(without reset) and with reset.
    clk_divider #(.DIV(28'd1)) clock_1hz (clk_in, pulse_count, clk_1hz);
    clk_divider #(.DIV(28'd1)) clock_1hz_ns (evop & clk_in, 1'b0, clk_1hz_ns); 
    
    and A0 (clocked_1hz, clk_1hz_ns, !eval, !evig);
    
    always @(posedge clocked_1hz, posedge idle) begin
         if (idle == 1'd1) begin
            co30 <= 'd30;
        end 
        else begin
            if (co30 > 'd0 && evop == 'd1) begin 
                co30 <= (co30 == 'd0) ? co30 : co30 - 1;       
            end
        end
    end   
    
    always @(posedge (clk_in)) begin
        if (ignore_sta == 'd1 && eval == 'd1) begin 
            eval <= 1'b0;
            evig <= 1'b1;
        end
        
        else if (co30 == 'd0 && state == OPEN && !eval && !evig) begin 
            eval <= 1'b1;
        end
        
        else if (co30 == 'd0 && state == OPEN && !eval && evig && pre_state == CLOSE) begin
            evig <= 1'b0;   
        end
        
        else if (state == IDLE) begin
            eval <= 1'b0;
            evig <= 1'b0;
        end
    end 
    
    always @(posedge clk_1hz) begin
        case(state)
            IDLE: begin 
                enb_set <= 0;
                enb_inp <= 0;
                led_rgb <= OFF;
                rgb_toggle <= 1'b0;
                flash <= 1'b1;
                //Timer
                cw10 <= 'd10;
                cl10 <= 'd10;
                exittime <= 'd2;
                idle <= 1'd0;
                wrong_timer_minus <= 'd0;
            end
            WAIT: begin 
                enb_set <= 1'b1;
                enb_inp <= 1'b1;
                led_rgb <= GREEN;
                rgb_toggle <= 1'b0;
                //TODO:
                led_cnt <= cw10;
                cw10 <= cw10 - 1'b1;
                if (cw10 == 'd0) begin      
                    idle <= 1'b1;
                end
            end
            OPEN: begin 
                cl10 <= 5'd10;      // reset close counter
                enb_set <= 0;
                enb_inp <= 1;       
                led_rgb <= BLUE;
                rgb_toggle <= 1'b0;
                led_cnt <= co30;
//                TODO:
                if (co30 == 'd0 && eval == 1'b1) begin 
                    rgb_toggle <= 1'b1;
                end   //don't understand
                
            end 
            CLOSE: begin 
                enb_set <= 0;
                enb_inp <= 1;
                led_rgb <= GREEN;
                rgb_toggle <= 1'b1;
                //TODO:
                led_cnt <= cl10;
                cl10 <= cl10 - 1'b1;
                if (cl10 == 'd0) begin    //có th? thay = led_cnt ð? th? ð? chính xác  
                    idle <= 1'b1;
                end
            end
            NEW: begin 
                enb_set <= 1;
                enb_inp <= 0;
                led_rgb <= WHITE;
                rgb_toggle <= 1'b0;
            end
            EXIT: begin 
                enb_set <= 0;
                enb_inp <= 0;
                exittime <= exittime - 1'b1;
                if (exittime == 'd0) begin    //có th? thay = led_cnt ð? th? ð? chính xác  
                    idle <= 1'b1;
                    led_rgb <= OFF;
                end
            end
            WRONG: begin            //Nho la neu reset cung van chua lai bien dem cua wrong_count
                enb_set <= 0;
                enb_inp <= 1;
                led_rgb <= RED;
                rgb_toggle <= 1'b1;
                //TODO:
                led_cnt <= (((error_counter - 'd3)*(error_counter - 'd3) + 1'd1)*'d60) - wrong_timer_minus;
                wrong_timer_minus <= wrong_timer_minus + 1'b1;
                if (wrong_timer_minus == (((error_counter - 'd3)*(error_counter - 'd3) + 1)*'d60)) begin      
                    idle <= 1'b1;
                end
            end
            WARNING: begin 
                enb_set <= 0;
                enb_inp <= 1;
                led_rgb <= RED;
                rgb_toggle <= 1'b0;
                flash <= flash - 1'b1;
                if (flash == 1'b0) begin                     
                    idle <= 1'b1;
                end
            end
        endcase
    end
endmodule
