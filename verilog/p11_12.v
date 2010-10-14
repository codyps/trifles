
/* 11: Develope a small set of test patterns that will (1) test a half-adder
 * circuit, (2) test a full-adder circuit, (3) exahausively test a 4-bit ripple
 * carry adder, and (4) test a 16 bit ripple carry adder by verifying that the
 * conectivity between the 4-bit slices are connected correctly, given that the
 * 4-bit slices themselves have been verified
 */

/* 12: Develop and exercise a testbench (including a test plan) to verify a
 * gate level model of an S-R (set-reset) latch
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

module r4_adder(output S[3:0], Cout, input A[3:0], B[3:0], Cin);
	wire c1, c2, c3;

	full_adder fa1(S[0], c1,   A[0], B[0], Cin),
		fa2(S[1], c2,   A[1], B[1], c1),
		fa3(S[2], c3,   A[2], B[2], c2),
		fa4(S[3], Cout, A[3], B[3], c3);
endmodule

module r16_adder(output S[15:0], Cout, input A[15:0], B[15:0], Cin);
	wire c1, c2, c3;
	
	r4_adder a1(S[ 3: 0], c1,   A[ 3: 0], B[ 3: 0], Cin),
	         a2(S[ 7: 4], c2,   A[ 7: 4], B[ 7: 4], c1),
	         a3(S[11: 8], c3,   A[11: 8], B[11: 8], c2),
	         a4(S[15:12], Cout, A[15:12], B[15:12], c3);
endmodule


module ha_test();
	reg A, B;
	wire S, C;
	
	half_adder ha(S,C, A,B);

	initial begin
		{ A, B } = 'b00;

		$monitor("A=%b B=%b A+B=S=%b C=%b", A,B,S,C);
		#10 A = 1;
		#10 B = 1;
		#10 A = 0;
	end
endmodule

module fa_test();
	reg A, B, Cin;
	wire S, Cout;

	full_adder fa(S,Cout, A,B,Cin);

	initial begin

	end

endmodule

module tb();


endmodule
