module reg_file #(parameter word_sz = 8, addr_sz = 5)
	(output [word_sz-1:0] do_1, do_2, input [word_sz-1:0]di,
		input [addr_sz-1:0] raddr_1, raddr_2, waddr,
		input wr_enable, clk);

	parameter reg_ct = 2**addr_sz;
	reg [word_sz-1:0] file [reg_ct-1:0];

	assign do_1 = file[raddr_1];
	assign do_2 = file[raddr_2];

	always @(posedge clk)
		if (wr_enable)
			file[waddr] <= di;
endmodule

module tb_reg_file();
	parameter word_sz = 8, addr_sz = 5;
	wire [word_sz-1:0] do_1, do_2;
	reg [word_sz-1:0] di;
	reg [addr_sz-1:0] raddr_1, raddr_2, waddr;
	reg wr_en, clk;

	reg_file #(word_sz, addr_sz) device (do_1, do_2, di, raddr_1, raddr_2,
		waddr, wr_en, clk);

	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end

	integer i;
	initial begin
		di = 'b0000_0001;
		wr_en = 1;
		waddr = 0;
		raddr_1 = 0;
		raddr_2 = {addr_sz{1'b1}};
		$dumpfile("p28_a.vcd");
		$dumpvars(0,tb_reg_file);
		for (i = 0; i < device.reg_ct; i = i + 1) begin
			@(negedge clk)
			di <= di + 1;
			waddr <= waddr + 1;
			raddr_1 <= raddr_1 + 1;
			raddr_2 <= raddr_2 + 1;
		end

		$finish();
	end

endmodule
