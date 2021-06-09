module decode38 (sw,led);
 
	input [2:0] sw;							//开关输入信号，利用了其中3个开关作为3-8译码器的输入
	output [7:0] led;						//输出信号控制特定LED
 
        reg [7:0] led;                                                  //定义led为reg型变量，在always过程块中只能对reg型变量赋值
 
        //always过程块，括号中sw为敏感变量，当sw变化一次执行一次always中所有语句，否则保持不变
	always @ (sw)
	begin
		case(sw)                                                   //case语句，一定要跟default语句
			3'b000:	led=8'b0111_1111;                         //条件跳转，其中“_”下划线只是为了阅读方便，无实际意义  
			3'b001:	led=8'b1011_1111;                         //位宽'进制+数值是Verilog里常数的表达方法，进制可以是b、o、d、h（二、八、十、十六进制）
			3'b010:	led=8'b1101_1111;
			3'b011:	led=8'b1110_1111;
			3'b100:	led=8'b1111_0111;
			3'b101:	led=8'b1111_1011;
			3'b110:  led=8'b1111_1101;
			3'b111:	led=8'b1111_1110;
			default: ;
		endcase
	end
 
endmodule