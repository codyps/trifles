/* Problem # 18 */
module Control_Unit(output reg done, Ld_AR_BR, Div_AR_x2_CR, Mul_BR_x2_CR, Clr_CR,
	input reset_b, start, AR_gt_0, AR_lt_0, clk);

	always @(posedge clk) begin
		if (start) begin
			Ld_AR_BR = 1;
			Mul_BR_x2_CR = 0;
			Div_AR_x2_CR = 0;
			Clr_CR = 0;
			done = 0;
		end else begin
			if (AR_gt_0) begin
				Ld_AR_BR = 0;
				Mul_BR_x2_CR = 1;
				Div_AR_x2_CR = 0;
				Clr_CR = 0;
				done = 0;
			end else if (AR_lt_0) begin
				Ld_AR_BR = 0;
				Mul_BR_x2_CR = 0;
				Div_AR_x2_CR = 1;
				Clr_CR = 0;
				done = 0;
			end else begin
				Ld_AR_BR = 0;
				Mul_BR_x2_CR = 0;
				Div_AR_x2_CR = 0;
				Clr_CR = 1;
				done = 1;
			end
		end
	end

	always @(reset_b)
		if (reset_b == 0) begin
			Ld_AR_BR = 0;
			Mul_BR_x2_CR = 0;
			Div_AR_x2_CR = 0;
			Clr_CR = 0;
			done = 0;
		end
	
endmodule

module Datapath_Unit(output reg signed[15:0] CR, output reg AR_gt_0, AR_lt_0,
	input [15:0] Data_AR, Data_BR,
	input Ld_AR_BR, Div_AR_x2_CR, Mul_BR_x2_CR, Clr_CR, clk);

	reg signed [15:0] AR;
	reg signed [15:0] BR;
	
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

module tb();
	/* Outputs */
	wire [15:0] CR;
	wire done;

	/* Interconnects */
	wire AR_gt_0, AR_lt_0;
	wire Ld_AR_BR, Div_AR_x2_CR, Mul_BR_x2_CR, Clr_CR;

	/* Inputs */
	reg clk;
	reg [15:0] Data_BR, Data_AR;

	reg reset_b;
	reg start;

	Datapath_Unit ddev (CR, AR_gt_0, AR_lt_0, Data_AR, Data_BR, 
		Ld_AR_BR, Div_AR_x2_CR, Mul_BR_x2_CR, Clr_CR, clk);

	Control_Unit cdev(done, Ld_AR_BR, Div_AR_x2_CR, Mul_BR_x2_CR, Clr_CR,
		reset_b, start, AR_gt_0, AR_lt_0, clk);

	reg [35:0] i;
	initial begin
		$dumpfile("p18.vcd");
		$dumpvars(0,tb);

		clk = 0;
		reset_b = 0;
		#2 reset_b = 1;

		for(i = 0; i < 2**32-1; i = i + 3) begin
			Data_BR = i[15:0];
			Data_AR = i[31:16];
			
			start = 1;
			#10 clk = 1;
			#10 clk = 0;

			while(~done) begin
				#10 clk = 1;
				#10 clk = 0;
			end
		end
	end
endmodule
