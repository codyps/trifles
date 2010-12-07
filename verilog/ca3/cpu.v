
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
	#(parameter d_width = 32, reg_ct = 32, ra_width = $clog2(reg_ct) )
	(	output reg[d_width-1:0] ra, rb,
		input [d_width-1:0] rd,
		input [ra_width-1:0] addr_a, addr_b, addr_d,
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
		input [op_width-1:0]aop);

	always @(ra,rb,aop)
		case (aop)
			op.ADD : res <= ra + rb;
			op.AND : res <= ra & rb;
			op.NAND: res <= ~(ra & rb);
			op.OR  : res <= ra | rb;
			op.XOR : res <= ra ^ rb;
			op.SGT : res <= (ra > rb) ? 1 : 0;
		endcase
endmodule

module shifter #(parameter d_width = 32, ra_width = 5)
	(	output reg [d_width-1:0]res,
		input [d_width-1:0] rin,
		input [ra_width-1:0] shift,
		input dir);

	always @(dir, shift, rin)
		if (dir)
			res <= rin << shift;
		else
			res <= rin >> shift;

endmodule

module control #(parameter d_width = 32, reg_ct = 32,
		ra_width = $clog2(reg_ct), op_width = 3)
	(	output reg[op_width-1:0] alu_op,
		output reg shift_dir, select_alu,
		input [op_width-1:0] opcode,
		input clk
	);

	always @(posedge clk) begin
		alu_op <= opcode;
		select_alu <= ( opcode == op.SLL 
			|| opcode == op.SRL ) ? 0 : 1;
		shift_dir <= opcode[0];
	end
endmodule

module mux_out #(parameter d_width = 32)
	(	output reg[d_width-1:0]out,
		input [d_width-1:0]a, b,
		input sel);

	always @(a,b) begin
		if (sel)
			out <= a;
		else
			out <= b;
	end
endmodule

module cpu #(parameter d_width = 32, reg_ct = 32,
		op_width = 3, ra_width = $clog2(reg_ct),
		ins_width = op_width + ra_width + ra_width + ra_width)
	(	input [ins_width-1:0]ins,
		input clk
	);

	localparam opc_end = ins_width - op_width;
	localparam ar_d_end = opc_end - ra_width;
	localparam ar1_end = ar_d_end - ra_width;
	localparam ar2_end = ar1_end - ra_width; /* must be zero */

	wire [op_width-1:0] alu_op;
	wire [op_width-1:0] opcode = ins[ins_width-1:opc_end];
	wire s_alu, shift_dir;
	wire [ra_width-1:0] 
		ar1 = ins[ar1_end-1:ar2_end],
		ar2 = ins[ar_d_end-1:ar1_end],
		ar_dest = ins[opc_end-1:ar_d_end];
	wire [d_width-1:0] r1, r2;
	wire [d_width-1:0] shift_res, alu_res;
	wire [d_width-1:0] result;

	mux_out #(.d_width(d_width)) 
		muxo (.out(result), .a(alu_res), .b(shift_res), .sel(s_alu));

	control #(.ra_width(ra_width), .d_width(d_width), .reg_ct(reg_ct),
			.op_width(op_width)) 
		ctrl(.alu_op(alu_op), .select_alu(s_alu), .opcode(opcode),
			.shift_dir(shift_dir), .clk(clk));

	shifter #(.ra_width(ra_width), .d_width(d_width))
		sh(.res(shift_res), .rin(r1), .shift(ar2), .dir(shift_dir));

	alu #(.op_width(op_width), .d_width(d_width))
		alui(.res(alu_res), .ra(r1), .rb(r2), .aop(alu_op));

	reg_file #(.ra_width(ra_width), .d_width(d_width), .reg_ct(reg_ct))
		regs(.ra(r1), .rb(r2), .rd(result), .addr_a(ar1),
			.addr_b(ar2), .addr_d(ar_dest), .clk(clk));

endmodule


module tb();
	reg [17:0] ins;
	reg clk;

	cpu cpu1(ins, clk);

	task setr;
		input [3:0]ra;
		input [31:0] rv;
		begin
			cpu1.regs.regs[ra] = rv;
		end
	endtask

	task pregs;
		integer i;
		begin
			$display("regs:");
			for(i = 0; i < 32; i = i + 1) begin
				$display("\t%d:%d",i, cpu1.regs.regs[i]);
			end
		end
	endtask

	task proc;
		input [17:0]cins;
		reg [3:0] op;
		reg [4:0] rdest;
		reg [4:0] rs1;
		reg [4:0] rs2;
		
		begin 
			op = cins[17:15];
			rdest = cins[14:10];
			rs1 = cins[9:5];
			rs2 = cins[4:0];

			ins = cins;
			#10 clk = 1;
			#10 clk = 0;
			#10;

			$display("op: %3b; rs1(%2d): %d; rs2(%2d): %d; rdest(%2d): %d",
				op, rs1, cpu1.regs.regs[rs1], rs2,
				cpu1.regs.regs[rs2], rdest,
				cpu1.regs.regs[rdest]);
		end
	endtask

	initial begin
		clk = 0;
		setr(1, 5);
		setr(2, 6);
		/*    add  %0,   %2,   %1, %0 = %1 + %2 */
		proc('b000_00000_00010_00001);
		pregs();
	end
endmodule
