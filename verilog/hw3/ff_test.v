`include "ff.v"

module ff_tb();
	wire Q, Qn;
	reg D, clk;

	D_posedge device(Q, Qn, D, clk);

	initial begin
		$monitor("D:%b clk:%b Q:%b", D, clk, Q);
		D = 0;
		clk = 0;

		#10 D = 1;
		#10 clk = 0;
		#10 clk = 1;
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
