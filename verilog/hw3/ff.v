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

module JK_posedge(output Q, Qn, input pre, clr_l, J, K, clk);
	
endmodule

module D_posedge2(output Q, Qn, input CLR_l, PR_l, D, clk);
	wire r_final, s_final, s_f2, r_f2;
	wire clk_n, clk_n_n;
	wire r_s1, r_s2, s_s1, s_s2;
	wire Dn;

	SR_ff  sr_final(Q, Qn, s_final, r_final);
	nor (r_final, CLR_l, r_f2);
	nor (s_final, PR_l, s_f2);

	nand (r_f2, q1, clk_n_n);
	nand (s_f2, qn1, clk_n_n);

	SR_ff sr_1(q1, qn1, s_s1, r_s1);
	nor  (r_s1, CLR_l, r_s2);
	nor  (s_s1, PR_l,  s_s2);

	nand (r_s2, clk_n, Dn);
	nand (s_s2, clk_n, D);

	not (Dn, D);
	not (clk_n, clk);
	not (clk_n_n, clk_n);
endmodule

module T_posedge(output Q, Qn, input rst_l, T, clk);
	xor (D, T, Q);
	D_posedge2 d(Q, Qn, 1, rst_l, D, clk);
endmodule
