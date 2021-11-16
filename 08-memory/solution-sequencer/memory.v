// Simple block RAM example
// 
// Inputs:
//      clk             - Input clock
//      w_en            - Write enable
//      r_en            - Read enable
//      w_addr[x:0]     - Write address
//      r_addr[x:0]     - Read address
//      w_data[x:0]     - Data to be written
// 
// Outputs:
//      r_data[x:0]     - Data to be read
//
// Date: November 15, 2021
// Author: Shawn Hymel
// License: 0BSD

// Inferred block RAM
module memory #(

    // Parameters
    parameter   MEM_WIDTH = 16,
    parameter   MEM_DEPTH = 256,
    parameter   INIT_FILE = ""
) (

    // Inputs
    input               clk,
    input               w_en,
    input               r_en,
    input       [ADDR_WIDTH - 1:0]   w_addr,
    input       [ADDR_WIDTH - 1:0]   r_addr,
    input       [MEM_WIDTH - 1:0]  w_data,
    
    // Outputs
    output  reg [MEM_WIDTH - 1:0]  r_data
);

    // Calculate the number of bits required for the address
    localparam  ADDR_WIDTH = $clog2(MEM_DEPTH);

    // Declare memory
    reg [MEM_WIDTH - 1:0]  mem [0:MEM_DEPTH - 1];
    
    // Interact with the memory block
    always @ (posedge clk) begin
        
        // Write to memory
        if (w_en) begin
            mem[w_addr] <= w_data;
        end
        
        // Read from memory
        if (r_en) begin
            r_data <= mem[r_addr];
        end
    end
    
    // Initialization (if available)
    initial if (INIT_FILE) begin
        $readmemh(INIT_FILE, mem);
    end
    
endmodule