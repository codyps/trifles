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

/*
module T_posedge(output Q, Qn, input clk);
endmodule
*/
