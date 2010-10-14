module mux(output Y, input sel, A, B);
	always@(sel or A or B)
		case(sel)
			0: Y <= A;
			1: Y <= B;
		endcase
endmodule

module p4_15(output Y, input Sel, A,B,C,D);
	wire m1, m2;

	nand	n1(m1, A,B),
		n2(m2, C,D);

	mux     m(Y, Sel, m1,m2);

endmodule
