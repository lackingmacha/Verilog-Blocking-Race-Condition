`timescale 1ns/1ps

module tb_race();
    reg clk;
    reg a;
    wire q1_blocking, q2_blocking;
    wire q1_nonblocking, q2_nonblocking;

    // Instantiate the blocking version
    blocking_race uut_blocking (
        .clk(clk),
        .a(a),
        .q1(q1_blocking),
        .q2(q2_blocking)
    );

    // Instantiate the non-blocking version
    non_blocking_correct uut_nonblocking (
        .clk(clk),
        .a(a),
        .q1(q1_nonblocking),
        .q2(q2_nonblocking)
    );

    // Clock generation (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Stimulus
    initial begin
        a = 0;
        #12; // Wait a bit to not align exactly with the first edge
        
        // Apply a sequence of data
        @(posedge clk); #1; a = 1;
        @(posedge clk); #1; a = 0;
        @(posedge clk); #1; a = 1;
        @(posedge clk); #1; a = 1;
        @(posedge clk); #1; a = 0;
        
        #20;
        $finish;
    end
endmodule
