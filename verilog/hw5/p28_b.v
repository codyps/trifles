
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

module reg_file #(parameter word_sz = 8, addr_sz = 5)
	(output [word_sz-1:0] do_1, do_2, input [word_sz-1:0]di,
		input [addr_sz-1:0] raddr_1, raddr_2, waddr,
		input wr_enable, clk);

	parameter reg_ct = 2**addr_sz;
	reg [word_sz-1:0] file [reg_ct-1:0];

	assign do_1 = file[raddr_1];
	assign do_2 = file[raddr_2];

	always @(posedge clk)
		if (wr_enable)
			file[waddr] <= di;
endmodule

module alu_reg #(parameter word_sz = 8, addr_sz = 5)
	(	output [word_sz:0] alu_out,
		input [word_sz-1:0] di,
		input [addr_sz-1:0] raddr_1, raddr_2, waddr,
		input [2:0] opcode,
		input c_in, wr_enable, clk);

	wire [word_sz-1:0]do_1, do_2;

	reg_file #(word_sz, addr_sz) rfile(do_1, do_2, di, raddr_1, raddr_2,
		waddr, wr_enable, clk);
	alu_p #(word_sz) alu(alu_out, do_1, do_2, c_in, opcode);
endmodule

module tb_reg_alu();
	parameter word_sz = 8,
		addr_sz = 5;
	wire [word_sz:0] alu_out;
	reg [word_sz-1:0] di;
	reg [addr_sz-1:0] raddr_1, raddr_2, waddr;
	reg [2:0] opcode;
	reg c_in, wr_en, clk;

	alu_reg #(word_sz, addr_sz) dev(alu_out, di, raddr_1, raddr_2,
		waddr, opcode, c_in, wr_en, clk);

	initial begin
		clk = 0;
		forever clk = ~clk;
	end

	initial begin
		#500 $finish();
	end

	integer i;
	initial begin
		opcode = dev.alu.OP_ADD;
		di = 1;
		c_in = 0;
		wr_en = 1;
		waddr = 0;
		raddr_1 = 0;
		raddr_2 = 0;
	
		$dumpfile("p28_b.vcd");
		$dumpvars(0, tb_reg_alu);

		for( i = 0; i < word_sz; i = i + 1) begin
			@(negedge clk)
			waddr <= waddr + 1;
			raddr_1 <= raddr_1 + 1;
			raddr_2 <= raddr_2 + 1;
		end

		$finish();
	end

endmodule

