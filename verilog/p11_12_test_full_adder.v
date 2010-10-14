`include "p11_12.v"

module fa_test();
	/* Nearly identical to the half-adder testing, with the sole addition
	 * of an additional input, in testing the full-adder, only a very
	 * small number of input variations are avaliable for us to test.
	 * { A, B, Cin } = 000 , 001, 010, 011, 100, 101, 110, 111
	 * The following puts the adder through
	 * each of these states and monitors its output
	 */
	reg A, B, Cin;
	wire S, Cout;
	integer ct;
	full_adder fa(S,Cout, A,B,Cin);

	initial begin
		{ A, B, Cin } = 'b000;

		$dumpfile("full_adder.vcd");
		$dumpvars(1,fa);
		$monitor("A=%b B=%b Cin=%b A+B+Cin=S=%b Cout=%b", A,B,Cin,S,Cout);
		for(ct = 0; ct <= 'b111; ct = ct + 1) begin
			#10 { A, B, Cin } = ct[2:0];
		end
	end
endmodule

