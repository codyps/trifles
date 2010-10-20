module mux_2_1(output Z, input A, B, S);
	not (Sn, S);
	and (e1, A, Sn),
		(e2, B, S);
	or (Z, e1, e2);
endmodule
