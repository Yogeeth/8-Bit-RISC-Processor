module multiplier (
    input wire [7:0] a,
    input wire [7:0] b,
    output wire [7:0] result
);

    
    assign result = a * b;

endmodule