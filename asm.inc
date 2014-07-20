; .global?
; .cfi_startproc / .cfi_endproc
; .def .scl .type .endef? (see COFF spec)

.macro FUNC_START name
	.type \name, @function
	\name :
.endm

.macro FUNC_END name
	.size \name, .-\name
.endm

; For ARM:
;
; .syntax unified
; .text

; .thumb
