/* Need to:
 *  1. control dispensing units which blend coffee
 *	- We'll imagine the dispensing units are controlled by a group of
 *	pins, so to back those pins within the processor, we'll add an extra
 *	destination (may be more that 8bits, so hook into address).
 *	Essentially, we are defining an IO address space. (Really, it would be
 *	ideal to simply map the io space into the normal memory space, but the
 *	question calls for new instructions).
 *  2. accept currency and dispense change
 *  	- Really, it is the same deal all around.
 *  3. send messages to a display panel
 *  	- We define a continuous region in the io memory that is displayed to
 *  	the screen. As the screen is fixed in size, this space can also be
 *  	fixed.
 *
 * Items:
 *  Repurpose the RD and WR opcodes, make RD's src and WR's dest determine the 
 *     address space into which to write. essentially, we now have a IRD and
 *     IWR instruction to use.
 *		'b0? = mem
 * 	    	'b1? = io
 *   ctrl_unit needs to generate a io_write signal when we wish to write to
 *       io_space.
 *
 *   mux2 needs to be 1 wider to acomidate the new input. sel2 can stay @ sz
 *   	2.
 *
 */

module risc_spm #(parameter word_sz=8, sel1_sz=3, sel2_sz=2)
	(	input clk, rst);

	wire [sel1_sz-1:0]bus1_sel_mux;
	wire [sel2_sz-1:0]bus2_sel_mux;

	/* Data */
	wire zero;
	wire [word_sz-1:0] instr, addr, bus_1, mem_word, io_word;

	/* Control */
	wire load_r0, load_r1, load_r2, load_r3, load_pc, inc_pc, load_ir;
	wire load_add_r, load_reg_y, load_reg_z;
	wire write;
	wire io_write;


	proc_unit m0_proc(instr, zero, addr, bus_1, mem_word, io_word, 
		load_r0, load_r1,
		load_r2, load_r3, load_pc, inc_pc, bus1_sel_mux, bus2_sel_mux,
		load_ir, load_add_r, load_reg_y, load_reg_z, clk, rst);

	ctrl_unit m1_ctrl(load_r0, load_r1, load_r2, load_r3,
		load_pc, inc_pc, bus1_sel_mux, bus2_sel_mux,
		load_ir, load_add_r, load_reg_y, load_reg_z,
		write, io_write, instr, zero, clk, rst);

	mem_unit m2_mem(
		.data_out(mem_word),
		.data_in(bus_1),
		.address(addr),
		.clk(clk),
		.write(write)
	);

	/* Simulate the io space via a memory unit. */
	mem_unit #() m3_io_space (
		.data_out(io_word),
		.data_in(bus_1),
		.address(addr),
		.clk(clk),
		.write(io_write)
	);

endmodule

module proc_unit #(parameter word_sz=8, sel1_sz=3, sel2_sz=2, op_sz=4)
	(	output [word_sz-1:0] instr, 
		output flag_z, 
		output [word_sz-1:0] addr, bus_1,
		input [word_sz-1:0] mem_word, io_word,
		input load_r0, load_r1, load_r2, load_r3, load_pc, inc_pc,
		input [sel1_sz-1:0] bus1_sel_mux,
		input [sel2_sz-1:0] bus2_sel_mux,
		input load_ir, load_add_r, load_reg_y, load_reg_z,
		input clk, rst);


	wire [word_sz-1:0] bus_1, bus_2, out_r0, out_r1, out_r2, out_r3;
	wire [word_sz-1:0] pc_count, y_value, alu_out;

	wire alu_zero_flag;

	wire [op_sz-1:0] opcode = instr[word_sz-1:word_sz-op_sz];

	reg_unit #(word_sz)
		r0 (out_r0, bus_2, load_r0, clk, rst),
		r1 (out_r1, bus_2, load_r1, clk, rst),
		r2 (out_r2, bus_2, load_r2, clk, rst),
		r3 (out_r3, bus_2, load_r3, clk, rst);

	reg_unit #(word_sz) reg_y (y_value, bus_2, load_reg_y, clk, rst);

	reg_unit #(1) reg_z(flag_z, alu_zero_flag, load_reg_z, clk, rst);

	/* address register */
	reg_unit #(word_sz) add_r(addr, bus_2, load_add_r, clk, rst);

	reg_unit #(word_sz) instr_reg(instr, bus_2, load_ir, clk, rst);

	prgm_cnt  pc(pc_count, bus_2, load_pc, inc_pc, clk, rst);

	mux_5ch   mux_1(bus_1, out_r0, out_r1, out_r2, out_r3, pc_count, bus1_sel_mux);
	mux_4ch   mux_2(bus_2, alu_out, bus_1, mem_word, io_word, bus2_sel_mux);

	alu_risc alu(alu_zero_flag, alu_out, y_value, bus_1, opcode);

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

	/* src field */
	localparam IO = 2'b1x;
	localparam MEM = 2'b0x;
endmodule

module mux_gen #(parameter word_sz=8, channels=3)
	(	output [word_sz-1:0] out,
		input [(word_sz * channels) - 1:0] in,
		input [$clog2(channels)-1:0] sel);

	wire [word_sz-1:0] in_arr [channels-1:0];

	assign out = in_arr[sel];

	generate
		genvar i;
		for(i = 0; i < channels; i = i + 1) begin
			assign in_arr[i] = in[(i * word_sz) +: word_sz];
		end
	endgenerate
endmodule

/* changed to 4 ch */
module mux_4ch #(parameter word_sz=8)
	(	output [word_sz-1:0] mux_out,
		input [word_sz-1:0] data_a, data_b, data_c, data_d,
		input [1:0]sel);
	assign mux_out = (sel == 0) ? data_a :
			 (sel == 1) ? data_b :
			 (sel == 3) ? data_c :
			 (sel == 4) ? data_d : 'bx;

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

module ctrl_unit #(parameter word_sz=8, op_sz=4, state_sz=4, src_sz=2,
			dst_sz=2, sel1_sz=3, sel2_sz=2)
	(	output reg load_r0, load_r1, load_r2, load_r3, load_pc,
				inc_pc,
		output [sel1_sz-1:0] bus1_sel_mux,
		output [sel2_sz-1:0] bus2_sel_mux,
		output reg load_ir, load_add_r, load_reg_y, load_reg_z,
		output reg write, io_write,
		input [word_sz-1:0] instr,
		input zero,
		input clk, rst);

	localparam S_idle = 0;
	localparam S_fet1 = 1;
	localparam S_fet2 = 2;
	localparam S_dec = 3;
	localparam S_ex1 = 4;
	localparam S_rd1 = 5;
	localparam S_rd2 = 6;
	localparam S_wr1 = 7;
	localparam S_wr2 = 8;
	localparam S_br1 = 9;
	localparam S_br2 = 10;
	localparam S_halt = 11;

	localparam R0 = 0;
	localparam R1 = 1;
	localparam R2 = 2;
	localparam R3 = 3;

	wire [op_sz-1:0] opcode = instr[word_sz-1:word_sz-op_sz];
	wire [src_sz-1:0] src = instr[src_sz + dst_sz - 1: dst_sz];
	wire [dst_sz-1:0] dst = instr[dst_sz-1:0];

	reg [state_sz-1:0] state, next_state;

	reg sel_r0, sel_r1, sel_r2, sel_r3, sel_pc;
	reg sel_alu, sel_mem, bus1_sel, sel_io;
	
	reg err_flag;

	assign bus1_sel_mux = sel_r0 ? 0 :
				sel_r1 ? 1 :
				sel_r2 ? 2 :
				sel_r3 ? 3 :
				sel_pc ? 4 : 3'bx;

	assign bus2_sel_mux = sel_alu ? 0 :
				bus1_sel ? 1 :
				sel_mem ? 2 :
				sel_io ? 3: 2'bx;

	always @(posedge clk or negedge rst) begin : state_transitions
		if (~rst)
			state <= S_idle;
		else
			state <= next_state;
	end

	always @(state or opcode or src or dst or zero) 
		begin : output_and_next_state
		sel_r0 = 0; sel_r1 = 0; sel_r2 = 0; sel_r3 = 0; sel_pc = 0;
		load_r0 = 0; load_r1 = 0; load_r2 = 0; load_r3 = 0; load_pc = 0;

		load_ir = 0; load_add_r = 0; load_reg_y = 0; load_reg_z = 0;
		inc_pc = 0;
		bus1_sel = 0;
		sel_alu = 0;
		sel_mem = 0;
		sel_io = 0;
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

				op.RD: begin
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
				next_state = S_rd2;
				/* ADDED */
				casex (src)
					op.IO: sel_io = 1;
					op.MEM: sel_mem = 1;
				endcase
				load_add_r = 1;
				inc_pc = 1;
			end

			S_wr1: begin
				next_state = S_wr2;
				/* ADDED */
				casex (src)
					op.IO: sel_io = 1;
					op.MEM: sel_mem = 1;
				endcase
				load_add_r = 1;
				inc_pc = 1;
			end

			S_rd2: begin
				next_state = S_fet1;
				/* ADDED */
				casex (src)
					op.IO: sel_io = 1;
					op.MEM: sel_mem = 1;
				endcase
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
				/* ADDED */
				casex (src)
					op.IO: io_write = 1;
					op.MEM: write = 1;
				endcase
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

module clock_unit(output reg clk);

	initial begin
		clk = 0;
		#10
		forever #10 clk = ~clk;
	end

endmodule

module test_risk_spm();
	reg rst;
	wire clk;
	parameter word_sz = 8;
	reg [8:0] k;

	clock_unit m1(clk);
	risc_spm m2(clk, rst);

	initial #2800 $finish;

	task load;
		input [7:0] addr;
		input [7:0] instr;
		begin
			m2.m2_mem.mem[addr] = instr;
		end
	endtask

	initial begin
		$dumpfile("risc_spm.vcd");
		$dumpvars(0, m2);
	end

	initial begin : flush_mem
		#2 rst = 0;
		for (k = 0; k <= 255; k = k + 1)
			load(k, 0);
		#10 rst = 1;
	end

	initial begin : load_prgm
		load(0,  8'b0000_00_00);
		load(1,  8'b0101_00_10);
		load(2,  130);
		load(3,  8'b0101_00_11);
		load(4,  131);
		load(5,  8'b0101_00_01);
		load(6,  128);
		load(7,  8'b0101_00_00);
		load(8,  129);
		load(9,  8'b0010_00_01);
		load(10, 8'b1000_00_00);
		load(11, 134);
		load(12, 8'b0001_10_11);
		load(13, 8'b0111_00_11);
		load(14, 140);

		load(128, 6);
		load(129, 1);
		load(130, 2);
		load(131, 0);
		load(134, 139);
		load(139, 8'b1111_00_00);
		load(140, 9);
	end
endmodule

