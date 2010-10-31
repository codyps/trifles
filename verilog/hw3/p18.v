`include "decade_ct.v"

module p18_tb();
	wire [3:0] Q, Qn;
	reg clk;

	decade_ct device(Q, Qn, clk);

	integer ct;

	initial begin
		clk = 0;

		$monitor("ct %d  Q %d", ct, Q);
		for (ct = 0; ct < 33; ct = ct + 1) begin
			#10 clk = 0;
			#10 clk = 1;
		end
	end
endmodule
