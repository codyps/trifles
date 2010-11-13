
module alu_p #(parameter WIDTH=8)
	(output reg [WIDTH:0] out,
		input [WIDTH-1:0] a, b, input c_in, input [2:0]op);
	parameter [2:0]
		OP_ADD  = 0,
		OP_SUB  = 1,
		OP_SUBB = 2,
		OP_OR   = 3,
		OP_AND  = 4,
		OP_NOT  = 5,
		OP_XOR  = 6,
		OP_XNOR = 7;

	always @(a, b, op, c_in)
		case (op)
			OP_ADD: out <= a + b + c_in;
			OP_SUB: out <= a + (~b) + c_in;
			OP_SUBB:out <= b + (~a) + (~c_in);
			OP_OR:  out <= {1'b0, a | b};
			OP_AND: out <= {1'b0, a & b};
			OP_NOT: out <= {1'b0, (~a) & b};
			OP_XOR: out <= {1'b0, a ^ b};
			OP_XNOR:out <= {1'b0, a ~^ b};
		endcase
endmodule

module tb_27();
	parameter width = 8;
	wire [width:0] out;
	reg [width-1:0]  a, b;
	reg c_in;
	reg [2:0] op;

	alu_p #(width) alu8(out, a, b, c_in, op);

	integer i, j, k;

	initial begin
		a = 'b0111_0101;
		b = 'b0001_1010;
		c_in = 0;
		op = 0;
		$dumpfile("p27.vcd");
		$dumpvars(0,tb_27);


		for(i = 0; i <= 1; i = i + 1) begin
			c_in = i;
			for (j = 0; j <= alu8.OP_XNOR; j = j + 1) begin
				op = j;
				#5;
			end
		end
	end

endmodule
