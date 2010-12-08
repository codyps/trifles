module risc_spm #(parameter word_sz=8, sel1_sz=3, sel2_sz=2)
	(	input clk, rst);

	wire [sel1_sz-1:0]sel1_bus_mux;
	wire [sel2_sz-1:0]sel2_bus_mux;

	/* Data */
	wire zero;
	wire [word_sz-1:0] instr, addr, bus_1, mem_word;

	/* Control */
	wire load_r0, load_r1, load_r2, load_r3, load_pc, inc_pc, load_ir;
	wire load_add_r, load_reg_y, load_reg_z;
	wire write;

	/* XXX: complete */

endmodule

module proc_unit #(parameter word_sz=8, sel1_sz=3, sel2_sz=2, op_sz=4)
	(	output [word_sz-1:0] instr, addr, bus_1,
		output flag_z,
		input [word_sz-1:0] mem_word,
		input load_r0, load_r1, load_r2, load_r3, load_pc, inc_pc,
		input [sel1_sz-1:0] sel1_bus_mux,
		input [sel2_sz-1:0] sel2_bus_mux,
		input load_ir, load_add_r, load_reg_y, load_reg_z,
		input clk, rst);


	wire [word_sz-1:0] bus_1, out_r0, out_r2, out_r3;
	wire [word_sz-1:0] pc_count, y_value, alu_out;

	wire alu_zero_flag;

	wire [op_sz-1:0] opcode = instr[word_sz-1:word_sz-op_sz];

	reg_unit r0 (out_r0, bus_2, load_r0, clk, rst);
	reg_unit r1 (out_r1, bus_2, load_r1, clk, rst);
	reg_unit r2 (out_r2, bus_2, load_r2, clk, rst);
	reg_unit r3 (out_r3, bus_2, load_r3, clk, rst);

	reg_unit #(word_sz) reg_y (y_value, bus_2, load_reg_y, clk, rst);

	reg_unit #(1) reg_z(flag_z, alu_zero_flag, load_reg_z, clk, rst);

	/* address register */
	reg_unit #(word_sz) add_r(addr, bus_2, load_add_r, clk, rst);

	reg_unit #(word_sz) instr_reg(instr, bus_2, load_ir, clk, rst);

	prgm_cnt  pc(pc_count, bus_2, load_pc, inc_pc, clk, rst);

	mux_5ch   mux_1(bus_1, out_r0, out_r1, out_r2, out_r3, pc_count, sel1_bus_mux);
	mux_3ch   mux_2(bus_2, alu_out, bus_1, mem_word, sel2_bus_mux);

	alu_risc alu(alu_zero_flag, alu_out, y_vlue, bus_1, opcode);

endmodule

module prgm_cnt #(parameter word_sz=8) 
	(	output reg [word_sz-1:0] count,
		input [word_sz-1:0] data_in,
		input load_pc, inc_pc,
		input clk, rst);

	always @(posedge clk or negedge rst)
		if (~rst)
			count <= 0;
		else if (load_pc)
			count <= data_in;
		else if (inc_pc)
			count <= count + 1;
endmodule

module reg_unit #(parameter ff_sz=8)
	(	output reg[ff_sz-1:0] data_out,
		input [ff_sz-1:0] data_in,
		input load,
		input clk, rst);

	always @(posedge clk or negedge rst)
		if (~rst)
			data_out <= 0;
		else if (load)
			data_out <= data_in;
endmodule

module mux_5ch #(parameter word_sz=8)
	(	output [word_sz-1:0] mux_out,
		input [word_sz-1:0] data_a, data_b, data_c, data_d, data_e,
		input [2:0] sel);

	assign mux_out = (sel == 0) ? data_a :
			 (sel == 1) ? data_b :
			 (sel == 2) ? data_c :
			 (sel == 3) ? data_d :
			 (sel == 4) ? data_e : 'bx;
endmodule

module op();
	localparam NOP = 4'b0000;
	localparam ADD = 4'b0001;
	localparam SUB = 4'b0010;
	localparam AND = 4'b0011;
	localparam NOT = 4'b0100;
	localparam RD  = 4'b0101;
	localparam WR  = 4'b0110;
	localparam BR  = 4'b0111;
	localparam BRZ = 4'b1000;
endmodule

module mux_3ch #(parameter word_sz=8)
	(	output [word_sz-1:0] mux_out,
		input [word_sz-1:0] data_a, data_b, data_c,
		input [1:0]sel);
	assign mux_out = (sel == 0) ? data_a :
			 (sel == 1) ? data_b :
			 (sel == 3) ? data_c : 'bx;

endmodule

module alu_risc #(parameter word_sz=8, op_sz=4)
	(	output alu_zero_flag,
		output reg [word_sz-1:0] alu_out,
		input [word_sz-1:0] data_1, data_2,
		input [op_sz-1:0] sel);


	assign alu_zero_flag = ~|alu_out;
	always @(sel or data_1 or data_2)
		case (sel)
			op.NOP: alu_out <= 0;
			op.ADD: alu_out <= data_1 + data_2; // reg_y + bus_1
			op.SUB: alu_out <= data_2 - data_1;
			op.AND: alu_out <= data_1 & data_2;
			op.NOT: alu_out <= ~data_2; // gets data from bus_1
			default: alu_out <= 0;
		endcase
endmodule

module ctrl_unit #(word_sz=8, op_sz=4, state_sz=4, src_sz=2, dst_sz=2, sel1_sz=3, sel2_sz=2)
	();

endmodule
