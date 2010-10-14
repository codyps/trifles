
/* 11: Develope a small set of test patterns that will (1) test a half-adder
 * circuit, (2) test a full-adder circuit, (3) exahausively test a 4-bit ripple
 * carry adder, and (4) test a 16 bit ripple carry adder by verifying that the
 * conectivity between the 4-bit slices are connected correctly, given that the
 * 4-bit slices themselves have been verified
 */

/* 12: Develop and exercise a testbench  (including a test plan) to verify
 * a gate-level model of a full adder
 */

/* For problem 11 & 12, please develop the verilog code for a 4 bit ripple
 * carry adder first and verify it by simulation. Then develop the rest of the
 * code to answer question 11 and 12
 */


module half_adder(output S, C, input A, B);
	xor sum(S,A,B);
	and carry(C,A,B);
endmodule

module full_adder(output S, Cout, input A,B,Cin);
	wire s1, c1, c2;
	half_adder ha1(s1,c1, A ,B  ),
		ha2(S ,c2, s1,Cin);
	or carry(Cout, c1,c2);
endmodule

module r4_adder(output [3:0]S, output Cout, input [3:0]A, B, input Cin);
	wire c1, c2, c3;

	full_adder fa1(S[0], c1,   A[0], B[0], Cin),
		fa2(S[1], c2,   A[1], B[1], c1),
		fa3(S[2], c3,   A[2], B[2], c2),
		fa4(S[3], Cout, A[3], B[3], c3);
endmodule

module r16_adder(output [15:0]S, output Cout, input [15:0] A, B, input Cin);
	wire c1, c2, c3;
	r4_adder a1(S[ 3: 0], c1,   A[ 3: 0], B[ 3: 0], Cin),
	         a2(S[ 7: 4], c2,   A[ 7: 4], B[ 7: 4], c1),
	         a3(S[11: 8], c3,   A[11: 8], B[11: 8], c2),
	         a4(S[15:12], Cout, A[15:12], B[15:12], c3);
endmodule


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

module a16_test();
	/* as we can assume that the 4bit adder was succesfully tested, our
	 * goal here is simply to cause the carry interconects (of which there
	 * are 4) to triger in all possible arrangments (16)
	 */

	reg ra1[3:0], ra2[3:0], ra3[3:0], ra4[3:0];
	reg rb1[3:0], rb2[3:0], rb3[3:0], rb4[3:0];


	initial begin


	end
endmodule
