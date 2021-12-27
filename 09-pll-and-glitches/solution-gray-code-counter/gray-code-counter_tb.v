// Simulation of a 4-bit gray code counter using a finite state machine.
//
// Date: December 6, 2021
// Author: Shawn Hymel
// License: 0BSD

// Defines timescale for simulation: <time_unit> / <time_precision>
`timescale 1 ns / 1 ps

// 4-bit gray code counter FSM
module gray_counter (

    // Inputs
    input               clk,
    input               rst,
    
    // Outputs
    output  reg [3:0]   count
);

    // State machine transitions (with simulated delays)
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            count <= 0;
        end else begin
            case (count)                            // Gray code state
                4'b0000:    #1 count <= 4'b0001;    // 0
                4'b0001:    #1 count <= 4'b0011;    // 1
                4'b0011:    #1 count <= 4'b0010;    // 2
                4'b0010:    #1 count <= 4'b0110;    // 3
                4'b0110:    #1 count <= 4'b0111;    // 4
                4'b0111:    #1 count <= 4'b0101;    // 5
                4'b0101:    #1 count <= 4'b0100;    // 6
                4'b0100:    #1 count <= 4'b1100;    // 7
                4'b1100:    #1 count <= 4'b1101;    // 8
                4'b1101:    #1 count <= 4'b1111;    // 9
                4'b1111:    #1 count <= 4'b1110;    // 10
                4'b1110:    #1 count <= 4'b1010;    // 11
                4'b1010:    #1 count <= 4'b1011;    // 12
                4'b1011:    #1 count <= 4'b1001;    // 13
                4'b1001:    #1 count <= 4'b1000;    // 14
                4'b1000:    #1 count <= 4'b0000;    // 15
                default:    #1 count <= 4'b0000;
            endcase
        end
    end
    
endmodule

// Define our testbench
module gray_counter_tb();

    // Simulation time: 10000 * 1 ns = 10000 ns
    localparam DURATION = 10000;

    // Internal signals
    wire    [3:0]   out;
    
    // Internal storage elements
    reg             clk = 0;
    reg             rst = 0;
    
    // Generate clock signal: 1 / ((2 * 4.167) * 1 ns) = 119,990,400.77 Hz
    always begin
        #4.167
        clk = ~clk;
    end
    
    // Instantiate gray code counter
    gray_counter gray (.clk(clk), .rst(rst), .count(out));
    
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
        $dumpfile("gray-code-counter_tb.vcd");
        $dumpvars(0, gray_counter_tb);
        
        // Wait for given amount of time for simulation to complete
        #(DURATION)
        
        // Notify and end simulation
        $display("Finished!");
        $finish;
    end
    
endmodule
