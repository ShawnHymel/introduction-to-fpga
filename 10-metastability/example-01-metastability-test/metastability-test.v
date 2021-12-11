// Input 2 square waves at same frequency (e.g. 100 kHz). Adjust phase
// difference to see if metastable output (sig_out) occurs.
//
// Date: December 9, 2021
// Author: Shawn Hymel
// License: 0BSD

// Sample input waveform and register it
module metastability_test (

    // Inputs
    input               rst_btn,
    input               clk,
    input               sig_in,    
    
    // Outputs
    output  reg         sig_out
);

    // Internal signals
    wire    rst;
    
    // Internal storage elements
    reg     div_sig;
    reg     pipe_0;

    // Continuous assignment
    assign rst = ~rst_btn;
    
    // Simple clock divider
    always @ (posedge sig_in or posedge rst) begin
        if (rst == 1'b1) begin
            div_sig <= 0;
        end else begin
            div_sig <= ~div_sig;
        end
    end

    // Sample input signal and register on output (added second register
    // to lower chances of metastability).
    always @ (posedge clk) begin
        pipe_0 <= div_sig;
        sig_out <= pipe_0;
    end
    
endmodule