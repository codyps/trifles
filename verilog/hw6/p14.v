
/* Problem # 14 */
/* 64k memory, 8 segments, 16 bit addr */
module segment_decode(output [$clog2(8)-1:0] seg, input [15:0]addr);
	assign seg = addr[15:15-$clog2(8)];
endmodule

module tb();
	wire [2:0] out;
	reg [15:0] addr;

	segment_decode dev(out, addr);

	integer i;
	initial begin
		for(i = 0; i < $cpow(2,16); i = i + 1) begin
			addr = i;
		end
	end
endmodule
