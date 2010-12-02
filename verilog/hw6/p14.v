
/* Problem # 14 */
/* 64k memory, 8 segments, 16 bit addr */
module segment_decode(output reg [log2(8)-1:0] seg, input [15:0]addr);
	assign seg = addr[15:15-log2(8)];
endmodule

