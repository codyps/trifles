module clk_gen #(parameter latency = 100, offset = 50, pulse_width = 50)
	(output reg clk, input rst_l, en);
	
	initial begin
		clk = 0;
		forever begin
			wait(en == 1);
			clk = 0;
			#latency;
			while (rst_l == 1) begin
				#offset;
				wait(en == 1);
				clk = 0;
				#pulse_width;
				wait(en == 1);
				clk = 1;
			end
		end
	end
endmodule

module tb_clk();
	reg rst_l, en;
	wire clk;
	clk_gen #( .latency(10), .offset(5), .pulse_width(5) )
		dev(clk, rst_l, en);

	initial begin
		en = 0;
		rst_l = 0;
		$dumpfile("p33.vcd");
		$dumpvars(0, dev);
		fork 
			#10 rst_l = 1;
			#50 en = 1;
			#300 $finish();
		join
	end

endmodule
