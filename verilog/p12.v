module sr_latch(output Q, Qn, input S, R);
	nand #2 n1(Q,  S, Qn),
	        n2(Qn, R, Q);
endmodule
