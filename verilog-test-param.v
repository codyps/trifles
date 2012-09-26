module foo(input fake);
	parameter bar = 10;

	initial
		$display("bar %d", bar);
endmodule

module main();
	reg p = 0;
	foo #(4) f(p);
endmodule
