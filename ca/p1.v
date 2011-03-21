module majority_voter(output result, input [4:0] v);
	wire [8:0]s;
	//         0     0     0
	or(s[0], v[0], v[1], v[2]);
	//         0     0     1
	or(s[1], v[0], v[1], v[3]);
	//         0     1     0
	or(s[2], v[0], v[2], v[3]);
	//         0     1     1
	or(s[3], v[0], v[2], v[4]);
	//         1     0     0
	or(s[4], v[1], v[2], v[3]);

	or(s[3], v[0], v[2], v[3]);
	or(s[4], v[0], v[2], v[4]);

	or(s[5], v[0], v[3], v[4]);

	or(s[6], v[1], v[2], v[3]);
	or(s[7], v[1], v[2], v[4]);

	or(s[8], v[1], v[3], v[4]);

	//or(s[?], v[1], v[4], v[?]);

	or(s[9], v[2], v[3], v[0])


	or(s[5], v[2], v[3], v[4]);
	or(s[6], v[2], v[3], v[0]);
	//or(s[?], v[2], v[3], v[1]);

	or(s[7], v[3], v[4], v[0]);
	or(s[8], v[3], v[4], v[1]);
	//or(s[?], v[3], v[4], v[2]);
	
	or(s[ 9], v[4], v[0], v[1]);
	or(s[10], v[4], v[0], v[2]);
	//or(s[?], v[4], v[0], v[3]);

	and(result, s);
endmodule
