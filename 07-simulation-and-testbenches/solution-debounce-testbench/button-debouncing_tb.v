// Testbench for button debounce design
//
// Date: November 11, 2021
// Author: Shawn Hymel
// License: 0BSD

// Define timescale
`timescale 1 us / 10 ps

// Define our testbench
module button_debouncing_tb();

    // Internal signals
    wire    [3:0]   out;
    
    // Storage elements (buttons are active low!)
    reg             clk = 0;
    reg             rst_btn = 1;
    reg             inc_btn = 1;
    integer         i;              // Used in for loop
    integer         j;              // Used in for loop
    integer         prev_inc;       // Previous increment button state
    integer         nbounces;       // Holds random number
    integer         rdelay;         // Holds random number
    
    // Simulation time: 10000 * 1 us = 10 ms
    localparam DURATION = 10000;
    
    // Generate clock signal (about 12 MHz)
    always begin
        #0.04167
        clk = ~clk;
    end
    
    // Instantiate debounce/counter module (use about 400 us wait time)
    debounced_counter #(.MAX_CLK_COUNT(4800 - 1)) uut (
        .clk(clk),
        .rst_btn(rst_btn),
        .inc_btn(inc_btn),
        .led(out)
    );
    
    // Test control: pulse reset and create some (bouncing) button presses
    initial begin
    
        // Pulse reset low to reset state machine
        #10
        rst_btn = 0;
        #1
        rst_btn = 1;
        
        // We can use for loops in simulation!
        for (i = 0; i < 32; i = i + 1) begin
        
            // Wait some time before pressing button
            #1000
            
            // Simulate a bouncy/noisy button press
            // $urandom generates a 32-bit unsigned (pseudo) random number
            // "% 10" is "modulo 10"
            prev_inc = inc_btn;
            nbounces = $urandom % 20;
            for (j = 0; j < nbounces; j = j + 1) begin
                #($urandom % 10)
                inc_btn = ~inc_btn;
            end
            
            // Make sure button ends up in the opposite state
            inc_btn = ~prev_inc;
        end
    end
    
    // Run simulation (output to .vcd file)
    initial begin
    
        // Create simulation output file 
        $dumpfile("button-debouncing_tb.vcd");
        $dumpvars(0, button_debouncing_tb);
        
        // Wait for given amount of time for simulation to complete
        #(DURATION)
        
        // Notify and end simulation
        $display("Finished!");
        $finish;
    end
    
endmodule