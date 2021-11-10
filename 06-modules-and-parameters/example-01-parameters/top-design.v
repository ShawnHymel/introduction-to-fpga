// Example of a top-level design with 2 different clocks.
// 
// Inputs:
//      clk         - 12 MHz clock
//      rst_btn     - pushbutton (RESET)
// 
// Outputs:
//      led[1:0]    - LEDs
// 
// LED[0] should flash at 4 Hz and LED[1] should flash at 1 Hz.
//
// Date: November 8, 2021
// Author: Shawn Hymel
// License: 0BSD

// Top-level design that produces 2 different divided clocks
module top_design (

    // Inputs
    input           clk,
    input           rst_btn,
    
    // Outputs
    output  [1:0]   led         // Not reg element!
);

    // Internal signals
    wire rst;
    
    // Invert active-low button
    assign rst = ~rst_btn;

    // Instantiate the first clock divider module
    clock_divider div_1 (
        .clk(clk), 
        .rst(rst), 
        .out(led[0])
    );
    defparam div_1.COUNT_WIDTH  = 32;
    defparam div_1.MAX_COUNT    = 1500000 - 1;
    
    // Instantiate the second clock divider module
    clock_divider div_2 (
        .clk(clk),
        .rst(rst),
        .out(led[1])
    );
                    
endmodule