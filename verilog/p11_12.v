
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



