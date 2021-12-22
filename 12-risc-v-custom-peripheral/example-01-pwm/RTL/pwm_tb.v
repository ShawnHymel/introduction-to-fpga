// Simulation of PWM driver.
//
// Date: December 15, 2021
// Author: Shawn Hymel
// License: 0BSD

// Define timescale
`timescale 1 ns / 10 ps

// Testbench
module pwm_tb();

    // Simulation time: 10000 * 1 us = 10 ms
    localparam DURATION = 10000;
    
    // Internal signals
    wire    [3:0]   led;    

    // Internal storage elements
    reg             clk = 0;
    reg             wstrb = 0;
    reg             sel = 0;
    reg     [31:0]  wdata = 0;

    // Generate read clock signal (about 12 MHz)
    always begin
        #41.667
        clk = ~clk;
    end
    
    // Instantiate PWM driver
    pwm #(
        .WIDTH(4)
    ) uut (
        .clk(clk),
        .wstrb(wstrb),
        .sel(sel),
        .wdata(wdata),
        .led(led)
    );
    
    // Test control: send values to PWM driver and watch LED
    initial begin
        
        // Wait some time to see how LED initializes
        #1500
        
        // Write 0% duty cycle
        wstrb = 1;
        sel = 1;
        wdata = 0;
        #100
        wstrb = 0;
        sel = 0;
        
        // Write ~33% duty cycle
        #1500
        wstrb = 1;
        sel = 1;
        wdata = 5;
        #100
        wstrb = 0;
        sel = 0;
        
        // Write 100% duty cycle
        #1500
        wstrb = 1;
        sel = 1;
        wdata = 15;
        #100
        wstrb = 0;
        sel = 0;
    end
    
    // Run simulation (output to .vcd file)
    initial begin
    
        // Create simulation output file
        $dumpfile("pwm_tb.vcd");
        $dumpvars(0, pwm_tb);
        
        // Wait for given amount of time for simulation to complete
        #(DURATION)
        
        // Notify and end simulation
        $display("Finished!");
        $finish;
    end

endmodule