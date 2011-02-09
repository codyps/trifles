/* 12: Develop and exercise a testbench (including a test plan) to verify a
 * gate level model of an S-R (set-reset) latch
 */
module sr_latch(output Q, Qn, input S, R);
	nand #2 n1(Q,  S, Qn),
	        n2(Qn, R, Q);
endmodule
