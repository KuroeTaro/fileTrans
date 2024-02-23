	.data

	.global prompt
	.global dividend
	.global divisor
	.global quotient
	.global remainder

prompt:		.string "Your prompts are placed here ", 0
dividend: 	.string "Place holder string for your dividend ", 0
divisor:  	.string "Place holder string for your divisor ", 0
quotient:	.string "Your quotient is stored here ", 0
remainder:	.string "Your remainder is stored here ", 0

promptLog:		.string "Press space to calculate another div and mod, or press enter to quit.", 0
dividendLog: 	.string "Please type in your dividend: ", 0
divisorLog:  	.string "Please type in your divisor: ", 0
quotientLog:	.string "This is your quotient: ", 0
remainderLOg:	.string "This is your remainder: ", 0
quitLog:	.string "Program exited", 0

	.text

	.global lab3
U0FR: 	.equ 0x18	; UART0 Flag Register

ptr_to_prompt:			.word prompt
ptr_to_dividend:		.word dividend
ptr_to_divisor:		.word divisor
ptr_to_quotient:		.word quotient
ptr_to_remainder:		.word remainder

ptr_to_promptLog:			.word promptLog
ptr_to_dividendLog:		.word dividendLog
ptr_to_divisorLog:		.word divisorLog
ptr_to_quotientLog:		.word quotientLog
ptr_to_remainderLog:		.word remainderLOg
ptr_to_quitLog:		.word quitLog


lab3:
		PUSH {r4-r12,lr} 	; Store any registers in the range of r4 through r12
								; that are used in your routine.  Include lr if this
								; routine calls another routine.
		ldr r4, ptr_to_prompt
		ldr r5, ptr_to_dividend
		ldr r6, ptr_to_divisor
		ldr r7, ptr_to_quotient
		ldr r8, ptr_to_remainder

		; Your code is placed here.  This is your main routine for
		; Lab #3.  This should call your other routines such as
		; uart_init, read_string, output_string, int2string, &
		; string2int

	BL uart_init

restart:

	MOV r0,#0
	MOV r1,#0
	MOV r2,#0
	MOV r3,#0

	;print Place holder string for your dividend.
	ldr r0, ptr_to_dividendLog
	BL output_string

	;print dividend
	MOV r2, r5
	BL read_string
	BL output_string
	BL string2int
	MOV r9, r0

	;change line
	MOV r0, #10
	BL output_character
	MOV r0, #13
	BL output_character

	;print Place holder string for your divisor.
	ldr r0, ptr_to_divisorLog
	BL output_string

	;print divisor
	MOV r2, r6
	BL read_string
	BL output_string
	BL string2int
	MOV r10, r0

	;change line
	MOV r0, #10
	BL output_character
	MOV r0, #13
	BL output_character

	;div and mod
	MOV r0, r9
	MOV r1, r10
	BL div_and_mod
	MOV r9, r0
	MOV r10, r1

	;print Place holder string for your quotient.
	ldr r0, ptr_to_quotientLog
	BL output_string
	MOV r1, r9
	MOV r2, r7
	BL int2string
	MOV r0, r7
	BL output_string

	;change line
	MOV r0, #10
	BL output_character
	MOV r0, #13
	BL output_character

	;print Place holder string for your remainder.
	ldr r0, ptr_to_remainderLog
	BL output_string
	MOV r1, r10
	MOV r2, r8
	BL int2string
	MOV r0, r8
	BL output_string

	;change line
	MOV r0, #10
	BL output_character
	MOV r0, #13
	BL output_character

	ldr r0, ptr_to_promptLog
	BL output_string

	;change line
	MOV r0, #10
	BL output_character
	MOV r0, #13
	BL output_character

	BL read_character
	CMP r0, #0x20
	BEQ restart
	CMP r0, #0x0D
	BEQ lab3_end

lab3_end:

	POP {r4-r12,lr}   ; Restore registers all registers preserved in the
							; PUSH at the top of this routine from the stack.

	;change line
	MOV r0, #10
	BL output_character
	MOV r0, #13
	BL output_character

	ldr r0, ptr_to_quitLog
	BL output_string

	;change line
	MOV r0, #10
	BL output_character
	MOV r0, #13
	BL output_character

	mov pc, lr


uart_init:
	PUSH {r4-r12,lr} 	; Store any registers in the range of r4 through r12
							; that are used in your routine.  Include lr if this
							; routine calls another routine.

		; Your code for your uart_init routine is placed here
		MOV r1, #0xE618
		MOVT r1, #0x400F
		MOV r0, #1
		STR r0, [r1, #0]
		MOV r1, #0xE608
		MOVT r1, #0x400F
		MOV r0, #1
		STR r0, [r1, #0]
		MOV r1, #0xC030
		MOVT r1, #0x4000
		MOV r0, #0
		STR r0, [r1, #0]
		MOV r1, #0xC024
		MOVT r1, #0x4000
		MOV r0, #8
		STR r0, [r1, #0]
		MOV r1, #0xC028
		MOVT r1, #0x4000
		MOV r0, #44
		STR r0, [r1, #0]
		MOV r1, #0xCFC8
		MOVT r1, #0x4000
		MOV r0, #0
		STR r0, [r1, #0]
		MOV r1, #0xC02C
		MOVT r1, #0x4000
		MOV r0, #0x60
		STR r0, [r1, #0]
		MOV r1, #0xC030
		MOVT r1, #0x4000
		MOV r0, #0x301
		STR r0, [r1, #0]

		MOV r1, #0x451C
		MOVT r1, #0x4000
		LDR r0, [r1, #0]
		ORR r0, r0, #0x03
		STR r0, [r1, #0]
		MOV r1, #0x4420
		MOVT r1, #0x4000
		LDR r0, [r1, #0]
		ORR r0, r0, #0x03
		STR r0, [r1, #0]
		MOV r1, #0x452C
		MOVT r1, #0x4000
		LDR r0, [r1, #0]
		ORR r0, r0, #0x11
		STR r0, [r1, #0]

	POP {r4-r12,lr}   ; Restore registers all registers preserved in the
							; PUSH at the top of this routine from the stack.
	mov pc, lr


read_character:
	PUSH {r4-r12,lr} 	; Store any registers in the range of r4 through r12
							; that are used in your routine.  Include lr if this
							; routine calls another routine.

		; Your code for your read_character routine is placed here

	MOV r1, #0xC018
	MOVT r1, #0x4000
RCVLOOP:
	MOV r3, #0x10
	LDRB r2, [r1, #0]
	AND r3, r3, r2
	CMP r3, #0x10
	BEQ RCVLOOP
	MOV r1, #0xC000
	MOVT r1, #0x4000
	LDRB r0, [r1, #0]

	POP {r4-r12,lr}   ; Restore registers all registers preserved in the
							; PUSH at the top of this routine from the stack.
	mov pc, lr


read_string:
	PUSH {r4-r12,lr} 	; Store any registers in the range of r4 through r12
							; that are used in your routine.  Include lr if this
							; routine calls another routine.

		; Your code for your read_string routine is placed here
	MOV r4, r2
	MOV r5, #0
RSVLOOP:
	BL read_character
	STRB r0, [r4, r5]
	ADD r5, r5, #1
	CMP r0, #0x0D
	BNE RSVLOOP
	MOV r0, #0
	SUB r5, r5, #1
	STRB r0, [r4, r5]
	MOV r0, r4

	POP {r4-r12,lr}   ; Restore registers all registers preserved in the
							; PUSH at the top of this routine from the stack.
	mov pc, lr


output_character:
	PUSH {r4-r12,lr} 	; Store any registers in the range of r4 through r12
							; that are used in your routine.  Include lr if this
							; routine calls another routine.

		; Your code for your output_character routine is placed here

	MOV r1, #0xC018
	MOVT r1, #0x4000
TSMTLOOP:
	MOV r3, #0x20
	LDRB r2, [r1, #0]
	AND r3, r3, r2
	CMP r3, #0x20
	BEQ TSMTLOOP
	MOV r1, #0xC000
	MOVT r1, #0x4000
	STRB r0, [r1, #0]

	POP {r4-r12,lr}   ; Restore registers all registers preserved in the
							; PUSH at the top of this routine from the stack.
	mov pc, lr


output_string:
	PUSH {r4-r12,lr} 	; Store any registers in the range of r4 through r12
							; that are used in your routine.  Include lr if this
							; routine calls another routine.

		; Your code for your output_string routine is placed here

	MOV r4, r0
	MOV r5, #0
OPSLOOP:
	LDRB r0, [r4, r5]
	ADD r5, r5, #1
	CMP r0, #0x00
	BEQ BREAKOPSLOOP
	BL output_character
	B OPSLOOP
BREAKOPSLOOP:
	MOV r0, r4

	POP {r4-r12,lr}   ; Restore registers all registers preserved in the
							; PUSH at the top of this routine from the stack.
	mov pc, lr


int2string:
	PUSH {r4-r12,lr} 	; Store any registers in the range of r4 through r12
							; that are used in your routine.  Include lr if this
							; routine calls another routine.

		; Your code for your int2string routine is placed here
	MOV r5, r1 ;store dividend
	MOV r6, #10 ;stroe divisor
	MOV r7, #0 ;store quotient
	MOV r8, #0 ;store remain
	MOV r4, r2 ;store address to assign
	MOV r9, #0 ;store address offset

	MOV r0, r5 ; pre setup for div_and_mod
	MOV r1, r6
	CMP r0, #0
	BGE length_test_loop
	RSB r0, r0, #0
	ADD r9, r9, #1
	B length_test_loop

length_test_loop:
	BL div_and_mod
	MOV r1, r6
	ADD r9, r9, #1
	CMP r0, #0
	BEQ to_int_branch
	B length_test_loop

to_int_branch:
	MOV r0, r5 ; pre setup for div_and_mod
	MOV r1, r6
	MOV r10, #0x00
	STRB r10, [r4, r9]
	SUB r9, r9, #1
	CMP r5, #0
	BGE pos_to_int_loop
	RSB r0, r5, #0
	B neg_to_int_loop

pos_to_int_loop:
	BL div_and_mod
	ADD r1, r1, #0x30
	STRB r1, [r4, r9]
	MOV r1, r6
	CMP r9, #0
	BEQ pos_break_to_int_loop
	SUB r9, r9, #1
	B pos_to_int_loop

neg_to_int_loop:
	BL div_and_mod
	ADD r1, r1, #0x30
	STRB r1, [r4, r9]
	MOV r1, r6
	CMP r9, #0
	BEQ neg_break_to_int_loop
	SUB r9, r9, #1
	B neg_to_int_loop

pos_break_to_int_loop:
	MOV r0, r4
	b toStringEnd

neg_break_to_int_loop:
	MOV r0, #45
	STRB r0, [r4, #0]
	MOV r0, r4
	b toStringEnd

toStringEnd:

	POP {r4-r12,lr}   ; Restore registers all registers preserved in the
							; PUSH at the top of this routine from the stack.
	mov pc, lr


string2int:
	PUSH {r4-r12,lr} 	; Store any registers in the range of r4 through r12
							; that are used in your routine.  Include lr if this
							; routine calls another routine.

		; Your code for your string2int routine is placed here
	MOV r4, r0
	MOV r0, #0
	MOV r5, #0
	MOV r6, #1
	MOV r7, #0
	MOV r8, #10

	LDRB r7, [r4, r5]
	CMP r7, #45
	BNE pos_length_count_loop
	B neg_length_count_loop

pos_length_count_loop:
	LDRB r7, [r4, r5]
	CMP r7, #0x00
	BEQ pos_int_calu_loop
	ADD r5, r5, #1
	B pos_length_count_loop

pos_int_calu_loop:
	SUB r5, r5, #1
	LDRB r7, [r4, r5]
	SUB r7, r7, #0x30
	MUL r7, r7, r6
	MUL r6, r6, r8
	ADD r0, r0, r7
	CMP r5, #0x00
	BEQ break_int_calu_loop
	B pos_int_calu_loop

neg_length_count_loop:
	LDRB r7, [r4, r5]
	CMP r7, #0x00
	BEQ neg_int_calu_loop
	ADD r5, r5, #1
	B neg_length_count_loop

neg_int_calu_loop:
	SUB r5, r5, #1
	LDRB r7, [r4, r5]
	SUB r7, r7, #0x30
	MUL r7, r7, r6
	MUL r6, r6, r8
	SUB r0, r0, r7
	CMP r5, #0x01
	BEQ break_int_calu_loop
	B neg_int_calu_loop

break_int_calu_loop:

	POP {r4-r12,lr}   ; Restore registers all registers preserved in the
							; PUSH at the top of this routine from the stack.
	mov pc, lr


div_and_mod:
	PUSH {r4-r12,lr} 	; Store any registers in the range of r4 through r12
							; that are used in your routine.  Include lr if this
							; routine calls another routine.

		; Your code for your div_and_mod routine is placed here
	MOV r2, #0
	CMP r0, #0
	BGT GREATER
	BLT LESS
	B R1IS0
GREATER:
	CMP r1, #0
	BGT PPBRC
	BLT PNBRC
LESS:
	CMP r1, #0
	BGT NPBRC
	BLT NNBRC
R1IS0:
	MOV r0, #0
	MOV r1, #0
	B RES

PPBRC:
PPLOOP:
	CMP r0, r1
	BLT PPRES
	SUB r0, r0, r1
	ADD r2, r2, #1
	B PPLOOP
PPRES:
	MOV r1, r0
	MOV r0, r2
	B RES

PNBRC:
	RSB r1, r1, #0
PNLOOP:
	CMP r0, r1
	BLT PNRES
	SUB r0, r0, r1
	ADD r2, r2, #1
	B PNLOOP
PNRES:
	MOV r1, r0
	RSB r0, r2, #0
	B RES

NPBRC:
	RSB r0, r0, #0
NPLOOP:
	CMP r0, #0
	BLE NPRES
	SUB r0, r0, r1
	ADD r2, r2, #1
	B NPLOOP
NPRES:
	RSB r1, r0, #0
	RSB r0, r2, #0
	B RES

NNBRC:
NNLOOP:
	CMP r0, #0
	BGE NNRES
	SUB r0, r0, r1
	ADD r2, r2, #1
	B NNLOOP
NNRES:
	MOV r1, r0
	MOV r0, r2
	B RES

RES:
	MOV r2, #0

	POP {r4-r12,lr}   ; Restore registers all registers preserved in the
							; PUSH at the top of this routine from the stack.
	mov pc, lr

	.end
