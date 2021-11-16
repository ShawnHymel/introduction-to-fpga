// Top-level design for sequencer
// 
// Inputs:
//      clk         - 12 MHz clock
//      rst_btn     - pushbutton (RESET)
//      set_btn     - pushbutton (SET value at next memory address)
//      ptn_0_btn   - pushbutton (PATTERN[0] for sequence)
//      ptn_1_btn   - pushbutton (PATTERN[1] for sequence)
// 
// Outputs:
//      led[1:0]    - LEDs
// 
// Push RESET to set everything to 0. Hold PATTERN[0] and/or PATTERN[1] and 
// press SET to record value in memory. Continue doing this for up to 8 memory
// locations. Sequence will play on LEDs and loop forever.
//
// Date: November 15, 2021
// Author: Shawn Hymel
// License: 0BSD

// Top-level design for the sequencer
module sequencer_top #(

    // Parameters
    parameter   STEP_COUNTS = 6000000 - 1,  // Clock cycles between steps
    parameter   NUM_STEPS = 8               // Number of steps

) (

    // Inputs
    input           clk,
    input           rst_btn,
    input           set_btn,
    input           ptn_0_btn,
    input           ptn_1_btn,
    
    // Outputs
    output  reg [1:0]   led,                // %%% - TODO MAKE NOT REG!!!
    output  [2:0]   unused_led
);
    
    // Internal signals
    wire            rst;
    wire            set;
    wire            set_d;
    wire    [1:0]   ptn;
    wire            div_clk;
    wire    [1:0]   r_data;
    
    // Storage elements
    reg             w_en = 0;
    reg             r_en = 0;
    reg     [2:0]   w_addr;
    reg     [2:0]   r_addr;
    reg     [1:0]   w_data;
    reg     [2:0]   step_counter;
    
    // Turn off unused LEDs
    assign unused_led = 3'b000;
    
    // Invert active-low buttons
    assign rst = ~rst_btn;
    assign set = ~set_btn;
    assign ptn[0] = ~ptn_0_btn;
    assign ptn[1] = ~ptn_1_btn;
    
    // Connect memory output to LEDs
    //assign led = r_data;
    
    // Clock divider
    clock_divider #(
        .COUNT_WIDTH(24), 
        .MAX_COUNT(STEP_COUNTS)
    ) div (
        .clk(clk),
        .rst(rst),
        .out(div_clk)
    );
    
    // Button debouncer for set buttons
    debouncer #(
        .COUNT_WIDTH(20),
        .MAX_CLK_COUNT(480000 - 1)
    ) set_debouncer (
        .clk(clk),
        .rst(rst),
        .in(set),
        .out(set_d)
    );
    
    // Memory unit
    memory #(   
        .MEM_WIDTH(2), 
        .MEM_DEPTH(NUM_STEPS), 
        .INIT_FILE("mem_init.txt")
    ) mem (
        .clk(clk),
        .w_en(w_en),
        .r_en(r_en),
        .w_addr(w_addr),
        .r_addr(r_addr),
        .w_data(w_data),
        .r_data(r_data)
    );
    
    // Read from memory each divided clock cycle
    always @ (posedge div_clk or posedge rst) begin
        if (rst == 1'b1) begin
            step_counter <= 0;
        end else begin
            r_addr <= step_counter;
            step_counter <= step_counter + 1;
            r_en <= 1'b1;
        end
    end
    
    // TEST: Debouncer on counter
    // %%% TODO - Set ptn value to mem addr, increment addr pointer
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            led <= 0;
        end else begin
            if (set_d == 1'b1) begin
                led <= led + 1;
            end
        end
    end
    
endmodule