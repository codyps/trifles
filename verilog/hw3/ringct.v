`include "ff.v"

module ringct_4b(output [3:0]Q, Qn, input dir, clk);
	wire [3:0]d_ex, rst, rst_1, rst_2, rst_3;

	/* Flip flops */
	D_ff d0(Q[0], Qn[0], d_ex[0], clk),
	     d1(Q[1], Qn[1], d_ex[1], clk),
	     d2(Q[2], Qn[2], d_ex[2], clk),
	     d1(Q[3], Qn[3], d_ex[3], clk);

	/* Excitation, on rst, go to state 'b0001 */
	or   (d_ex[0], Q[3], rst);
	and  (d_ex[1], Q[0], rst),
	     (d_ex[2], Q[1], rst),
	     (d_ex[3], Q[2], rst);

	/* Determine reset state; Q[3:0] = { A, B, C, D };
	 * rst = !A !B !D + !B !C !D + !A !C !D */
     	or   (rst, rst_1, rst_2, rst_3);
	and  (rst_1, Qn[3], Qn[2], Qn[0]),
	     (rst_2, Qn[2], Qn[1], Qn[0]),
	     (rst_3, Qn[3], Qn[1], Qn[0]);
		
endmodule
