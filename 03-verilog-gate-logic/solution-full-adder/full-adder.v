// Full adder with button inputs
module full_adder (
    input   pmod_1,
    input   pmod_2,
    input   pmod_3,
    output  led_1,
    output  led_2
);

    // Wire (net) declarations (internal to module)
    wire a;
    wire b;
    wire c_in;
    wire a_xor_b;
    
    // A, B, and C_IN are inverted button logic
    assign a = ~pmod_1;
    assign b = ~pmod_2;
    assign c_in = ~pmod_3;
    
    // Create intermediate wire (net)
    assign a_xor_b = a ^ b;

    // Create output logic
    assign led_1 = a_xor_b ^ c_in;
    assign led_2 = (a_xor_b & c_in) | (a & b);
    
endmodule