module test(
	clk,
	rst,
	start,
	seg_led_1,
	seg_led_2,
	set_0,
	set_1,
	set_2,
	recount,
	led
);
 
	input clk,rst,set_0,set_1,set_2,recount;
	input	start;
 
	output reg [8:0] seg_led_1,seg_led_2;
	output reg led;
 
	reg clk_divided;
	reg start_flag;
	reg recount_flag;
	reg breath_flag;
	reg zero_flag = 0;
	reg [6:0]  seg [9:0];  
	reg [23:0]	cnt;
	reg [3:0]	cnt_ge;
	reg [3:0]	cnt_shi;
	reg [3:0]	moSet_ge;
	reg [3:0]	moSet_shi;
	reg [24:0]	breath_cnt1;
	reg [24:0]	breath_cnt2;
 
	parameter	PERIOD1=1500000;	//定义分频份数 1/2秒
	parameter   PERIOD2=6000000;	//1s
	parameter	BREATH=2400;
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
		//seg[10] = 7'hf7;
	end
 
	//分频器
	always @ (posedge clk) begin
		if (!rst == 1) begin
			cnt <= 0;
			clk_divided <= 0; 
		end
		else begin
			if (set_2) begin//变频
				if (cnt < PERIOD1-1)
					cnt <= cnt + 1;
				else begin
					cnt <= 0;
					clk_divided <= ~clk_divided; 
				end
			end
			else if (cnt < PERIOD2-1)
					cnt <= cnt + 1;
			else begin
				cnt <= 0;
				clk_divided <= ~clk_divided; 
			end
		end
	end
 
	//呼吸灯计数器
	always @ (posedge clk or negedge rst) begin 
		if(!rst) begin
			breath_cnt1<=13'd0;
		end 
		else begin
			if(breath_cnt1 >= BREATH - 1) 
				breath_cnt1 <= 1'b0;
			else 
				breath_cnt1 <= breath_cnt1 + 1'b1; 
		end
	end
 
	always @ (posedge clk or negedge rst) begin
		if (!rst) begin
			breath_cnt2 <= 13'd0;
			breath_flag <= 1'b0;
		end
		else begin
			if (breath_cnt1 == BREATH - 1) begin
				if (!breath_flag) begin
					if (breath_cnt2 >= BREATH -1)
						breath_flag <= 1'b1;
					else breath_cnt2 <= breath_cnt2 + 1;
				end
				else begin
					if (breath_cnt2 <= 0)
						breath_flag <= 1'b0;
					else breath_cnt2 <= breath_cnt2 - 1;
				end
			end
			else breath_cnt2 <= breath_cnt2;
		end
	end
	
	//摸设置
	always @ (*) begin
		if (~set_0 && ~set_1) begin
			moSet_shi <= 1;
			moSet_ge <= 0;
		end
		else if (~set_0 && set_1) begin
			moSet_shi <= 2;
			moSet_ge <= 4;
		end
		else if(set_0 && ~set_1) begin
			moSet_shi <= 6;
			moSet_ge <= 0;
		end
		else if(set_0 && set_1) begin
			moSet_shi <= 10;
			moSet_ge <= 0;
		end
	end
 
	//反向
	always @ (*) begin
		if (recount)
			recount_flag <= 1;
		else 
			recount_flag <= 0;
	end
	
	//置零
	always @ (*) begin
		if (!rst == 1)
			zero_flag <= 1;
		else if (recount_flag == 1) begin
			if (cnt_shi == 0 && cnt_ge == 0)
				zero_flag <= 1;
			else 
				zero_flag <= 0;
		end
		else begin
			if (cnt_shi >= moSet_shi && cnt_ge >= moSet_ge) 
				zero_flag <= 1;
			else 
				zero_flag <= 0;
		end
	end

	//保持功能
	always @ (posedge start) begin
		start_flag <= ~start_flag;
	end
		
	//计数
	always @ (posedge clk_divided or posedge zero_flag) begin
		if (zero_flag == 1) begin
			if (recount_flag == 1) begin
				cnt_ge <= (moSet_ge);
				cnt_shi <= (moSet_shi);
			end
			else begin
				cnt_ge <= 0;
				cnt_shi <= 0;
			end
		end
		//反向计数
		else if (recount_flag == 1) begin
			if (cnt_ge == 0) begin
				cnt_ge <= 9;
				cnt_shi <= cnt_shi - 1; 
			end
			else if (start_flag == 1) begin
				cnt_ge <= cnt_ge;
				led <= (breath_cnt1 < breath_cnt2) ? 1'b0:1'b1;
			end
			else
				cnt_ge <= cnt_ge - 1;
				led <= 1;
		end
		//正向计数
		else begin
			if (cnt_ge == 9) begin
				cnt_ge <= 0;
				cnt_shi <= cnt_shi + 1; 
			end
			else if (start_flag == 1) begin
				cnt_ge <= cnt_ge;
				led <= (breath_cnt1 < breath_cnt2) ? 1'b0:1'b1;
			end
			else
				cnt_ge <= cnt_ge + 1;
				led <= 1;
		end
	end


	
	//数字显示译码
	always @ (cnt_ge) begin
		seg_led_2[8:0] <= {2'b00,seg[cnt_ge]};
	end
	always @ (cnt_shi) begin
		seg_led_1[8:0] <= {2'b00,seg[cnt_shi]};
	end
endmodule