`include "p11_12.v"

module r4a_test();
	/* for each possible A input, we will try each possible B input,
	 * resulting in an interation through possible inputs. Not all
	 * transitions are tried as there are not any reverse connections in
	 * the circuit (a higher level connecting to a lower level) that would
	 * make them necissary. */

	reg [3:0] A, B;
	reg Cin;
	wire [3:0] S;
	wire Cout;
	integer ct_a, ct_b;
	r4_adder r4a(S,Cout, A,B,Cin);

	initial begin
		A = 0;
		B = 0;
		Cin = 0;

		$dumpfile("r4_adder.vcd");
		$dumpvars(1,r4a);
		$monitor("A=%d B=%d Cin=%b A+B+Cin=test(%d C=%b)=%d",A,B,Cin,S,Cout,A+B);
		for (ct_a = 0; ct_a <= 'b1111; ct_a = ct_a + 1) begin
			#10 A = ct_a;
			for (ct_b = 0; ct_b <= 'b1111; ct_b = ct_b + 1) begin
				#10 B = ct_b;
			end
		end
	end
endmodule
