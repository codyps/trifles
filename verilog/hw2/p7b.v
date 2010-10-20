/* HW2, P7 part 2 */

module Y2(output Y, input A,B,C,D);
	//Σm (1,2,3,4)
	// = !A !B D + !A !B C + !A B !C !D

	wire p1,p2,p3, not_a,not_b,not_c,not_d;

	not	na(not_a, A),
		nb(not_b, B),
		nc(not_c, C),
		nd(not_d, D);

	and	a1(p1, not_a,not_b,D),
		a2(p2, not_a,not_b,C),
		a3(p3, not_a,B,not_c,not_d);

	or	of(Y, p1,p2,p3);

endmodule

module t_Y();
	reg A,B,C,D;
	wire Y;
	integer inp;
	
	Y2 device(Y,A,B,C,D);

	initial begin
		$dumpfile("p7b.vcd");
		$dumpvars(1,device);
		$monitor("A=%b B=%b, C=%b, D=%b, Y=%b",A,B,C,D,Y);
		for(inp = 0; inp <= 'b1111; inp = inp + 1) begin
			#10 {A,B,C,D} = inp[3:0];
		end
		$finish();
	end


endmodule

