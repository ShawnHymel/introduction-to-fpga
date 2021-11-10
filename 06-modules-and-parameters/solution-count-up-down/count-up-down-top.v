// One possible solution to the count up and down challenge
//
// Inputs:
//      clk         - 12 MHz clock
//      rst_btn     - pushbutton (RESET)
//
// Outputs:
//      led[3:0]    - LEDs (connected to counter outputs)
//
// LEDs continuously count up and down.
//
// Date: November 9, 2021
// Author: Shawn Hymel
// License: 0BSD

// Top-level design that controls the clock divider and counter FSMs
module count_up_down_top (

    // Inputs
    input               clk,
    input               rst_btn,
    
    // Outputs
    output  reg [3:0]   led
);

    // Internal signals
    wire            rst;
    wire            div_clk;
    wire            up_done;
    wire            down_done;
    wire    [3:0]   up_out;
    wire    [3:0]   down_out;
    
    // Storage elements
    reg             init_go;
    reg             counting_up;
    
    // Invert active-low buttons
    assign rst = ~rst_btn;
    
    // Use the reset button to start the endless loop of counters
    always @ (posedge div_clk or posedge rst) begin
        if (rst == 1'b1) begin
            init_go <= 1'b1;
        end else begin
            init_go <= 1'b0;
        end
    end
    
    // Remember if we're counting up or down
    always @ (posedge div_clk or posedge rst) begin
        if (rst == 1'b1) begin
            counting_up <= 1'b1;
        end else begin
            if (up_done == 1'b1) begin
                counting_up <= 1'b0;
            end else if (down_done == 1'b1) begin
                counting_up <= 1'b1;
            end
        end
    end
    
    // Multiplexer to switch which counter is controlling the LEDs
    always @ ( * ) begin
        if (counting_up == 1'b1) begin
            led = up_out;
        end else begin
            led = down_out;
        end
    end
    
    // Clock divider
    clock_divider #(.COUNT_WIDTH(24), .MAX_COUNT(1500000 - 1)) div (
        .clk(clk),
        .rst(rst),
        .out(div_clk)
    );
    
    // Counter (up)
    counter_fsm #(.COUNT_UP(1), .MAX_COUNT(4'hF)) up_counter (
        .clk(div_clk),
        .rst(rst),
        .go(down_done | init_go),
        .out(up_out),
        .done(up_done)
    );
    
    // Counter (down)
    counter_fsm #(.COUNT_UP(0), .MAX_COUNT(4'hF)) down_counter (
        .clk(div_clk),
        .rst(rst),
        .go(up_done),
        .out(down_out),
        .done(down_done)
    );
    
endmodule