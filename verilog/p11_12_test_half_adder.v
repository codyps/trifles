`include "p11_12.v"

module ha_test();
	/* Only a very small number of sequences are possible:
	 * { A, B } = 00 , 01, 10, 11. The following puts the adder through
	 * each of these states and monitors its output
	 */

	reg A, B;
	wire S, C;
	half_adder ha(S,C, A,B);

	initial begin
		{ A, B } = 'b00;

		$dumpfile("half_adder.vcd");
		$dumpvars(1,ha);
		$monitor("A=%b B=%b A+B=S=%b C=%b", A,B,S,C);
		#10 A = 1;
		#10 B = 1;
		#10 A = 0;
	end
endmodule
