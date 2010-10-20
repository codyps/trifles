`include "ff.v"
`include "adder.v"

module ring_4b(output [3:0] Q, Qn, input dir, clk);
	wire [3:0] d_ex;
	
	adder_4b add4( d_ex, _, Q, 

	D_ff ff_d0(Q[0], Qn[0], d_ex[0], clk),
	     ff_d1(Q[1], Qn[1], d_ex[1], clk),
	     ff_d2(Q[2], Qn[2], d_ex[2], clk),
	     ff_d3(Q[3], Qn[3], d_ex[3], clk);

endmodule

