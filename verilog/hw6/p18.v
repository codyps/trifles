
/* Problem # 18 */
module Control_Unit(output reg done, Ld_AR_BR, Div_AR_x2_CR, Mul_BR_x2_CR, Clr_CR
	input reset_b, start, AR_gt_0, AR_lt_0, clk);

	always @(posedge clk) begin
		if (start) begin
			Ld_AR_BR = 1;
			Mul_BR_x2_CR = 0;
			Div_AR_x2_CR = 0;
			Clr_CR = 0;
		end else begin
			if (AR_gt_0) begin
				Ld_AR_BR = 0;
				Mul_BR_x2_CR = 1;
				Div_AR_x2_CR = 0;
				Clr_CR = 0;
			end else if (AR_lt_0) begin
				Ld_AR_BR = 0;
				Mul_BR_x2_CR = 0;
				Div_AR_x2_CR = 1;
				Clr_CR = 0;
			end else begin
				Ld_AR_BR = 0;
				Mul_BR_x2_CR = 0;
				Div_AR_x2_CR = 0;
				Clr_CR = 1;
			end
		end
	end
	
endmodule

module Datapath_Unit(output signed reg[15:0]CR, output reg AR_gt_0, AR_lt_0,
	input [15:0] Data_AR, Data_BR,
	input Ld_AR_BR, Div_AR_x2_CR, Mul_BR_x2_CR, Clr_CR, clk);

	signed reg [15:0] AR;
	signed reg [15:0] BR;
	
	always @(AR) begin
		AR_lt_0 = (AR < 0);
		AR_gt_0 = (AR > 0);
	end
	
	always @(negedge clk) begin
		if (Ld_AR_BR) begin
			AR = Data_AR;
			BR = Data_BR;
		end else if (Div_AR_x2_CR) begin
			CR = AR / 2;
		end else if (Mul_BR_x2_CR) begin
			CR = BR * 2;
		end else if (Clr_CR) begin
			CR = 0;
		end
	end
	
endmodule
	
