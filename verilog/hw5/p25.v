

module ct25(output reg [7:0] ct, input clk, reset_l);
	reg [4:0] state;

	always @(state)
		case (state - 1)
		//0: ct <= 'b0000_0001;
		//1: ct <= 'b0000_0001;
		//2: ct <= 'b0000_0001;
		3: ct <= 'b0000_0010;
		4: ct <= 'b0000_0100;
		5: ct <= 'b0000_1000;
		6: ct <= 'b0001_0000;
		7: ct <= 'b0010_0000;
		8: ct <= 'b0100_0000;
		9: ct <= 'b1000_0000;
		10:ct <= 'b0100_0000;
		11:ct <= 'b0010_0000;
		12:ct <= 'b0001_0000;
		13:ct <= 'b0000_1000;
		14:ct <= 'b0000_0100;
		15:ct <= 'b0000_0010;
		//16:ct <= 'b0000_0001;
		//17:ct <= 'b0000_0001;
		
		default:
			ct <= 'b0000_0001;
		endcase

	always @(posedge clk)
		if(reset_l == 0)
			state <= 0;
		else
			state <= (state + 1) % 18;
endmodule

module tb_25();
	wire [7:0] ct;
	reg clk, reset_l;

	ct25 device(ct, clk, reset_l);

	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end

	initial begin
		reset_l = 0;
		$dumpfile("p25.vcd");
		$dumpvars(0,tb_25);
		fork
			#25 reset_l = 1;
			#300 $finish();
		join
	end
endmodule
