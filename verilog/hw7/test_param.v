module A ();
	parameter X = 7;
	initial $display("A:%d",X);
endmodule

module B ();
	parameter X = 7;
	initial $display("B:%d",X);
	A a();
endmodule

module tb();

	B b();
	defparam b.X=10;

endmodule
