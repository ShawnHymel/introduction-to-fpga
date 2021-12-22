// Slow blink example using the better clock divider.
//
// Based on work by: https://github.com/Paebbels
//
// Date: December 16, 2021
// Author: Shawn Hymel
// License: 0BSD

// Slow blink top level design
module slow_blink (

    // Inputs
    input           clk,
    input           rst_btn,    
    
    // Outputs
    output  reg     led
);

    // Settings
    localparam MODULO = 6000000;    // Toggle LED every 0.5 s with 12 MHz clk
    
    // Internal signals
    wire    rst;
    wire    tick;
    
    // Invert reset button
    assign rst = ~rst_btn;

    // Instantiate clock divider
    clock_divider #(
        .MODULO(MODULO)
    ) uut (
        .clk(clk),
        .rst(rst),
        .tick(tick)
    );
    
    // Example using clock divider to blink LED
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            led <= 1'b0;
        end else if (tick == 1'b1) begin
            led <= ~led;
        end
    end
    
endmodule