/* HW4, Problem 24b */

module jerk_ct(output reg [7:0] count, input clk, reset);
	reg [3:0] state; // 0 to 13 needed.
	reg [7:0] icount;
	always @(icount)
		count <= { icount[0], icount[1], icount[2], icount[3],
				icount[4], icount[5], icount[6], icount[7] };

	always @(posedge clk) begin
		if (reset == 1) begin
			state = 13;
		end
		
		case(state)
			0: begin icount <= 8'b00000010; state <= 1; end
			1: begin icount <= 8'b00000001; state <= 2; end
			2: begin icount <= 8'b00000100; state <= 3; end
			3: begin icount <= 8'b00000001; state <= 4; end
			4: begin icount <= 8'b00001000; state <= 5; end
			5: begin icount <= 8'b00000001; state <= 6; end
			6: begin icount <= 8'b00010000; state <= 7; end
			7: begin icount <= 8'b00000001; state <= 8; end
			8: begin icount <= 8'b00100000; state <= 9; end
			9: begin icount <= 8'b00000001; state <= 10;end
			10:begin icount <= 8'b01000000; state <= 11;end
			11:begin icount <= 8'b00000001; state <= 12;end
			12:begin icount <= 8'b10000000; state <= 13;end
			13,14,15:
			   begin icount <= 8'b00000001; state <= 0; end
		endcase
	end
endmodule

module p24_tb();
	reg clk, reset;
	wire [7:0] count;

	jerk_ct device(count, clk, reset);

	initial begin
		clk = 0;	
		forever #5 clk = ~clk;
	end

	initial begin
		reset = 0;
		reset = 1;
		#10 reset = 0;
		$dumpfile("p24b.vcd");
		$dumpvars(0, device);
		fork
			#201 reset = 1;
			#205 reset = 0;
			#300 reset = 1;
			#320 reset = 0;
			#500 $finish;
		join
	end
endmodule
