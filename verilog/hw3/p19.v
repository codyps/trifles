
module divide_by_11(output clk_by_11, input rst_b, clk);
	wire [3:0]Q, Qn
	T_ff t0(1, Q[0], Qn[0], rst, clk),
	     t1(1, Q[1], Qn[1], rst, Q[0]),
	     t2(1, Q[2], Qn[2], rst, Q[1]),
	     t3(1, Q[3], Qn[3], rst, Q[2]);

     	wire Q_f, Qn_f;
     	T_ff t_final(w2, Q_f, Qn_f, rst_b, clk);

	or (w2, Q_f, w1);
	and (w1, Qn[0], Q[1], Q[2], Qn[3]);
	buf (rst, clk_by_11, Qn_f);
endmodule
