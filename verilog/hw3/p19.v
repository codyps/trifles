
`include "ff.v"

module divide_by_11(output clk_by_11, input rst_b, clk);
	wire [3:0]Q, Qn;
	T_posedge
		t0(Q[0], Qn[0], clk_by_11, 1, clk),
		t1(Q[1], Qn[1], clk_by_11, 1, Q[0]),
		t2(Q[2], Qn[2], clk_by_11, 1, Q[1]),
		t3(Q[3], Qn[3], clk_by_11, 1, Q[2]);

     	wire Q_f, Qn_f;
     	T_posedge t_final(w2, Q_f, Qn_f, rst_b, clk);

	or (w2, Q_f, w1);
	and (w1, Qn[0], Q[1], Q[2], Qn[3]);
	buf (rst, clk_by_11, Qn_f);
endmodule

module p19_tb();
	wire out_clk;
	reg rst_l, clk;
	integer ct;

	divide_by_11 device(out_clk, rst_l, clk);

	initial begin
		clk = 0;
		#1 rst_l = 0;
		#1 rst_l = 1;

		$monitor("%d out=%b in=%b", ct, out_clk, clk);

		for (ct = 0; ct < 25; ct = ct + 1) begin
			#10 clk = 0;
			#10 clk = 1;
		end

	end
endmodule
