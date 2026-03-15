module blocking_race (input wire clk, input wire a, output reg q1, output reg q2);
// This creates a race condition because both blocks trigger on the same edge
always @(posedge clk) 
q1 = a; 

always @(posedge clk) 
q2 = q1; 
endmodule
