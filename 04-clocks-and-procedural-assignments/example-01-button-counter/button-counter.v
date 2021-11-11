// Button counter
//
// Inputs:
//      pmod[0]     - pushbutton (RESET)
//      pmod[1]     - pushbutton (CLOCK)
// Outputs:
//      led[3:0]    - LEDs (count from 0x0 to 0xf)
//
// LEDs will count up in binary on each CLOCK button press. Note: there will
// be a lot of button bounce, so don't worry if the numbers seem to skip around!
//
// Date: October 26, 2021
// Author: Shawn Hymel
// License: 0BSD

// Count up on each button press and display on LEDs
module button_counter (

    // Inputs
    input       [1:0]   pmod,
    
    // Outputs
    output  reg [3:0]   led
);

    wire rst;
    wire clk;

    // Reset is the inverse of the first button
    assign rst = ~pmod[0];

    // Clock signal is the inverse of second button
    assign clk = ~pmod[1];

    // Count up on clock rising edge or reset on button push
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            led <= 4'b0;
        end else begin
            led <= led + 1'b1;
        end
    end
    
endmodule