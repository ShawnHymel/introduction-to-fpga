// Count up on button press and stop (Mealy state machine)
// 
// Inputs:
//      clk         - 12 MHz clock
//      rst_btn     - pushbutton (RESET)
//      go_btn      - pushbutton (GO)
// 
// Outputs:
//      led[3:0]    - LEDs (count from 0x0 to 0xf)
//      done_sig    - LED that flashes once when counting is done_sig
// 
// Press GO button to start counting. When max value (0xf) is reached, green
// LED will flash once, and the state machine will return to the Idle state.
//
// Date: November 4, 2021
// Author: Shawn Hymel
// License: 0BSD

// State machine that counts up when button is pressed
module mealy_fsm (

    // Inputs
    input               clk,
    input               rst_btn,
    input               go_btn,
    
    // Outputs
    output  reg [3:0]   led,
    output  reg         done_sig
);

    // States
    localparam  STATE_IDLE      = 1'd0;
    localparam  STATE_COUNTING  = 1'd1;
    
    // Max counts for clock divider and counter
    localparam  MAX_CLK_COUNT   = 24'd1500000;
    localparam  MAX_LED_COUNT   = 4'hF;
    
    // Internal signals
    wire rst;
    wire go;
    
    // Internal storage elements
    reg         div_clk;
    reg         state;
    reg [23:0]  clk_count;
    
    // Invert active-low buttons
    assign rst = ~rst_btn;
    assign go = ~go_btn;
    
    // Clock divider
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            clk_count <= 24'b0;
        end else if (clk_count == MAX_CLK_COUNT) begin
            clk_count <= 24'b0;
            div_clk <= ~div_clk;
        end else begin
            clk_count <= clk_count + 1;
        end
    end
    
    // State transition logic
    always @ (posedge div_clk or posedge rst) begin
    
        // On reset, return to idle state
        if (rst == 1'b1) begin
            state <= STATE_IDLE;
            
        // Define the state transitions
        end else begin
            case (state)
            
                // Wait for go button to be pressed
                STATE_IDLE: begin
                    done_sig <= 1'b0;
                    if (go == 1'b1) begin
                        state <= STATE_COUNTING;
                    end
                end
                
                // Go from counting to done if counting reaches max
                STATE_COUNTING: begin
                    if (led == MAX_LED_COUNT) begin
                        done_sig <= 1'b1;
                        state <= STATE_IDLE;
                    end
                end
                
                // Go to idle if in unknown state
                default: state <= STATE_IDLE;
            endcase
        end
    end
    
    // Handle the LED counter
    always @ (posedge div_clk or posedge rst) begin
        if (rst == 1'b1) begin
            led <= 4'd0;
        end else begin
            if (state == STATE_COUNTING) begin
                led <= led + 1;
            end else begin
                led <= 4'd0;
            end
        end
    end
    
endmodule
            
    
      
       
    