`include "ff.v"

module ring_4b(output [3:0] Q, Qn, input dir, clk);
	wire d1_ex, d2_ex, d3_ex;
	
	D_ff ff_d0(Q[0], Qn[0], Qn[0], clk),
	     ff_d1(Q[1], Qn[1], d1_ex, clk),
	     ff_d2(Q[2], Qn[2], d2_ex, clk),
	     ff_d3(Q[3], Qn[3], d3_ex, clk);

	d1_excite d1_ex_dev(d1_ex, Y, C, D);
	d2_excite d2_ex_dev(d2_ex, Y, A, B, C, D);
	d3_excite d3_ex_dev(d3_ex, Y, A, B, C, D);
endmodule

module d1_excite(output ex, input Y, C, D);
	wire x_out;
	not n1(ex, x_out);
	xor x1(x_out, Y, C, D);
endmodule

module d2_excite(output ex, input Y, A, B, C, D);
	wire CxY, nCxY, AxB, Dn, DnxAxB, and1_res, and2_res;
	not (Dn, D),
	    (nCxY, CxY);
	xor (CxY, C, Y),
		(AxB, A, B),
		(DnxAxB, AxB, Dn);
	
	and and1(and1_res, CxY, AxY),
	    and2(and2_res, nCxY, DnxAxB);

	or or_final(ex, and1_res, and2_res);
endmodule

module d3_excite(output ex, input Y, A, B, C, D);
	
endmodule
