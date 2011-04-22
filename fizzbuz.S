s_fizz:
.asciz "fizz"

s_buzz:
.asciz "buzz"

s_num:
.asciz "%d\n"

main:
	mov 100, %ecx
_lp:
	mov 0, %edx

	mov %ecx, %eax
	div 3
	test %edx, 0

	jne _not_fizz

	//; indicate fizzness.	

_not_fizz:
	mov %ecx, %eax
	div 5 //; edx = mod, eax = div
	test %edx, 0

	jne _not_buzz

	//; if fizzy, then fizz.
	test? ??? ???
	j?? _buzz_not_fizz

	push s_fizz
	call puts

_buzz_not_fizz:
	//; always buzz.
	push s_buzz
	call puts

	//; ret
	mov 0, %eax
	ret

_not_buzz:
	//; if fizzy, then fizz.
	test? ??? ???
	j?? _no_nothing

	//; otherwise print num
_no_nothing:
	push s_num
	push %num_reg
	call printf

	//; ret
	mov 0, %eax
	ret

