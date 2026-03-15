module non_blocking_correct (input wire clk, input wire a, output reg q1, output reg q2);
always @(posedge clk) 
q1 <= a; 

always @(posedge clk) 
q2 <= q1; 
endmodule
