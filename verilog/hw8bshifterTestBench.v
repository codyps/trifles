`include "barrel.v"

module w();
	localparam w=32;
	wire [w-1:0] out, in;
	wire [1:0] type;
	wire [$clog2(w)-1:0] ct;
	wire dir;

	testbShifter a(out, in, ct, dir, type);
	barrel#(.width(w)) b(in, ct, dir, type, out);
endmodule

module testbShifter(Z, A, COUNT, LEFT, TYPE);


	input	[31:0] 	Z;
		
	output	[31:0]	A;
	output	[4:0]	COUNT;
	output	[1:0]	TYPE;
	output		LEFT;

	reg	[31:0]	A;
	reg	[4:0]	COUNT;
	reg	[1:0]	TYPE;
	reg		LEFT;




	initial
		begin

		$dumpvars;
		$dumpfile("bshifter.dump");
		$monitor($time,,, "A = %b LEFT = %b TYPE=%d COUNT = %d Z = %b", A, LEFT, TYPE, COUNT, Z);
	
		A     = 2;
		LEFT  = 1;
		TYPE  = 1;
		COUNT = 1;

		#10 A     = 2;
		    LEFT  = 1;
		    TYPE  = 1;
		    COUNT = 10;


		#10 A	  = 24;
		    LEFT  = 0;
		    COUNT = 5;
		

		#10 A	  = 5;
		    LEFT  = 1;
		    TYPE  = 2;
		    COUNT = 3;

		#10 A[31] = 1'b1;
		    LEFT  = 0;
		    COUNT = 2;

		#10 A[30] = 1'b1;
		    A[29] = 1'b1;
		    LEFT  = 1;
		    TYPE  = 3;
		    COUNT = 3;	

		#10 A     = 7;
		    LEFT  = 0;
		    COUNT = 3;	


		#10 TYPE  = 0;

		#10  A  = 0;  // dummy case
			

		#30 $finish;



		end




endmodule
