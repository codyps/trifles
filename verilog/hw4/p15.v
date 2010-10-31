/* HW4, Problem 15 */

module ct4(output reg [3:0] count, input enable_l, clk_l, reset, load, input [3:0] data);

	always @(negedge clk_l)
		if (reset) count <= 0;
		else if (load) count <= data;
		else if (!enable_l) count <= count + 1;
endmodule

module tb_p15();
	reg enable_l, clk_l, reset, load;
	reg [3:0] data;
	wire [3:0] count;

	ct4 device(count, enable_l, clk_l, reset, load, data);

	initial begin
		clk_l = 0;	
		forever #5 clk_l = ~clk_l;
	end

	initial begin
		enable_l = 1;
		reset = 0;
		load = 0;
		data = 10;
		reset = 1;
		#5 reset = 0;
		$dumpfile("p15.vcd");
		$dumpvars(1, device);
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
