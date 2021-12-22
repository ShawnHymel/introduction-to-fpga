// Input 2 MHz clock and 1 MHz sqaure wave signal. Phase shift the
// 1 MHz signal to force metastability.
//
// Connections
//  Signal  | IceStick      | AnalogDiscovery 2 | Oscilloscope  
// ---------|---------------|-------------------|---------------
//  VCC     | 3.3V          | vary 0.7 to 3.3V  |
//  GND     | GND           | GND               | ground clips
//  clk_in  | 87            | W1                |
//  sig_in  | 88            | W2                | ch. 1
//  clk_out | 90            |                   | ch. 2
//  sig_out | 91            |                   | ch. 3    
//
// Date: December 18, 2021
// Author: Shawn Hymel
// License: 0BSD

// Sample input waveform and register it
module metastability_test (

    // Inputs
    input               clk_in,
    input               sig_in,    
    
    // Outputs
    output              clk_out,
    output  reg         sig_out = 0
);
    
    // Internal storage elements
    reg     div_sig;
    reg     pipe_0;
    
    // Pass input clock to output pin
    assign clk_out = clk_in;

    // Register input signal
    always @ (posedge clk_in) begin
        sig_out <= sig_in;
        //pipe_0 <= sig_in;
        //sig_out <= pipe_0;
    end
    
endmodule