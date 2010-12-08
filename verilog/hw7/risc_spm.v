module risc_spm #(parameter word_sz=8, sel1_sz=3, sel2_sz=2)
	(	input clk, rst);

	wire [sel1_sz-1:0]bus1_sel_mux;
	wire [sel2_sz-1:0]bus2_sel_mux;

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
		input [sel1_sz-1:0] bus1_sel_mux,
		input [sel2_sz-1:0] bus2_sel_mux,
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

	mux_5ch   mux_1(bus_1, out_r0, out_r1, out_r2, out_r3, pc_count, bus1_sel_mux);
	mux_3ch   mux_2(bus_2, alu_out, bus_1, mem_word, bus2_sel_mux);

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
	(	output reg load_r0, load_r1, load_r2, load_r3, load_r4, load_pc, inc_pc,
		output [sel1_sz-1:0] bus1_sel_mux,
		output reg load_ir, load_add_r, load_reg_y, load_reg_z,
		output [sel2_sz-1:0] bus2_sel_mux,
		output write,
		input [word_sz-1:0] instr,
		input zero,
		input clk, rst);

	wire [op_sz-1:0] opcode = instr[word_s-1:word_sz-op_sz];
	wire [src_sz-1:0] src = instr[src_sz + dst_sz - 1: dst_sz];
	wire [dst_sz-1:0] dst = instr[dst_sz-1:0];

	assign bus1_sel_mux = sel_r0 ? 0 :
				sel_r1 ? 1 :
				sel_r2 ? 2 :
				sel_r3 ? 3 :
				sel_pc ? 4 : {sel1_sz{'bx}};

	assign bus2_sel_mux = sel_alu ? 0 :
				sel_bus1 ? 1 :
				sel_mem ? 2: {sel2_sz{'bx}};

	always @(posedge clk or negedge rst) begin : state_transitions
		if (~rst)
			state <= S_idle;
		else
			state <= next_state;
	end

	always @(state or opcode or src or dst or zero) begin : output_and_next_state
		sel_r0 = 0; sel_r1 = 0; sel_r2 = 0; sel_r3 = 0; sel_pc = 0;
		load_r0 = 0; load_r1 = 0; load_r2 = 0; load_r3 = 0; load_pc = 0;

		load_ir = 0; load_add_r = 0; load_reg_y = 0; load_reg_z = 0;
		inc_pc = 0;
		bus1_sel = 0;
		sel_alu = 0;
		sel_mem = 0;
		write = 0;
		err_flag = 0;
		next_state = state;
		case (state)
			S_idle: next_state = S_fet1;
			S_fet1: begin
				next_state = S_fet2;
				sel_pc = 1;
				bus1_sel = 1;
				load_add_r = 1;
			end
			S_fet2: begin
				next_state = S_dec;
				sel_mem = 1;
				load_ir = 1;
				inc_pc = 1;
			end
			S_dec: case (opcode)
				op.NOP: next_state = S_fet1;

				op.ADD, op.SUB, op.AND: begin
					next_state = S_ex1;
					bus1_sel = 1;
					load_reg_y = 1;
					case (src)
						R0: sel_r0 = 1;
						R1: sel_r1 = 1;
						R2: sel_r2 = 1;
						R3: sel_r3 = 1;
						default err_flag = 1;
					endcase
					end /* op.ADD, op.SUB, op.AND */

				op.NOT: begin
					next_state = S_fet1;
					load_reg_z = 1;
					bus1_sel = 1;
					sel_alu = 1;
					case (src)
						R0: sel_r0 = 1;
						R1: sel_r1 = 1;
						R2: sel_r2 = 1;
						R3: sel_r3 = 1;
						default err_flag = 1;
					endcase
					case (dst)
						R0: load_r0 = 1;
						R1: load_r1 = 1;
						R2: load_r2 = 1;
						R3: load_r3 = 1;
						default err_flag = 1;
					endcase
				end /* op.NOT */

				op.RW: begin
					next_state = S_rd1;
					sel_pc = 1;
					bus1_sel = 1;
					load_add_r = 1;
				end

				op.WR: begin
					next_state = S_wr1;
					sel_pc = 1;
					bus1_sel = 1;
					load_add_r = 1;
				end

				op.BR: begin
					next_state = S_br1;
					sel_pc = 1;
					bus1_sel = 1;
					load_add_r = 1;
				end
				op.BRZ: if (zero) begin
					next_state = S_br1;
					sel_pc = 1;
					bus1_sel = 1;
					load_add_r = 1;
				end else begin
					next_state = S_fet1;
					inc_pc = 1;
				end
				default: next_state = S_halt;
			endcase /* opcode */
			
			S_ex1: begin
				next_state = S_fet1;
				load_reg_z = 1;
				sel_alu = 1;
				case (dst)
					R0: begin sel_r0 = 1; load_r0 = 1; end
					R1: begin sel_r1 = 1; load_r1 = 1; end
					R2: begin sel_r2 = 1; load_r2 = 1; end
					R3: begin sel_r3 = 1; load_r3 = 1; end
					default: err_flag = 1;
				endcase
			end

			S_rd1: begin
				next_sate = S_rd2;
				sel_mem = 1;
				load_add_r = 1;
				inc_pc = 1;
			end

			S_wr1: begin
				next_state = S_wr1;
				sel_mem = 1;
				load_add_r = 1;
				inc_pc = 1;
			end

			S_rd2: begin
				next_state = S_fet1;
				sel_mem = 1;
				case (dst)
					R0: load_r0 = 1;
					R1: load_r1 = 1;
					R2: load_r2 = 1;
					R3: load_r3 = 1;
					default: err_flag = 1;
				endcase
			end

			S_wr2: begin
				next_state = S_fet1;
				write = 1;
				case (src)
					R0: sel_r0 = 1;
					R1: sel_r1 = 1;
					R2: sel_r2 = 1;
					R3: sel_r3 = 1;
					default: err_flag = 1;
				endcase
			end

			S_br1: begin
				next_state = S_br2;
				sel_mem = 1;
				load_add_r = 1;
			end

			S_br2: begin
				next_state = S_fet1;
				sel_mem = 1;
				load_pc = 1;
			end

			S_halt: next_state = S_halt;

			default: next_state = S_idle;
		endcase /* state */
	end /* always @(state or opcode or src or dst or zero)  */
endmodule

module mem_unit #(parameter word_sz = 8, mem_sz = 256)
	(	output [word_sz-1:0] data_out,
		input [word_sz-1:0] data_in, address,
		input clk, write);

	reg [word_sz-1:0] mem[mem_sz-1:0];

	assign data_out = mem[address];

	always @(posedge clk)
		if (write)
			mem[address] <= data_in;
endmodule
