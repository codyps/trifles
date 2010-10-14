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


module tb();
	wire Y;
	reg A,B,C,D, Sel;
	integer ct;

	p4_15 device(Y, Sel, A,B,C,D);

	initial begin
		A = B = C = D = Sel = 0;

		$monitor("Sel=%b A(%b)&B(%b)=%b C(%b)&D(%b)=%b Y=%b",
			Sel, A, B, A&B, C, D, C&D, Y);
		$dumpfile("p15.vcd");
		$dumpvars(1,device);

		for (ct = 0; ct <= 'b11111; ct = ct + 1) begin
			#10 { Sel, A, B, C, D } = ct;
		end
	end
endmodule
