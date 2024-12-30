`timescale 1ns / 1ps

module h_un_lock(
    input clk_in,
          enb_lock,
          disable_cnt,
          button,
    output reg enb_cnt = 1'd0
    );
    
    button_push B1 (clk_in, button, d_button);

    
    always @(posedge d_button) begin
        if (enb_lock && !disable_cnt) begin
            enb_cnt <= ~enb_cnt;  
        end
    end
    
endmodule
