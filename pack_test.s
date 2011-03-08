	.file	"pack_test.c"
.globl a
	.data
	.align 16
	.type	a, @object
	.size	a, 16
a:
	.byte	1
	.long	44
	.byte	2
	.long	34
	.long	3
	.zero	2
	.ident	"GCC: (Gentoo 4.4.4-r2 p1.2, pie-0.4.5) 4.4.4"
	.section	.note.GNU-stack,"",@progbits
