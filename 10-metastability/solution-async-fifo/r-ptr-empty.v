// Implementation of Clifford Cummings's asynchronous FIFO design from the paper
// at http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf
//
// Module to incrememnt the read address and determine if the FIFO is empty.
//
// Notes:
//  - w_* means something is in the "write clock domain"
//  - r_* means something is in the "read clock domain"
//
// Date: December 11, 2021
// Author: Shawn Hymel
// License: 0BSD

// Increment read address and check if FIFO is empty
module r_ptr_empty #(

    // Parameters
    parameter   ADDR_SIZE = 4                   // Number of bits for address
) (
    
    // Inputs
    input       [ADDR_SIZE:0]   r_syn_w_gray,   // Synced write Gray pointer
    input                       r_inc,          // 1 to increment address
    input                       r_clk,          // Read domain clock
    input                       r_rst,          // Read domain reset

    // Outputs
    output      [ADDR_SIZE-1:0] r_addr,         // Mem address to read from
    output  reg [ADDR_SIZE:0]   r_gray,         // Gray address with +1 MSb
    output  reg                 r_empty         // 1 if FIFO is empty
);
    
    // Internal signals
    wire    [ADDR_SIZE:0]   r_gray_next;    // Gray code version of address
    wire    [ADDR_SIZE:0]   r_bin_next;     // Binary version of address
    wire                    r_empty_val;    // FIFO is empty
    
    // Internal storage elements
    reg     [ADDR_SIZE:0]   r_bin;          // Registered binary address
    
    // Drop extra most significant bit (MSb) for addressing into memory
    assign r_addr = r_bin[ADDR_SIZE-1:0];
    
    // Be ready with next (incremented) address (if inc set and not empty)
    assign r_bin_next = r_bin + (r_inc & ~r_empty);
    
    // Convert next binary address to Gray code value
    assign r_gray_next = (r_bin_next >> 1) ^ r_bin_next;
    
    // If the synced write Gray code is equal to the current read Gray code,
    // then the pointers have caught up to each other and the FIFO is empty
    assign r_empty_val = (r_gray_next == r_syn_w_gray);
    
    // Register the binary and Gray code pointers in the read clock domain
    always @ (posedge r_clk or posedge r_rst) begin
        if (r_rst == 1'b1) begin
            r_bin <= 0;
            r_gray <= 0;
        end else begin
            r_bin <= r_bin_next;
            r_gray <= r_gray_next;
        end
    end
    
    // Register the empty flag
    always @ (posedge r_clk or posedge r_rst) begin
        if (r_rst == 1'b1) begin
            r_empty <= 1'b1;
        end else begin
            r_empty <= r_empty_val;
        end
    end
    
endmodule