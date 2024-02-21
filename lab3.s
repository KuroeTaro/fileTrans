	.data

	.global prompt
	.global dividend
	.global divisor
	.global quotient
	.global remainder

prompt:		.string "Your prompts are placed here", 0
dividend: 	.string "Place holder string for your dividend", 0
divisor:  	.string "Place holder string for your divisor", 0
quotient:	.string "Your quotient is stored here", 0
remainder:	.string "Your remainder is stored here", 0


	.text

	.global lab3
U0FR: 	.equ 0x18	; UART0 Flag Register

ptr_to_prompt:			.word prompt
ptr_to_dividend:		.word dividend
ptr_to_divisor:		.word divisor
ptr_to_quotient:		.word quotient
ptr_to_remainder:		.word remainder

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
	BL read_string
	BL string2int

lab3_end:

	POP {r4-r12,lr}   ; Restore registers all registers preserved in the
							; PUSH at the top of this routine from the stack.
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
	MOV r4, #0x0000
	MOVT r4, #0x2000
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
	MOV r0, #0x0000
	MOVT r0, #0x2000

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
length_count_loop:
	LDRB r7, [r4, r5]
	CMP r7, #0x00
	BEQ int_calu_loop
	ADD r5, r5, #1
	B length_count_loop
int_calu_loop:
	SUB r5, r5, #1
	LDRB r7, [r4, r5]
	SUB r7, r7, #0x30
	MUL r7, r7, r6
	MUL r6, r6, r8
	ADD r0, r0, r7
	CMP r5, #0x00
	BEQ break_int_calu_loop
	B int_calu_loop
break_int_calu_loop:

	POP {r4-r12,lr}   ; Restore registers all registers preserved in the
							; PUSH at the top of this routine from the stack.
	mov pc, lr


div_and_mod:
	PUSH {r4-r12,lr} 	; Store any registers in the range of r4 through r12
							; that are used in your routine.  Include lr if this
							; routine calls another routine.

		; Your code for your div_and_mod routine is placed here
	PUSH {r4-r12,lr}	; Store registers r4 through r12 and lr on the
				; stack. Do NOT modify this line of code.  It
    			      	; ensures that the return address is preserved
 		            	; so that a proper return to the C wrapped can be
			      	; executed.

	; Your code for the div_and_mod routine goes here.
	MOV r2, #0
	MOV r3, r0
	MOV r4, r1

	CMP r3, #0
	BNE JUMP_TO_NEXT1

	MOV r0, #0
	MOV r1, #0
	B EXIT

JUMP_TO_NEXT1:
	CMP r3, #0
	BGT POSITIVE_DIVIDEND

	CMP r4, #0
	BGT POSITIVE_DISVOR

LOOP3: ; r0 < 0, r1 < 0
	SUB r3, r3, r4 ; subtrct r5 by r3
	ADD r2, r2, #1 ; increase r4 by 1
	CMP r3, #0 ;
	BLT LOOP3 ; if r5 >= r3, iterate again
					 ; if not, jump out of loop
	RSB r2, r2, #0
	MOV r0, r2
	MOV r1, r3

	B EXIT

POSITIVE_DISVOR:
	; r0 < 0, r1 > 0
LOOP2:
	ADD r3, r3, r4 ; subtract r5 by r3
	ADD r2, r2, #1 ; increase r4 by 1
	CMP r3, #0 ;
	BGE JUMPOUT2 ;
	CMP r3, r4 ;
	BLE LOOP2 ; if r5 >= r3, iterate again
					 ; if not, jump out of loop
JUMPOUT2:
	RSB r2, r2, #0
	MOV r0, r2
	MOV r1, r3

	B EXIT

POSITIVE_DIVIDEND:
	CMP r4, #0
	BGT BOTH_POSITIVE
	; r0 > 0, r1 < 0

LOOP1:
	ADD r3, r3, r4 ; subtract r5 by r3
	CMP r3, #0 ;
	BLE JUMPOUT1
	ADD r2, r2, #1 ; increase r4 by 1
	CMP r3, r4 ;
	BGE LOOP1 ; if r5 >= r3, iterate again
					 ; if not, jump out of loop
JUMPOUT1:
	RSB r0, r2, #0
	SUB r3, r3, r4
	MOV r1, r3

	B EXIT

BOTH_POSITIVE:
	; r0 > 0, r1 > 0
LOOP:
	SUB r3, r3, r4 ; subtract r5 by r3
	ADD r2, r2, #1 ; increase r4 by 1
	CMP r3, r4 ;
	BGE LOOP ; if r5 >= r3, iterate again
					 ; if not, jump out of loop

	MOV r1, r3
	MOV r0, r2 ; store r4 to r0

	B EXIT

EXIT:

	POP {r4-r12,lr}   ; Restore registers all registers preserved in the
							; PUSH at the top of this routine from the stack.
	mov pc, lr

	.end
