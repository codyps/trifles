`include "ff.v"

module ring_ct_4b(output [3:0]Q, Qn, input dir, clk);
	wire [3:0]d_ex;
	wire rst, n_rst , rst_1, rst_2, rst_3;

	/* Flip flops */
	D_posedge d0(Q[0], Qn[0], d_ex[0], clk),
	     d1(Q[1], Qn[1], d_ex[1], clk),
	     d2(Q[2], Qn[2], d_ex[2], clk),
	     d3(Q[3], Qn[3], d_ex[3], clk);

	/* Excitation, on rst, go to state 'b0001 */
	or   (d_ex[0], Q[3], rst ); // 1
	and  (d_ex[1], Q[0], n_rst), // 0
	     (d_ex[2], Q[1], n_rst), // 0
	     (d_ex[3], Q[2], n_rst); // 0

     	/* Determine reset state; Q[3:0] = { A, B, C, D };
	 * rst = !A !B !D + !B !C !D + !A !C !D */
	not (rst, n_rst);
     	or  (n_rst, rst_1, rst_2, rst_3);
	and (rst_1, Qn[3], Qn[2], Qn[0]),
	    (rst_2, Qn[2], Qn[1], Qn[0]),
	    (rst_3, Qn[3], Qn[1], Qn[0]);

endmodule

module ring_ct_4b_uni(output [3:0]Q, Qn, input dir, clk);
	wire d_ex;

	/* Flip flops */
	D_posedge d0(Q[1], Qn[1], Q[0], clk),
	          d1(Q[2], Qn[2], Q[1], clk),
	          d2(Q[3], Qn[3], Q[2], clk);

	/* Feed zeros in when more than 1 line
	 * is high */
	nor (Q[0], Q[1], Q[2], Q[3]);
	not (Qn[0], Q[0]);
endmodule
