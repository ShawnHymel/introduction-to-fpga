// Input 2 square waves at same frequency (e.g. 100 kHz). Adjust phase
// difference to see if metastable output (sig_out) occurs.
//
// Date: December 9, 2021
// Author: Shawn Hymel
// License: 0BSD

// Sample input waveform and register it
module metastability_test (

    // Inputs
    input               clk,
    input               sig_in,    
    
    // Outputs
    output  reg         div_sig = 0,
    output  reg         sig_out
);
    
    // Internal storage elements
    reg     pipe_0;

    
    // Simple clock divider
    always @ (posedge sig_in) begin
        div_sig <= ~div_sig;
    end

    // Sample input signal and register on output (added second register
    // to lower chances of metastability).
    always @ (posedge clk) begin
        // sig_out <= div_sig;
        pipe_0 <= div_sig;
        sig_out <= pipe_0;
    end
    
endmodule