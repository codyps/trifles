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

module mux2(output Q, input X, Y, sel);
	not(sel_l, sel);
	and(d1, X, sel_l);
	and(d2, Y, sel);
	or (Q,d1,d2);
endmodule

module r4(output [3:0]Q, input dir, clk, reset_l);
	wire [2:0]ex;

	nor(Q[3], Q[0], Q[1], Q[2]);

	mux2 m0(ex[0], Q[3] , Q[1], dir),
		m1(ex[1], Q[0], Q[2], dir),
		m2(ex[2], Q[1], Q[3], dir);

	D_posedge_async d0(Q[0], , reset_l, 1, ex[0], clk),
		d1(Q[1], , reset_l, 1, ex[1], clk),
		d2(Q[2], , reset_l, 1, ex[2], clk);

endmodule

module p17_tb();
	wire [3:0]Q;
	reg  clk, dir, reset_l;
	integer i;

	r4 device(Q, dir, clk, reset_l);

	initial begin
		$dumpfile("p17.vcd");
		$dumpvars(0,device);

		clk = 0;
		dir = 0;
		#5 reset_l = 0;
		#5 reset_l = 1;

		for (i = 0; i < 10; i = i + 1) begin
			#10
			clk = 1;
			#10
			clk = 0;
		end

		dir = 1;
		for (i = 0; i < 10; i = i + 1) begin
			#10
			clk = 1;
			#10
			clk = 0;
		end

	end

endmodule
