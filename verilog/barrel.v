module barrel
	#(parameter width=16)
	(input [width-1:0] in,
	 input [$clog2(width)-1:0] ct,
	 input dir,
	 input [1:0] type,
	 output [width-1:0] out);

	/* direct  inputs = f */
	/* shifted inputs = g */
	/* mux    outputs = h */
	wire [width-1:0] f[$clog2(width)-1:0], g[$clog2(width)-1:0], h[$clog2(width):0];

	assign h[0] = in;
	assign out = h[$clog2(width)-1];

	generate
		genvar i;
		for(i = 0; i < $clog2(width) - 1; i = i+1) begin : a
			magic#(.width(width), .shift(2**i)) v(h[i], type, left, g[i]);
			mux2 #(.width(width)) u(h[i], g[i], ct[$clog2(width)-i-1], h[i+1]);
		end
	endgenerate
endmodule

module magic
	#(parameter width = 16,
	  parameter shift = $clog2(width))
	(input [width-1:0]h,
	 input [1:0]type,
	 input left,
	 output reg [width-1:0]z);

	localparam NS=0, LO=1, AR=2, RO=3;
	always @(*) if (left) begin
		case(type)
		NS: z <= h;
		LO: z <= h <<  shift;
		AR: z <= h <<< shift;
		RO: z <= { h[width-1-shift:0], h[width-1:width-1-shift-1] };
		endcase
	end else begin
		case(type)
		NS: z <= h;
		LO: z <= h >>  shift;
		AR: z <= h >>> shift;
		RO: z <= { h[width-1:width-1-shift-1], h[width-1-shift:0] };
		endcase
	end
endmodule

module mux2
	#(parameter width=16)
	(input [width-1:0] A, B,
	 input sel,
	 output [width-1:0] out);

	assign out = sel ? A : B;
endmodule
