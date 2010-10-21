`include "ff.v"

module ff_tb();
	wire Q, Qn;
	reg D, clk, clr, pr;

	D_posedge_async device(Q, Qn, clr, pr, D, clk);

	initial begin
		clr = 0; pr = 1;
		#10 clr = 1;
		$dumpfile("ff_test.vcd");
		$dumpvars(0, device);
		$monitor("D:%b clk:%b Q:%b clr:%b pr:%b", D, clk, Q, clr, pr);
		D = 0;
		clk = 0;

		#10 D = 1;
		#10 clk = 0;
		#10 clk = 1;
		#10 pr = 0;
		#10 pr = 1;
		#10 clr = 0;
		#10 clr = 1;
		#10 pr = 0;
		#10 pr = 1;
		#10 clk = 0;
		#10 clk = 1;
		#10 D = 0;
		#10 D = 1;
		#10 D = 0;
		#10 clk = 0;
		#10 clk = 1;
		#10 clk = 0;

	end
endmodule
