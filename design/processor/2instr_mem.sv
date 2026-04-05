module instr_mem (
    input wire clk,
    input wire imem_read,
    input wire [7:0] addr,
    output reg [15:0] instr
);

    // memory array: 256 words, each 16 bits wide
    reg [15:0] rom_array [0:255];

    
    initial begin
        
        $readmemh("program1.mem", rom_array); 
    end

    always @(posedge clk) begin
        if (imem_read) begin
            instr <= rom_array[addr];
        end
    end

endmodule