// One possible way to debounce a button press (using a Moore state machine)
// 
// Inputs:
//      clk         - 12 MHz clock
//      rst         - reset signal
//      in          - input signal
// 
// Outputs:
//      out         - output signal (debounced)
// 
// Single pulse sent on out when in signal goes high for some time.
//
// Date: November 15, 2021
// Author: Shawn Hymel
// License: 0BSD

// Use a state machine to debounce a button
module debouncer #(

    // Max counts for wait state (40 ms with 12 MHz clock)
    parameter                   COUNT_WIDTH     = 20,
    parameter [COUNT_WIDTH:0]   MAX_CLK_COUNT   = 480000 - 1
) (

    // Inputs
    input               clk,
    input               rst,
    input               in,
    
    // Outputs
    output  reg         out
);

    // States
    localparam  STATE_HIGH      = 2'd0;
    localparam  STATE_LOW       = 2'd1;    
    localparam  STATE_WAIT      = 2'd2;
    localparam  STATE_PRESSED   = 2'd3;
    
    // Internal storage elements
    reg [1:0]           state;
    reg [COUNT_WIDTH:0] clk_count;
    
    // State transition logic
    always @ (posedge clk or posedge rst) begin
    
        // On reset, return to idle state
        if (rst == 1'b1) begin
            state <= STATE_HIGH;
            out <= 1'b0;
            
        // Define the state transitions
        end else begin
            case (state)
            
                // Wait for increment signal to go from high to low
                STATE_HIGH: begin
                    out <= 1'b0;
                    if (in == 1'b0) begin
                        state <= STATE_LOW;
                    end
                end
                
                // Wait for increment signal to go from low to high
                STATE_LOW: begin
                    if (in == 1'b1) begin
                        state <= STATE_WAIT;
                    end
                end
                
                // Wait for count to be done and sample button again
                STATE_WAIT: begin
                    if (clk_count == MAX_CLK_COUNT) begin
                        if (in == 1'b1) begin
                            state <= STATE_PRESSED;
                        end else begin
                            state <= STATE_HIGH;
                        end
                    end
                end
                
                // If button is still pressed
                STATE_PRESSED: begin
                    out <= 1'b1;
                    state <= STATE_HIGH;
                end
                
                    
                // Default case: return to idle state
                default: state <= STATE_HIGH;
            endcase
        end
    end
    
    // Run counter if in wait state
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            clk_count <= 0;
        end else begin
            if (state == STATE_WAIT) begin
                clk_count <= clk_count + 1;
            end else begin
                clk_count <= 0;
            end
        end
    end
    
endmodule
