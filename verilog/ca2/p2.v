/* Basic Gates */
module or2(output Z, input A, B);
	wire i;
	not(Z, i);
	nor(i, A, B);
endmodule

module or4(output Z, input A, B, C, D);
	wire [1:0]i;
	or2 o0(i[0], A, B),
	    o1(i[1], C, D),
	    o2(Z, i[0], i[1]);
endmodule

module and2(output Z, input A, B);
	nand(nz, A, B);
	not(Z, nz);
endmodule

module and3(output Z, input A, B, C);
	wire i;
	and2 a0(i, A, B),
		a1(Z, i, C);

endmodule

module xnor2(output Z, input A, B);
	wire [1:0]i;
	
	not(na, A);
	not(nb, B);
	and2 a0(i[0], A, B),
	     a1(i[1], na, nb);
     	or2  o0(Z, i[0], i[1]);
endmodule

module xor2(output Z, input A, B);
	wire [1:0]i;
	
	not (na, A);
	not (nb, B);
	and2 a0(i[0], A, nb),
	     a1(i[1], na, B);

	or2  o0(Z, i[0], i[1]);
endmodule

/* ALU OP Codes */
module op_00(output Z, input A, B);
	or2 o(Z, A, B);
endmodule

module op_01(output Z, input A, B);
	xor2 x(Z, A, B);
endmodule

module op_10(output Z, input A, B, C);
	wire i;
	xnor2 x(i, B, C);
	and2  a(Z, i, A);
endmodule

module op_11(output Z, input A, B, C);
	wire i;
	xor2 x(i, A, B);
	nand n(Z, i, C);
endmodule

/* Mux (4) */
module mux_4_1(output Z, input [1:0] sel, input [3:0] i);
	wire [1:0]n_s;
	wire [3:0]a;
	not(n_s[0], sel[0]);
	not(n_s[1], sel[1]);

	and3 a0(a[0], n_s[1], n_s[0], i[0]),
	     a1(a[1], n_s[1], sel[0], i[1]),
	     a2(a[2], sel[1], n_s[0], i[2]),
	     a3(a[3], sel[1], sel[0], i[3]);

	or4 o0(Z, a[0], a[1], a[2], a[3]);
endmodule

/* ALUs */
module alu_01(output Z, input [1:0]op, input A, B, C);
	wire [3:0]op_z;

	op_00 op00(op_z[0], A, B);
	op_01 op01(op_z[1], A, B);
	op_10 op10(op_z[2], A, B, C);
	op_11 op11(op_z[3], A, B, C);

	mux_4_1 mux(Z, op, op_z);
endmodule

module alu_02(output [1:0]Z, input [1:0]op, input [1:0] A, B, C);
	alu_01 a0(Z[0], op, A[0], B[0], C[0]),
	       a1(Z[1], op, A[1], B[1], C[1]);
endmodule

module alu_04(output [3:0]Z, input [1:0]op, input [3:0] A, B, C);
	alu_02 a0(Z[1:0], op, A[1:0], B[1:0], C[1:0]),
		a1(Z[3:2], op, A[3:2], B[3:2], C[3:2]);
endmodule

module alu_08(output [7:0]Z, input [1:0]op, input [7:0] A, B, C);
	alu_04 a0(Z[3:0], op, A[3:0], B[3:0], C[3:0]),
		a1(Z[7:4], op, A[7:4], B[7:4], C[7:4]);
endmodule

module alu_16(output [15:0]Z, input [1:0]op, input [15:0] A, B, C);
	alu_08 a0(Z[7:0], op, A[7:0], B[7:0], C[7:0]),
		a1(Z[15:8], op, A[15:8], B[15:8], C[15:8]);
endmodule

module alu_32(output [31:0]Z, input [1:0]op, input [31:0] A, B, C);
	alu_16 a0(Z[15:0], op, A[15:0], B[15:0], C[15:0]),
		a1(Z[31:16], op, A[31:16], B[31:16], C[31:16]);
endmodule

/* Testbench */

module p2_tb();
	reg [31:0]A, B, C;
	reg [1:0]op;

	wire [31:0] Z;

	alu_32 device(Z, op, A, B, C);

	integer op_i, val_i;
	initial begin
		$dumpfile("p2.vcd");
		$dumpvars(0, device);
		$monitor("op(%b) A=%b B=%b C=%b => %b", op, A, B, C, Z); 
		for( op_i = 0; op_i <= 'b11; op_i = op_i + 1) begin
			op = op_i[1:0];
			for(val_i = 0; val_i <= 'b111; val_i = val_i + 1) begin
				A = {32{val_i[2]}};
				B = {32{val_i[1]}};
				C = {32{val_i[0]}};
				#10;
			end
		end
	end

endmodule
