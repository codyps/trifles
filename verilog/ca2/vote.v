

module vote5(output pass, input [4:0]v);
	wire [9:0]s;
	
	or o0(s[0], v[0], v[1], v[2]),
	    o1(s[1], v[0], v[1], v[3]),
	    o2(s[2], v[0], v[1], v[4]),
	    o3(s[3], v[0], v[2], v[3]),
	    o4(s[4], v[0], v[2], v[4]),
	    o5(s[5], v[0], v[3], v[4]),
	    o6(s[6], v[1], v[2], v[3]),
	    o7(s[7], v[1], v[2], v[4]),
	    o8(s[8], v[1], v[3], v[4]),
	    o9(s[9], v[2], v[3], v[4]);

    	and a0(pass, s[0], s[1], s[2], s[3], s[4],
		s[5], s[6], s[7], s[8], s[9]);
endmodule

module tb_p1();
	reg [4:0]votes;
	wire pass;

	vote5 device(pass, votes);

	integer i;
	initial begin
		$dumpfile("p1.vcd");
		$dumpvars(0, device);
		$monitor("%b => %b", votes, pass);
		for(i = 0; i < 'b11111; i = i + 1) begin
			#10
			votes = i[4:0];
		end
	end
endmodule
