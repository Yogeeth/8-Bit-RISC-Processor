`timescale 1ns / 1ps

module tb();

   
    reg clk;
    reg rst;
    reg ack_btn; 
    
    // output 
    wire halt;
    wire flag_g;
    wire flag_l;
    wire flag_z;
    wire [7:0] out_port;

    // instantiate the processor
    datapath uut (
        .clk(clk),
        .rst(rst),
        .ack_btn(ack_btn), 
        .halt(halt),
        .flag_g(flag_g),
        .flag_l(flag_l),
        .flag_z(flag_z),
        .out_port(out_port)
    );

    always begin
        #5 clk = ~clk; 
    end

    // test sequence
    initial begin
        clk = 0;
        rst = 1;
        ack_btn = 0; 

        
        $display("Time(ns) | Reset | Ack_Btn | PC   | Opcode | OUT_PORT | Halt?");
        $display("-------------------------------------------------------------");

        // apply reset 
        #20;
        rst = 0;

        // wait
        wait(out_port == 8'h08);
        $display("--> [Time: %0t] Output", $time);
        #50;
        $display("--> [Time: %0t] Pressing Acknowledge Button", $time);
        ack_btn = 1; 
        #10; 
        ack_btn = 0; 

        // wait
        wait(out_port == 8'h02);
        $display("--> [Time: %0t] Output", $time);
        #50; 
        $display("--> [Time: %0t] Pressing Acknowledge Button", $time);
        ack_btn = 1;        
        #10; 
        ack_btn = 0; 

        // wait
        wait(out_port == 8'h18);
        $display("[Time: %0t] Output", $time);
        #50; 
        $display("[Time: %0t] Pressing Acknowledge Button", $time);
        ack_btn = 1;        
        #10; 
        ack_btn = 0; 

        // halt
        wait(halt == 1'b1);

        #40; 
        $display("-------------------------------------------------------------");
        $display("      Simulation Finished: HALT Instruction Reached");
        
        
        $finish; 
    end

    // custom mon
    always @(uut.pc_out or out_port or halt or ack_btn) begin
        if (!rst) begin
            $display("%7d  |   %b   |    %b    |  %h  |   %h    |    %h     |  %b", 
                     $time, rst, ack_btn, uut.pc_out, uut.opcode, out_port, halt);
        end
    end

endmodule