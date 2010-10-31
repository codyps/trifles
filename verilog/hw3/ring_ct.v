module ring_ct_4b_uni(output [3:0]Q, Qn, input dir, clk, rst);
	wire d_ex;

	/* Flip flops */
	D_posedge d0(Q[1], Qn[1], Q[0], clk),
	          d1(Q[2], Qn[2], Q[1], clk),
	          d2(Q[3], Qn[3], Q[2], clk);

	/* Feed zeros in when more than 1 line
	 * is high */
	nor (Q[0], Q[1], Q[2], Q[3]);
	not (Qn[0], Q[0]);
endmodule
