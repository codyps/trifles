
module op();
	localparam ADD = 'b000;
	localparam AND = 'b001;
	localparam NAND = 'b010;
	localparam OR = 'b011;
	localparam XOR = 'b100;
	
	localparam SGT = 'b101;

	localparam SLL = 'b110;
	localparam SRL = 'b111;
endmodule

module reg_file
	#(parameter d_width = 32, reg_ct = 32, raddr_sz = $clog2(reg_ct) )
	(	output reg[d_width-1:0] ra, rb,
		input [d_width-1:0] rd,
		input [raddr_sz-1:0] addr_a, addr_b, addr_d,
		input clk);

	reg [d_width-1:0] regs[reg_ct-1:0];

	always @(negedge clk) begin
		regs[addr_d] <= rd;
	end

	always @(posedge clk) begin
		ra <= regs[addr_a];
		rb <= regs[addr_b];
	end
endmodule

module alu #(parameter d_width = 32, op_width = 3)
	(	output reg [d_width-1:0]res,
		input [d_width-1:0]ra, rb,
		input [op_width-1:0]op);

	always @(ra,rb,op)
		case (op)
			op.ADD : res <= ra + rb;
			op.AND : res <= ra & rb;
			op.NAND: res <= ~(ra & rb);
			op.OR  : res <= ra | rb;
			op.XOR : res <= ra ^ rb;
		endcase
endmodule

module shifter #(parameter d_width = 32, raddr_sz = 5)
	(	output reg [d_width-1:0]res,
		input [d_width-1:0] rin,
		input [raddr_sz-1:0] shift,
		input dir);

	always @(dir, shift, rin)
		if (dir)
			res <= rin << shift;
		else
			res <= rin >> shift;

endmodule

module control #(parameter d_width = 32, reg_ct = 32,
		raddr_sz = $clogb2(reg_ct), op_width = 3)
	(	output reg[op_width-1:0] alu_op,
		output reg shift_dir, select_alu,
		input [op_width-1:0] opcode,
		input [raddr_sz-1:0] sr2,
		input clk
	);

	always @(posedge clk) begin
		alu_op <= opcode;
		select_alu <= ( opcode == op.SLL 
			|| opcode == op.SRL 
			|| opcode == op.SGT ) ? 0 : 1;
		shift_dir <= opcode[0];
	end
endmodule

module cpu #(parameter ins_width = 18, d_width = 32, reg_ct = 32,
		ra_width = $clogb2(reg_ct), op_width = 3)
	(	input [ins_width-1:0]ins,
		input clk
	);

	wire [op_width-1:0] alu_op, opcode;
	wire s_alu, shift_dir;
	wire [ra_width-1:0] ar1, ar2, ar_dest;
	wire [d_width-1:0] r1, r2;
	wire [d_width-1:0] shift_res, alu_res;
	wire [d_width-1:0] result;

	opcode  = ins[17:15];
	ar_dest = ins[14:10];
	ar1 = ins[9:5];
	ar2 = ins[4:0];

	control ctrl(.alu_op(alu_op), .select_alu(s_alu), .opcode(opcode),
			.shift_dir(shift_dir));
	shifter sh(.res(shift_res), .rin(r1), .shift(ar2), .dir(shift_dir));

	alu alui(.res(alu_res), .ra(r1), .rb(r2), .op(alu_op));

	reg_file regs(.ra(r1), .rb(r2), .rd(result), .addr_a(ar1),
		.addr_b(ar2), .addr_d(ar_dest), .clk(clk));

end

module tb();
	reg [17:0] ins;
	reg clk;

	cpu cpu1(ins, clk);

	initial begin

	end
endmodule
