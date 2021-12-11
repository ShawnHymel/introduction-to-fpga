// Simulation of glitches with a ripple-carry adder.
//
// Date: December 6, 2021
// Author: Shawn Hymel
// License: 0BSD

// Defines timescale for simulation: <time_unit> / <time_precision>
`timescale 1 ns / 1 ps

// Half adder (with gate delays)
module half_adder (

    // Inputs
    input a,
    input b,
    
    // Output
    output sum,
    output c_out
);

    // Create output logic
    assign #1 sum = a ^ b;
    assign #1 c_out = a & b;
    
endmodule

// Define our testbench
module glitch_test_tb();

    // Simulation time: 10000 * 1 ns = 10000 ns
    localparam DURATION = 10000;

    // Internal signals
    wire            c_0;
    wire            c_1;
    wire            c_2;
    wire    [3:0]   out;
    
    // Internal storage elements
    reg             clk = 0;
    reg             rst = 0;
    reg     [3:0]   count;
    
    // Generate clock signal: 1 / ((2 * 4.167) * 1 ns) = 119,990,400.77 Hz
    always begin
        #4.167
        clk = ~clk;
    end
    
    // Instantiate half adders
    half_adder ha_0 (.a(1'b1), .b(count[0]), .sum(out[0]), .c_out(c_0));
    half_adder ha_1 (.a(c_0), .b(count[1]), .sum(out[1]), .c_out(c_1));
    half_adder ha_2 (.a(c_1), .b(count[2]), .sum(out[2]), .c_out(c_2));
    half_adder ha_3 (.a(c_2), .b(count[3]), .sum(out[3]), .c_out());
    
    // Let the counter count
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            count = 0;
        end else begin
            count <= out;
        end
    end
    
    // Pulse reset line high at the beginning
    initial begin
        #10
        rst = 1;
        #1
        rst = 0;
    end
    
    // Run simulation (output to .vcd file)
    initial begin
    
        // Create simulation output file 
        $dumpfile("glitch-test_tb.vcd");
        $dumpvars(0, glitch_test_tb);
        
        // Wait for given amount of time for simulation to complete
        #(DURATION)
        
        // Notify and end simulation
        $display("Finished!");
        $finish;
    end
    
endmodule