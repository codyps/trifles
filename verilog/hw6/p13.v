/* Problem # 13 */
module freq_div 
	#(parameter divisor_width = 8,
	parameter duty_cycle_width = divisor_width)

	(output reg out_clk,
	input [divisor_width-1:0] divisor,
	input [duty_cycle_width-1:0] duty_cycle,
	input reset_l, in_clk);
	
	reg [divisor_width-1:0] div_track;

	always @(posedge in_clk) begin
		div_track = div_track + 1;
	end

	reg ct;
	always @(div_track) begin
		if (out_clk) begin
			if (duty_cycle[duty_cycle_width-1])
				ct = divisor + duty_cycle + 1;
			else
				ct = divisor - duty_cycle + 1;
		end else begin
			if (duty_cycle[duty_cycle_width-1])
				ct = divisor - duty_cycle + 1;
			else
				ct = divisor + duty_cycle + 1;
		end

		if ( (div_track == ct) || (div_track > ct) ) begin
			out_clk = ~out_clk;
			div_track = 0;
		end
	end

	always @(reset_l) begin
		if (reset_l == 0) begin
			out_clk <= 0;
			div_track <= 0;
		end
	end
	
endmodule

module tb();
	wire out_clk;
	reg [7:0] divisor, duty_cycle;
	reg reset_l, in_clk;

	freq_div dev(out_clk, divisor, duty_cycle, reset_l, in_clk);

	initial begin
		in_clk = 0;
		forever #4 in_clk = ~in_clk;
	end
	
	integer i;
	initial begin 
		$dumpfile("p13.vcd");
		$dumpvars(0,tb);
		fork
			#0 reset_l = 0;
			#0 divisor = 1;
			#0 duty_cycle = 1;
			#2 reset_l = 1;

			#100 divisor = 10;
			
			#300 duty_cycle = 3; 

			#500 $finish;
		join
	end
endmodule
