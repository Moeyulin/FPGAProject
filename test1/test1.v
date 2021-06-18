module test1(
input clk,rst,recount,
output led
);

reg breath_flag;
reg [24:0]	breath_cnt1;
reg [24:0]	breath_cnt2;

parameter	BREATH=4800;

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
	
assign led = (breath_cnt1 < breath_cnt2) ? 1'b0:1'b1;

endmodule
