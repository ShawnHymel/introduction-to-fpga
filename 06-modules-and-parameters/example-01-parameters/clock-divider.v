// Simple clock divider
//
// Parameters:
//      COUNT_WIDTH - Bus width for counter
//      MAX_COUNT   - Maximum value of counter
// 
// Inputs:
//      clk         - Input clock
//      rst         - Reset signal
// 
// Outputs:
//      out         - Divided clock output
// 
// Toggles out line at a divided rate given clk input.
//
// Date: November 8, 2021
// Author: Shawn Hymel
// License: 0BSD

// Clock divider
module clock_divider (

    // Inputs
    input       clk,
    input       rst,
    
    // Outputs
    output  reg out    
);

    // Parameters
    parameter                   COUNT_WIDTH = 24;
    parameter [COUNT_WIDTH:0]   MAX_COUNT   = 6000000 - 1;

    // Internal signals
    wire rst;
    reg div_clk;
    reg [COUNT_WIDTH:0] count;
    
    // Clock divider
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            count <= 0;
            out <= 0;
        end else if (count == MAX_COUNT) begin
            count <= 0;
            out <= ~out;
        end else begin
            count <= count + 1;
        end
    end
    
endmodule