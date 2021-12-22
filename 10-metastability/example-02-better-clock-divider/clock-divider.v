// A better way to create a clock divider that does not use flip-flip outputs
// as clock inputs to other flip-flops. Us the tick pulse in combination with
// other logic to determine when to perform some action.
//
// Based on work by: https://github.com/Paebbels
//
// Date: December 16, 2021
// Author: Shawn Hymel
// License: 0BSD

// Divide the clock by outputting a pulse at the desired time
module clock_divider #(

    // Parameters
    parameter   MODULO  = 6000000
) (
    
    // Inputs
    input   clk,
    input   rst,
    
    // Outputs
    output  tick
);

    // Calculate number of bits needed for the counter
    localparam WIDTH = (MODULO == 1) ? 1 : $clog2(MODULO);

    // Internal storage elements
    reg [WIDTH-1:0] count = 0;

    // Tick is high for one clock cycle at max count
    assign tick = (count == MODULO - 1) ? 1'b1 : 1'b0;
    
    // Count up, reset on tick pulse
    always @ (posedge clk or posedge rst) begin
        if (rst | tick == 1'b1) begin
            count <= 0;
        end else begin
            count <= count + 1;
        end
    end
    
endmodule