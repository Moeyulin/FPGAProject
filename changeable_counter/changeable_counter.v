module changeable_counter(
	clk,
	rst,
	hold,
	seg_led_1,
	seg_led_2,
	set_0,
	set_1
);
 
	input clk,rst,set_0,set_1;
	input	hold;
 
	output reg [8:0] seg_led_1,seg_led_2;
 
	reg clk_divided;
	reg hold_flag;
	reg back_to_zero_flag = 0;
	reg [6:0]  seg [9:0];  
	reg [23:0]	cnt;
	reg [3:0]	cnt_ge;
	reg [3:0]	cnt_shi;
 
	parameter	PERIOD=1500000;	//定义分频份数 1/2秒

	//定义数字显示译码
	initial 
	begin
		seg[0] = 7'h3f;	   //0
		seg[1] = 7'h06;	   //1
		seg[2] = 7'h5b;	   //2
		seg[3] = 7'h4f;	   //3
		seg[4] = 7'h66;	   //4
		seg[5] = 7'h6d;	   //5
		seg[6] = 7'h7d;	   //6
		seg[7] = 7'h07;	   //7
		seg[8] = 7'h7f;	   //8
		seg[9] = 7'h6f;	   //9
		
	end
 
	//分频器
	always @ (posedge clk) begin
		if (!rst == 1) begin
			cnt <= 0;
			clk_divided <= 0; 
		end
		else begin
			if (cnt < PERIOD-1)
				cnt <= cnt + 1;
			else begin
				cnt <= 0;
				clk_divided <= ~clk_divided; 
			end
		end
	end
 
	//置零和多功能
	always @ (*) begin
		if (!rst == 1)
			back_to_zero_flag <= 1;
		else if (~set_0 && ~set_1) begin
			if(cnt_shi != 0)
				back_to_zero_flag <= 1;
			else
			back_to_zero_flag <= 0;
		end
		else if (~set_0 && set_1) begin
			if(cnt_shi>=2&&cnt_ge>=4)
				back_to_zero_flag <= 1;
			else
			back_to_zero_flag <= 0;
		end
		else if(set_0 && ~set_1) begin
			if(cnt_shi>=6&&cnt_ge>=0)
				back_to_zero_flag <= 1;
			else
			back_to_zero_flag <= 0;
		end
		else if(set_0 && set_1) begin
			if(cnt_shi>=10)
				back_to_zero_flag <= 1;
			else
			back_to_zero_flag <= 0;
		end
		else
			back_to_zero_flag <= 0;
	end

	//保持功能
	always @ (posedge hold)
		hold_flag <= ~hold_flag;

	//计数
	always @ (posedge clk_divided or posedge back_to_zero_flag) begin
		if (back_to_zero_flag == 1) begin
			cnt_ge <= 0;
			cnt_shi <= 0;
		end
		else if (cnt_ge == 9) begin
			cnt_ge <= 0;
			cnt_shi <= cnt_shi + 1; 
		end
		else if (hold_flag == 1)
			cnt_ge <= cnt_ge;
		else
			cnt_ge <= cnt_ge + 1;
	end
	
	//数字显示译码
	always @ (cnt_ge) begin
		seg_led_2[8:0] <= {2'b00,seg[cnt_ge]};
	end
	always @ (cnt_shi) begin
		seg_led_1[8:0] <= {2'b00,seg[cnt_shi]};
	end
endmodule