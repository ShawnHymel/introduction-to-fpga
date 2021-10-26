// Solution to full adder challenge
//
// Inputs:
//      pmod[2:0]   - pushbuttons (x3)
//
// Outputs:
//      led[1:0]    - LEDs (x2)
//
// LED 0 turns on if 1 or 3 buttons are pressed. LED 1 turns on if 2 or 3
// buttons are pressed.
//
// Date: October 25, 2021
// Author: Shawn Hymel
// License: 0BSD

// Full adder with button inputs
module full_adder (

    // Inputs
    input   [2:0]   pmod,
    
    // Output
    output  [1:0]   led
);

    // Wire (net) declarations (internal to module)
    wire a;
    wire b;
    wire c_in;
    wire a_xor_b;
    
    // A, B, and C_IN are inverted button logic
    assign a = ~pmod[0];
    assign b = ~pmod[1];
    assign c_in = ~pmod[2];
    
    // Create intermediate wire (net)
    assign a_xor_b = a ^ b;

    // Create output logic
    assign led[0] = a_xor_b ^ c_in;
    assign led[1] = (a_xor_b & c_in) | (a & b);
    
endmodule