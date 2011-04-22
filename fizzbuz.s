	.file	"fizzbuz.c"
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"FizzBuzz"
.LC1:
	.string	"Fizz"
.LC2:
	.string	"Buzz"
.LC3:
	.string	"%d\n"
	.text
	.p2align 4,,15
.globl main
	.type	main, @function
main:
.LFB22:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	movl	$1431655766, %r12d
	.cfi_offset 12, -16
	pushq	%rbp
	.cfi_def_cfa_offset 24
	movl	$1717986919, %ebp
	.cfi_offset 6, -24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	xorl	%ebx, %ebx
	.cfi_offset 3, -32
	jmp	.L6
	.p2align 4,,10
	.p2align 3
.L11:
	testl	%esi, %esi
	je	.L2
	movl	$.LC0, %edi
	call	puts
.L3:
	incl	%ebx
	cmpl	$101, %ebx
	je	.L10
.L6:
	movl	%ebx, %eax
	xorl	%esi, %esi
	imull	%r12d
	movl	%ebx, %ecx
	movl	%ebx, %eax
	sarl	$31, %ecx
	subl	%ecx, %edx
	leal	(%rdx,%rdx,2), %edx
	cmpl	%edx, %ebx
	sete	%sil
	imull	%ebp
	xorl	%eax, %eax
	sarl	%edx
	subl	%ecx, %edx
	leal	(%rdx,%rdx,4), %edx
	cmpl	%edx, %ebx
	sete	%al
	testl	%eax, %eax
	jne	.L11
.L2:
	testl	%esi, %esi
	jne	.L12
	testl	%eax, %eax
	je	.L5
	movl	$.LC2, %edi
	incl	%ebx
	call	puts
	cmpl	$101, %ebx
	jne	.L6
.L10:
	xorl	%eax, %eax
	popq	%rbx
	popq	%rbp
	popq	%r12
	ret
	.p2align 4,,10
	.p2align 3
.L5:
	movl	%ebx, %edx
	movl	$.LC3, %esi
	movl	$1, %edi
	xorl	%eax, %eax
	call	__printf_chk
	jmp	.L3
	.p2align 4,,10
	.p2align 3
.L12:
	movl	$.LC1, %edi
	call	puts
	.p2align 4,,3
	jmp	.L3
	.cfi_endproc
.LFE22:
	.size	main, .-main
	.ident	"GCC: (Gentoo 4.4.3-r2 p1.2) 4.4.3"
	.section	.note.GNU-stack,"",@progbits
