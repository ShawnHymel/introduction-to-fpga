// Count up on button signal and stop.
//
// Parameters:
//      MAX_COUNT   - Maximum number to count to
// 
// Inputs:
//      clk         - Clock input to module
//      rst         - Reset signal to clear state machine and counter
//      go          - Go signal to start state machine
//      up          - 1'b1 to count up, 1'b0 to count down
// 
// Outputs:
//      out[3:0]    - Bus that counts from 0x0 to 0xf or 0xf to 0x0
//      done        - Signal that pulses on 1 clock cycle when FSM is complete
// 
// Send rising edge on go input to start counter. If up is 1, counter will
// count up. Otherwise, it will count down. 
//
// Date: November 9, 2021
// Author: Shawn Hymel
// License: 0BSD

// State machine that counts when go signal is sent
module counter_fsm #(

    // Parameters
    parameter   COUNT_UP = 1'b1,    // 1'b1 to count up
    parameter   MAX_COUNT = 4'hF    // Maximum number to count to
) (

    // Inputs
    input               clk,
    input               rst,
    input               go,
    
    // Outputs
    output  reg [3:0]   out,
    output  reg         done
);

    // States
    localparam  STATE_IDLE      = 2'd0;
    localparam  STATE_COUNTING  = 2'd1;
    localparam  STATE_DONE      = 2'd2;
    
    // Internal storage elements
    reg [1:0]   state;
    
    // State transition logic
    always @ (posedge clk or posedge rst) begin
    
        // On reset, return to idle state
        if (rst == 1'b1) begin
            state <= STATE_IDLE;
            
        // Define the state transitions
        end else begin
            case (state)
            
                // Wait for go signal
                STATE_IDLE: begin
                    if (go == 1'b1) begin
                        state <= STATE_COUNTING;
                    end
                end
                
                // Go from counting to done if counting reaches max
                STATE_COUNTING: begin
                    if (COUNT_UP == 1'b1 && out == MAX_COUNT) begin
                        state <= STATE_DONE;
                    end else if (COUNT_UP == 1'b0 && out == 0) begin
                        state <= STATE_DONE;
                    end
                end
                
                // Spend one clock cycle in done state
                STATE_DONE: state <= STATE_IDLE;
                
                // Go to idle if in unknown state
                default: state <= STATE_IDLE;
            endcase
        end
    end
    
    // Handle the counter output
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            out <= 4'd0;
        end else begin
            case (state)
            
                // Start counter at the right value
                STATE_IDLE: begin
                    if (COUNT_UP == 1'b1) begin
                        out <= 4'd0;
                    end else begin
                        out <= MAX_COUNT;
                    end
                end
                
                // Count up or down
                STATE_COUNTING: begin
                    if (COUNT_UP == 1'b1) begin
                        out <= out + 1;
                    end else begin
                        out <= out - 1;
                    end
                end
                
                // For anything else, leave counter alone
                STATE_DONE: begin
                    out <= 4'd3;
                end
                
                default: out <= 4'd2;
            endcase
        end
    end
    
    // Handle done signal output
    always @ ( * ) begin
        if (state == STATE_DONE) begin
            done = 1'b1;
        end else begin
            done = 1'b0;
        end
    end
    
endmodule
