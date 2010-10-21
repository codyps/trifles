`include "ff.v"

module decade_ct(output [3:0]Q, Qn, input clk);
	wire [3:0]d_ex;
	wire n_rst, rst, rst_or;
	D_posedge
		d0(Q[0], Qn[0], d_ex[0], clk),
		d1(Q[1], Qn[1], d_ex[1], Q[0]),
		d2(Q[2], Qn[2], d_ex[2], Q[1]),
		d3(Q[3], Qn[3], d_ex[3], Q[2]);

	
	buf (d_ex[0], n_rst),
	    (d_ex[1], n_rst),
	    (d_ex[2], n_rst),
	    (d_ex[3], n_rst);


    	not (n_rst, rst);
	and (rst, Q[3], rst_or);
	or  (rst_or, Q[2], Q[1], Q[0]);

endmodule
