`timescale 1ns / 1ps

module l_seg_display(
    input clk_in, confirm, reset, enb_count,
    input [15:0] led_cnt16,
    input lock,
    input [3:0] value_4bit,
    output reg [15:0] led7_out = 16'hFFFF, 
    output reg [15:0] pw_16bit,
    output reg enough = 1'b0

);

    reg [27:0] blink_counter = 28'd0;
    reg [3:0] reg0 = 4'b1111;
    reg [3:0] reg1 = 4'b1111;
    reg [3:0] reg2 = 4'b1111;
    reg [3:0] reg3 = 4'b1111;
    reg toggle_display = 1'b1;
    reg [3:0] count = 4'd0;
    //clock
    wire clk_12500hz, button;
    button_push bt(clk_in, lock, button);
    clk_divider #(.DIV(28'd12500)) clk_out2(clk_in, 'd0 ,clk_12500hz);

    always @(posedge clk_12500hz ) begin
            if (enb_count) begin
            led7_out <= led_cnt16;
            end else begin
            reg3 <= value_4bit;
            blink_counter <= blink_counter + 1;
            
            if (blink_counter == 28'd12500) begin 
                toggle_display <= ~toggle_display;
                blink_counter <= 28'd0;
            end
            
            if (button == 1'd1) begin
                led7_out <= {reg0, reg1, reg2, reg3};
                toggle_display <= 1'd1;
            end
            else if (toggle_display == 1'b0 && count <= 4'd3) begin
                led7_out <= {reg0, reg1, reg2, 4'b1111}; 
            end
            else if (toggle_display == 1'b1 && count <= 4'd3)
                led7_out <= {reg0, reg1, reg2, reg3}; 
            end
        end
 

    // Register shift control on button
    always @(posedge (button) or posedge reset) begin
        if (reset) begin
            reg2 <= 4'b1111;
            reg1 <= 4'b1111;
            reg0 <= 4'b1111;
            count <= 0;
            enough <= 1'b0;
        end 
        else begin
        // Button edge detection
        if (button & !enb_count) begin
            case (count)
                4'd0: begin
                    reg2 <= reg3;
                    reg1 <= 4'b1111;
                    reg0 <= 4'b1111;
                    count <= count + 4'd1;
                end
                4'd1: begin
                    reg2 <= reg3;
                    reg1 <= reg2;
                    reg0 <= 4'b1111;
                    count <= count + 4'd1;
                end
                4'd2: begin
                    reg2 <= reg3;
                    reg1 <= reg2;
                    reg0 <= reg1;
                    count <= count + 4'd1;
                end
                4'd3: begin
                    count <= count + 4'd1;
                    pw_16bit <= {reg0, reg1, reg2, reg3};
                    enough <= 1'b1;
                end
                default: begin end
            endcase
        end
    end
end

            
endmodule
