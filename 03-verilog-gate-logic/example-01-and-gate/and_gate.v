// AND gate example
//
// Inputs:
//      pmod_0  - pushbutton
//      pmod_1  - pushbutton
// Outputs:
//      led_0   - LED
//
// LED will turn on if both pushbuttons are pressed (~pmod_0 & ~pmod_1).
//
// Date: October 13, 2021
// Author: Shawn Hymel
// License: 0BSD

// Module: when buttons 1 and 2 are pressed, turn on LED
module and_gate (

    // Inputs
    input   pmod_0,
    input   pmod_1,
    
    // Outputs
    output  led_0
);

    // Continuous assignment: NOT and AND operators
    assign led_0 = ~pmod_0 & ~pmod_1;
    
endmodule