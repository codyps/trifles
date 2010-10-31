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

module d2(output [3:0]ct, input clk, reset);
	wire rst;
	// !rst = !reset || (ct[3] && (ct[2] || ct[1]))
	not(rst, rst_n);
	not(reset_n, reset);
	or(rst_n, reset_n, ct_rst);
	and(ct_rst, ct[3], ct_rst_2);
	or(ct_rst_2, ct[1], ct[2]);

	T_posedge t0(ct[0],, rst, 1, clk),
		t1(ct[1],, rst, 1, ct[0]),
		t2(ct[2],, rst, 1, ct[1]),
		t3(ct[3],, rst, 1, ct[2]);
endmodule

module decade_ct(output [3:0]Q, Qn, input clk, reset);
	wire [3:0]d_ex;
	wire n_rst, rst, rst_or;
	D_posedge_async
		d0(Q[0], Qn[0], reset, 1, d_ex[0], clk),
		d1(Q[1], Qn[1], reset, 1, d_ex[1], Q[0]),
		d2(Q[2], Qn[2], reset, 1, d_ex[2], Q[1]),
		d3(Q[3], Qn[3], reset, 1, d_ex[3], Q[2]);

	buf (d_ex[0], n_rst),
	    (d_ex[1], n_rst),
	    (d_ex[2], n_rst),
	    (d_ex[3], n_rst);

    	not (n_rst, rst);
	and (rst, Q[3], rst_or);
	or  (rst_or, Q[2], Q[1], Q[0]);

endmodule

module p18_tb();
	wire [3:0]ct;
	reg clk, reset_l;
	integer i;

	d2 dev(ct,clk,reset_l);

	initial begin
		$dumpfile("p18.vcd");
		$dumpvars(0,dev);

		clk = 0;
		#5 reset_l = 0;
		#5 reset_l = 1;

		for (i = 0; i < 25; i = i + 1) begin
			#10
			clk = 1;
			#10
			clk = 0;
		end

	end
endmodule
