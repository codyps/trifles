/* HW2, P7 part 1 */

module Y1(output Y, input A,B,C,D);
	//Σm (4,5,6,7,11,12,13)
	// = !A B + !C B + A !B C D

	wire p1,p2,p3, not_a, not_b, not_c;

	not	na(not_a, A),
		nb(not_b, B),
		nc(not_c, C);

	and	a1(p1, not_a, B),
		a2(p2, not_c, B),
		a3(p3, A, not_b, C, D);

	or      of(Y, p1,p2,p3);
endmodule

module t_Y();
	reg A,B,C,D;
	wire Y;
	integer inp;

	initial begin
		$monitor("A=%b B=%b, C=%b, D=%b, Y=%b",A,B,C,D,Y);
		for(inp = 0; inp <= 'b1111; inp = inp + 1) begin
			#10 {A,B,C,D} = inp[3:0];
		end
		$finish();
	end

	Y1(Y,A,B,C,D);

endmodule
