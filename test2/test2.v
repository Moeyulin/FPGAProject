module test2 (A, B, Cin, Sum, Cout);
input [3:0] A, B;
input Cin; 
output [3:0] Sum;
output Cout;
wire Cout;
wire [4:0] temp;
wire [4:0] Sum;
assign temp[0] = Cin;
_1bitAdder u0 (A[0], B[0], temp[0], Sum[0], temp[1]);
_1bitAdder u1 (A[1], B[1], temp[1], Sum[1], temp[2]);
_1bitAdder u2 (A[2], B[2], temp[2], Sum[2], temp[3]);
_1bitAdder u3 (A[3], B[3], temp[3], Sum[3], temp[4]);
assign Cout = temp[4];
endmodule

module _1bitAdder (A, B, Ci, Sum, Co);  //此模块正确
input A, B, Ci;
output Sum, Co;
assign Sum = A^B^Ci;
assign Co = (A&B) | (B&Ci) | (A&Ci);
endmodule
