/* HW1 P11 & P12 */

`include "p11_12.v"

module a16_test();
	/* as we can assume that the 4bit adder was succesfully tested, our
	 * goal here is simply to cause the carry interconects (of which there
	 * are 4) to triger in all possible arrangments (16)
	 */

	wire [15:0] Y;
	wire Cout;
	reg [3:0] ra3, ra2, ra1, ra0;
	reg [3:0] rb3, rb2, rb1, rb0;
	reg Cin;

	r16_adder device(Y, Cout, {ra3, ra2, ra1, ra0}, {rb3, rb2, rb1, rb0}, Cin);

	integer ct;

	initial begin
		{ ra3, ra2, ra1, ra0 } = 'heeee;
		{ rb3, rb2, rb1, rb0 } = 'h0000;

		$dumpfile("test_16.vcd");
		$dumpvars(1, device);
		for (ct = 0; ct <= 'b11111; ct = ct + 1) begin
			#10 { Cin, ra3[0], ra2[0], ra1[0], ra0[0] } = ct;
		end
	end
endmodule
