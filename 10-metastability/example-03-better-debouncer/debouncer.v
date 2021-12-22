// Debounce signal logic without the use of a clock divider.
//
// Based on: https://forum.digikey.com/t/debounce-logic-circuit-vhdl/12573
//
// Date: December 16, 2021
// Author: Shawn Hymel
// License: 0BSD

// Debouncing logic
module debouncer #(
    
    // Parameters
    parameter MAX_CLK_COUNT = 120000    // 10 ms with 12 MHz clock
) (

    // Inputs
    input           clk,
    input           rst,
    input           sig,
    
    // Outputs
    output  reg     out
);

    // Calculate number of bits needed for the counter
    localparam WIDTH = $clog2(MAX_CLK_COUNT + 1);
    
    // Internal signals
    wire            sig_edge;

    // Internal storage elements
    reg             ff_1;
    reg             ff_2;
    reg [WIDTH-1:0] count = 0;
    
    // Counter starts when outputs of the two flip-flops are different
    assign sig_edge = ff_1 ^ ff_2;
    
    // Logic to sample signal after a period of time
    always @ (posedge clk or posedge rst) begin
    
        // Reset flip-flops
        if (rst == 1'b1) begin
            ff_1 <= 0;
            ff_2 <= 0;
            out <= 0;
        
        // If rising or falling edge on signal, run counter and sample again
        end else begin
            ff_1 <= sig;
            ff_2 <= ff_1;
            if (sig_edge == 1'b1) begin
                count <= 0;
            end else if (count < MAX_CLK_COUNT) begin
                count <= count + 1;
            end else begin
                out <= ff_2;
            end
        end
    end
    
endmodule