module control_unit (
    input wire clk,
    input wire rst,
    input wire [3:0] opcode,
    input wire flag_g,
    input wire flag_l,
    input wire flag_z,
    input wire ack_btn, 
    
    output reg [1:0] alu_op,
    output reg flag_write,
    output reg halt,
    output reg imem_read,
    output reg ir_write,
    output reg mem_read,
    output reg mem_write,
    output reg mul_en,
    output reg pc_write,
    output reg reg_write,
    output reg out_write, 
    output reg [1:0] wb_sel 
);

    parameter FETCH1     = 3'b000;
    parameter FETCH2     = 3'b001;
    parameter DECODE     = 3'b010;
    parameter EXECUTE    = 3'b011;
    parameter WRITE_BACK = 3'b100;
    
    reg [2:0] current_state, next_state;

    // state reg
    always @(posedge clk or posedge rst) begin
        if (rst)
            current_state <= FETCH1;
        else
            current_state <= next_state;
    end

    // hardware instructions decoder 
    // these signals ignore the FSM and stay rock-solid for the entire instruction.
    always @(*) begin
        // default 
        alu_op = 2'b00;
        mul_en = 1'b0;
        wb_sel = 2'b00;

        case (opcode)
            4'b0001: begin alu_op = 2'b00;          wb_sel = 2'b00; end // add
            4'b0010: begin alu_op = 2'b01;          wb_sel = 2'b00; end // sub
            4'b0011: begin mul_en = 1'b1;           wb_sel = 2'b01; end // mul 
            4'b0100: begin alu_op = 2'b01;                          end // cmp
            4'b0101: begin alu_op = 2'b10;          wb_sel = 2'b00; end // mov
            4'b0110: begin                          wb_sel = 2'b10; end // load
            4'b1000: begin alu_op = 2'b10;          wb_sel = 2'b00; end // outreg
            4'b1001: begin                          wb_sel = 2'b10; end // out mem
            default: ; 
        endcase
    end

    // fsm cntrl 
    always @(*) begin
        // fsm defaults
        flag_write = 1'b0;
        halt       = 1'b0;
        imem_read  = 1'b0;
        ir_write   = 1'b0;
        mem_read   = 1'b0;
        mem_write  = 1'b0;
        pc_write   = 1'b0;
        reg_write  = 1'b0;
        out_write  = 1'b0;
        next_state = current_state;

        case (current_state)
            FETCH1: begin
                imem_read = 1'b1;
                next_state = FETCH2;
            end
            
            FETCH2: begin
                ir_write = 1'b1;
                pc_write = 1'b1;
                next_state = DECODE;
            end
            
            DECODE: begin
                next_state = EXECUTE;
            end
            
            EXECUTE: begin
                case (opcode)
                    4'b0100: flag_write = 1'b1; // cmp
                    4'b0110: mem_read = 1'b1;   // load
                    4'b0111: mem_write = 1'b1;  // store
                    4'b1001: mem_read = 1'b1;   // outmem
                    4'b1111: halt = 1'b1;       // halt
                    default: ; 
                endcase
                
                if (opcode == 4'b1111) begin
                    next_state = EXECUTE; 
                end else if (opcode == 4'b0111 || opcode == 4'b0100 || opcode == 4'b0000) begin
                    next_state = FETCH1; 
                end else begin
                    next_state = WRITE_BACK; 
                end
            end
            
            WRITE_BACK: begin
                if (opcode == 4'b1000 || opcode == 4'b1001) begin
                    out_write = 1'b1; 
                end else begin
                    reg_write = 1'b1; 
                end
                
                // batton Wait Logic
                if ((opcode == 4'b1000 || opcode == 4'b1001) && (ack_btn == 1'b0)) begin
                    next_state = WRITE_BACK; // wait
                end else begin
                    next_state = FETCH1;     // next (ack_btn-> on)
                end
            end
        endcase
    end
endmodule