module new_project(A,B,Y1,Y2);
input A,B;
output Y1,Y2;
assign Y1=A&B;
or (Y2,A,B);
endmodule
