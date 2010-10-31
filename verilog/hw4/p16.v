/* HW4, Problem 16 */

module ct4(output reg [3:0] count, output reg carry_out, input enable_l, clk_l, reset, load, input [3:0] data);

	always @(negedge clk_l)
		if (reset) count <= 0;
		else if (load) count <= data;
		else if (!enable_l) count <= count + 1;

	always @(count)
		if (count == 'b1111) carry_out <= 1;
		else carry_out <= 0;
endmodule

module ct8(output [7:0] count, output carry_out, input enable_l, clk_l, reset, load, input [7:0] data);
	wire carry_out_inter;

	ct4 dev1(count[3:0], carry_out_inter, enable_l, clk_l          , reset, load, data[3:0]);
	ct4 dev2(count[7:4], carry_out      , enable_l, carry_out_inter, reset, load, data[7:4]);
endmodule

module tb_p16();
	reg enable_l, clk_l, reset, load;
	reg [7:0] data;
	wire [7:0] count;
	wire carry_out;

	ct4 dev1(count[3:0], carry_out, enable_l, clk_l    , reset, load, data[3:0]);
	ct4 dev2(count[7:4], _        , enable_l, carry_out, reset, load, data[7:4]);

	initial begin
		clk_l = 0;	
		forever #5 clk_l = ~clk_l;
	end

	initial begin
		enable_l = 1;
		reset = 0;
		load = 0;
		data = 200;
		reset = 1;
		#5 reset = 0;
		$dumpfile("p16.vcd");
		$dumpvars(0, tb_p16);
		fork
	
			#100 enable_l = 1;

			#120 load = 1;

			#130 load = 0;

			#150 enable_l = 0;

			#200 load = 1;

			#240 load = 0;
			
			#300 reset = 1;
			#320 reset = 0;
			#500 $finish;
		join
	end



endmodule
