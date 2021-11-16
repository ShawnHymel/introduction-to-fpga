// Simple block RAM example
// 
// Inputs:
//      clk             - Input clock
//      w_en            - Write enable
//      r_en            - Read enable
//      w_addr[3:0]     - Write address
//      r_addr[3:0]     - Read address
//      w_data[7:0]     - Data to be written
// 
// Outputs:
//      r_data[7:0]     - Data to be read
//
// Date: November 15, 2021
// Author: Shawn Hymel
// License: 0BSD

// Inferred block RAM
module memory (

    // Inputs
    input               clk,
    input               w_en,
    input               r_en,
    input       [3:0]   w_addr,
    input       [3:0]   r_addr,
    input       [7:0]   w_data,
    
    // Outputs
    output  reg [7:0]   r_data
);

    // Declare memory
    reg [7:0]  mem [0:15];
    
    // Interact with the memory block
    always @ (posedge clk) begin
    
        // Write to memory
        if (w_en == 1'b1) begin
            mem[w_addr] <= w_data;
        end
        
        // Read from memory
        if (r_en == 1'b1) begin
            r_data <= mem[r_addr];
        end
    end
    
endmodule