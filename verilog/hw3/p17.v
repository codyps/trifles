`include "ring_ct.v"

/* For some reason, dispite the circuit seeming completely correct, verilog
 * never realizes that it will make it out of an undefined state (x), as it
 * gets out of the undefined state at an undefined time. This was an issue
 * on all of the problems in this HW3 (17,18,19)
 */

module p17_tb();
	wire [3:0]Q, Qn;
	reg  clk, dir;
	integer i;

	ring_ct_4b device(Q, Qn, dir, clk);

	initial begin
		clk = 0;
		dir = 0;

		$monitor("Q = %b (%d) | dir %b | clk %b | rst %b",
			Q, Q, dir, clk,
			device.rst );

		for (i = 0; i < 10; i = i + 1) begin
			#10
			clk = 1;
			#10
			clk = 0;
		end

		dir = 1;
		for (i = 0; i < 10; i = i + 1) begin
			#10
			clk = 1;
			#10
			clk = 0;
		end

	end

endmodule
