// Testbench for sequencer
//
// Make sure the sequencer can store and replay step values.
//
// Date: November 15, 2021
// Author: Shawn Hymel
// License: 0BSD

// Defines timescale for simulation: <time_unit> / <time_precision>
`timescale 1 ns / 10 ps

// Define our testbench
module memory_tb();

    // Internal signals
    wire    [1:0]  led;
    
    // Storage elements
    reg             clk = 0;
    reg             rst_btn = 1;
    reg             set_btn = 1;
    reg             ptn_0_btn = 1;
    reg             ptn_1_btn = 1;

    // Simulation time: 50000 * 1 ns = 50 us
    localparam DURATION = 50000;
    
    // Generate clock signal: 1 / ((2 * 41.67) * 1 ns) = 11,999,040.08 MHz
    always begin
        #41.67
        clk = ~clk;
    end
    
    // Instantiate the unit under test (UUT)
    sequencer_top #(
        .DEBOUNCE_COUNTS(2),
        .STEP_COUNTS(10),
        .NUM_STEPS(8)
    ) uut (
        .clk(clk),
        .rst_btn(rst_btn),
        .set_btn(set_btn),
        .ptn_0_btn(ptn_0_btn),
        .ptn_1_btn(ptn_1_btn),
        .led(led),
        .unused_led()
    );
    
    // Run test: write to sequencer and make sure it plays the sequence back
    initial begin
    
        // Toggle reset
        #10
        rst_btn = 0;
        #1
        rst_btn = 1;
        
        // View a few default steps
        #(50 * 41.67)
        
        // Write 'b11 to the sequencer
        #(10 * 41.67)
        ptn_0_btn = 0;
        ptn_1_btn = 0;
        set_btn = 0;
        #(10 * 41.67)
        ptn_0_btn = 1;
        ptn_1_btn = 1;
        set_btn = 1;
        
        // Write 'b11 to the sequencer
        #(10 * 41.67)
        ptn_0_btn = 0;
        ptn_1_btn = 0;
        set_btn = 0;
        #(10 * 41.67)
        ptn_0_btn = 1;
        ptn_1_btn = 1;
        set_btn = 1;
    end
    
    // Run simulation (output to .vcd file)
    initial begin
    
        // Create simulation output file 
        $dumpfile("sequencer-top_tb.vcd");
        $dumpvars(0, memory_tb);
        
        // Wait for given amount of time for simulation to complete
        #(DURATION)
        
        // Notify and end simulation
        $display("Finished!");
        $finish;
    end
    
endmodule