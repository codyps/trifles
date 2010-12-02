
/* Problem # 13 */
module freq_div #(parameter divisor_width = 8, parameter duty_cycle_width = 8)
	(output reg out_clk,
	input [divisor_width-1:0] divisor,
	input [duty_cycle_width-1:0] duty_cycle
	input reset_l, in_clk);
	
	reg [divisor_width-1:0] div_track;
	reg [duty_cycle_width-1:0] duty_track;
	reg [log2(duty_cycle_width)-1:0] duty_div;
	
	always @(div_track) begin
		if (div_track == 0)
			duty_track = 0;
	
	always @(posedge in_clk) begin
		
		if (div_track == divisor) begin
			out_clk <= 1;
			div_track <= 0;
		end else begin
			div_track  <= div_track  + 1;
		end
		
		if (duty_track == duty_cycle) begin
			out_clk <= ~out_clk;
			duty_track <= 0;
		end else begin
			duty_track <= duty_track + 1;
		end
	end
	
	always @(not reset_l) begin
		out_clk <= 0;
		div_track <= 0;
		duty_track <= 0;
	end
	
endmodule

