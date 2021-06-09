module test4 (
	input clk,
	input rst,
	output reg clk_out
	);
	
parameter N = 12_000_000;
reg [23:0] cnt;

always @ (posedge clk,posedge rst) begin
	if (rst == 1'b1)
		cnt <= 24'b0;
	else if (cnt == N - 1)
		cnt <= cnt + 1;
end
always @ (posedge clk, posedge rst) begin
	if (rst == 1'b1)
		clk_out <= 1'b0;
	else if (cnt == N - 1)
		clk_out <= ~clk_out;
	else
		clk_out <= clk_out;
end
endmodule
