// One possible way to debounce a button press (using a Moore state machine)
//
// Parameters:
//      MAX_CLK_COUNT   - How long to wait (cycles) before sampling button again
// 
// Inputs:
//      clk             - Input clock
//      rst_btn         - Pushbutton (RESET)
//      inc_btn         - Pushbutton (INCREMENT)
// 
// Outputs:
//      led[3:0]        - LEDs (count from 0x0 to 0xf)
// 
// One press of the increment button should correspond to one and only one
// increment of the counter. Use a state machine to identify the edge on the
// button line, wait 40 ms, and sample again to see if the button is still
// pressed.
//
// Date: November 11, 2021
// Author: Shawn Hymel
// License: 0BSD

// Use a state machine to debounce the button, which increments a counter
module debounced_counter #(

    // Parameters
    parameter MAX_CLK_COUNT     = 20'd480000 - 1
) (

    // Inputs
    input               clk,
    input               rst_btn,
    input               inc_btn,
    
    // Outputs
    output  reg [3:0]   led
);

    // States
    localparam STATE_HIGH       = 2'd0;
    localparam STATE_LOW        = 2'd1;    
    localparam STATE_WAIT       = 2'd2;
    localparam STATE_PRESSED    = 2'd3;
    
    // Internal signals
    wire rst;
    wire inc;
    
    // Internal storage elements
    reg [1:0]   state;
    reg [19:0]  clk_count;
    
    // Invert active-low buttons
    assign rst = ~rst_btn;
    assign inc = ~inc_btn;
    
    // State transition logic
    always @ (posedge clk or posedge rst) begin
    
        // On reset, return to idle state and restart counters
        if (rst == 1'b1) begin
            state <= STATE_HIGH;
            led <= 4'd0;
            
        // Define the state transitions
        end else begin
            case (state)
            
                // Wait for increment signal to go from high to low
                STATE_HIGH: begin
                    if (inc == 1'b0) begin
                        state <= STATE_LOW;
                    end
                end
            
                // Wait for increment signal to go from low to high
                STATE_LOW: begin
                    if (inc == 1'b1) begin
                        state <= STATE_WAIT;
                    end
                end
                
                // Wait for count to be done and sample button again
                STATE_WAIT: begin
                    if (clk_count == MAX_CLK_COUNT) begin
                        if (inc == 1'b1) begin
                            state <= STATE_PRESSED;
                        end else begin
                            state <= STATE_HIGH;
                        end
                    end
                end
                
                // If button is still pressed, increment LED counter
                STATE_PRESSED: begin
                    led <= led + 1;
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