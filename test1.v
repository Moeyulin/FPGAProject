module test1(output reg Q0,Q1, input A,B);
	always @ (posedge A)
		if (Q1) begin
			Q0 <= 1'b0; end
		else begin
			Q0 <= ~Q0; end
	always @ (posedge B)
		Q1 <= Q0&(~Q1);
endmodule
