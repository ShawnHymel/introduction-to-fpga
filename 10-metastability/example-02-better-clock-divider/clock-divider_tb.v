// Test clock divider operation. The divider output (tick) should
// pulse once at each divided cycle.
//
// Date: December 16, 2021
// Author: Shawn Hymel
// License: 0BSD

// Define timescale
`timescale 1 us / 10 ps

// Define our testbench
module clock_divider_tb();

    // Settings
    localparam  MODULO = 120;   // 12 MHz / 120 = 100 kHz ticks
    
    // Internal signals
    wire    tick;
    
    // Internal storage elements
    reg     clk = 0;
    reg     rst = 0;
    
    // Simulation time: 10000 * 1 us = 10 ms
    localparam DURATION = 10000;
    
    // Generate clock signal
    always begin
        #0.04167
        clk = ~clk;
    end
    
    // Instantiate clock divider
    clock_divider #(
        .MODULO(MODULO)
    ) uut (
        .clk(clk),
        .rst(rst),
        .tick(tick)
    );
    
    // Test control: run for some time, toggle reset, let run some more
    initial begin
        #10
        rst = 1;
        #1
        rst = 0;
    end
    
    // Run simulation (output to .vcd file)
    initial begin
    
        // Create simulation output file 
        $dumpfile("clock-divider_tb.vcd");
        $dumpvars(0, clock_divider_tb);
        
        // Wait for given amount of time for simulation to complete
        #(DURATION)
        
        // Notify and end simulation
        $display("Finished!");
        $finish;
    end
    
endmodule