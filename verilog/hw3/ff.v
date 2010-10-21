module SRn_ff(output Q, Qn, input Sn, Rn);
	nand a1(Q,  Sn, Qn),
	     a2(Qn, Rn, Q);
endmodule

module SR_ff(output Q, Qn, input S, R);
	nor n1(Q,  R, Qn),
	    n2(Qn, S, Q);
endmodule

/* D, posedge triggered */
module D_posedge(output Q, Qn, input D, clk);
	wire Aqn, Bqn, Bq;

	SRn_ff	srA(_, Aqn, Bqn, clk),
		srB(Bq, Bqn, clk, D),
		srC(Q, Qn, Aqn, Bq);
endmodule

module D_posedge_async(output Q, Qn, input clr_l, pre_l, D, clk);
	wire [3:0]n_out; /* level 1 nand outputs */

	/* level 1 nands */
	nand 	lnand0(n_out[0], pre_l, n_out[1], n_out[3]),
		lnand1(n_out[1], n_out[0], clk, clr_l),
		lnand2(n_out[2], n_out[1], clk, n_out[3]),
		lnand3(n_out[3], D, n_out[2], clr_l);

	/* level 2 nands */
	nand    unand0(Q, n_out[1], pre_l, Qn),
		unand1(Qn, n_out[2], Q, clr_l);

endmodule


module T_posedge(output Q, Qn, input rst_l, T, clk);
	xor (D, T, Q);
	D_posedge_async d(Q, Qn, rst_l, 1, D, clk);
endmodule
