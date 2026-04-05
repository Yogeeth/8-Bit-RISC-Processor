module instr_decoder (
    input wire [15:0] instr,
    output wire [3:0] opcode,
    output wire [2:0] rd,
    output wire [2:0] rs1,
    output wire [2:0] rs2,
    output wire [2:0] reg_m,
    output wire [8:0] mem_addr
);

    // [15:12]opcode | [11:9]rd | [8:6]rs1 | [5:3]rs2 | [2:0]unused
    // [15:12] opcode | [11:9] reg | [8:0] memory address
    
    assign opcode = instr[15:12];

    // R-type fields
    assign rd  = instr[11:9];
    assign rs1 = instr[8:6];
    assign rs2 = instr[5:3];

    // M-type fields 
    assign reg_m    = instr[11:9];
    assign mem_addr = instr[8:0];

endmodule