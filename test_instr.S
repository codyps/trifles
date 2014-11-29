.global test_instr
test_instr:
	/* sse4.1 */
	pmulld %xmm6, %xmm0
	/* sse4.2 */
	pcmpgtq %xmm6, %xmm0
	/* avx */
	vzeroall
	/* avx2 */
	vpermps %ymm0, %ymm1, %ymm2
	ret
