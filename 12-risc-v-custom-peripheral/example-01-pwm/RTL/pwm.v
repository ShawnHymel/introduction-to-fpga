// PWM driver for FemtoRV: https://github.com/BrunoLevy/learn-fpga
//
// Controls brightness of first LED. Set duty cycle with wdata (0..4095).
//
// Date: December 15, 2021
// Author: Shawn Hymel
// License: 0BSD

// Control brightness of one of the LEDs
module pwm #(

    // Parameters
    parameter       WIDTH = 12  // Default PWM values 0..4095

) (

    // Inputs
    input           clk,
    input           wstrb,  // Write strobe
    input           sel,    // Select (read/write ignored if low)
    input   [31:0]  wdata,  // Data to be written (to driver)
    
    // Outputs
    output  [3:0]   led
);

    // Internal storage elements
    reg             pwm_led = 1'b0;
    reg [WIDTH-1:0] pwm_count = 0;
    reg [WIDTH-1:0] count = 0;
    
    // Only control the first LED
    assign led[0] = pwm_led;
    
    // Update PWM duty cycle 
    always @ (posedge clk) begin
    
        // If sel is high, record duty cycle count on strobe
        if (sel && wstrb) begin
            pwm_count <= wdata[WIDTH-1:0];
            count <= 0;
            
        // Otherwise, continuously count and flash LED as necessary
        end else begin
            count <= count + 1;
            if (count < pwm_count) begin
                pwm_led <= 1'b1;
            end else begin
                pwm_led <= 1'b0;
            end
        end
    end
    
endmodule