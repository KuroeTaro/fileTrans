	.data

	.global prompt
	.global mydata

prompt:	.string "Your prompt with instructions is place here", 0
mydata:	.byte	0x20	; This is where you can store data.
			; The .byte assembler directive stores a byte
			; (initialized to 0x20) at the label mydata.
			; Halfwords & Words can be stored using the
			; directives .half & .word

	.text

	.global uart_interrupt_init
	.global gpio_interrupt_init
	.global UART0_Handler
	.global Switch_Handler
	.global Timer_Handler			; This is needed for Lab #6
	.global simple_read_character
	.global output_character		; This is from your Lab #4 Library
	.global read_string				; This is from your Lab #4 Library
	.global output_string			; This is from your Lab #4 Library
	.global uart_init					; This is from your Lab #4 Library
	.global lab5

ptr_to_prompt:		.word prompt
ptr_to_mydata:		.word mydata


promptLog1:		.string "Lab 5 reflex game", 0
ptr_to_promptLog1:			.word promptLog1

promptLog2:		.string "Press enter to start game, ", 0
ptr_to_promptLog2:			.word promptLog2
promptLog3:		.string "Compete to see who can respond faster when the screen displays 'NOW!'.", 0
ptr_to_promptLog3:			.word promptLog3
promptLog4:		.string "Player 1 presses space     Player 2 presses sw1", 0
ptr_to_promptLog4:			.word promptLog4
promptLog5:		.string "Ready.....", 0
ptr_to_promptLog5:			.word promptLog5
promptLog6:		.string "NOW!", 0
ptr_to_promptLog6:			.word promptLog6
promptLog7:		.string "Another ROUND! press space to go for it!", 0
ptr_to_promptLog7:			.word promptLog7
promptLog8:		.string "GAME OVER! PLAYER1 WIN!", 0
ptr_to_promptLog8:			.word promptLog8
promptLog9:		.string "GAME OVER! PLAYER2 WIN!", 0
ptr_to_promptLog9:			.word promptLog9
promptLog10:		.string "The first player to win 3 rounds, wins.", 0
ptr_to_promptLog10:			.word promptLog10
promptLog11:		.string "Both of you press to early!.", 0
ptr_to_promptLog11:			.word promptLog11
promptLog12:		.string "Press before NOW shows will cause you cannot enter again.", 0
ptr_to_promptLog12:			.word promptLog12


lab5:								; This is your main routine which is called from
; your C wrapper.
	PUSH {r4-r12,lr}   		; Preserve registers to adhere to the AAPCS
	ldr r4, ptr_to_prompt
	ldr r5, ptr_to_mydata

 	BL uart_init
	BL gpio_interrupt_init
	BL uart_interrupt_init

	;print promptLog1
	ldr r0, ptr_to_promptLog1
	BL output_string
	;change line
	MOV r0, #10
	BL output_character
	MOV r0, #13
	BL output_character
	;print promptLog3
	ldr r0, ptr_to_promptLog3
	BL output_string
	;change line
	MOV r0, #10
	BL output_character
	MOV r0, #13
	BL output_character
	;print promptLog4
	ldr r0, ptr_to_promptLog4
	BL output_string
	;change line
	MOV r0, #10
	BL output_character
	MOV r0, #13
	BL output_character
	;print promptLog2
	ldr r0, ptr_to_promptLog2
	BL output_string
	;change line
	MOV r0, #10
	BL output_character
	MOV r0, #13
	BL output_character


	MOV r9,#0xFFFF ;timer
	MOVT r9,#0x002F ;timer

	MOV r10,#0x0000
	MOVT r10,#0x2000
	MOV r0, #0
	STR r0, [r10,#0]
	MOV r0, #0
	STR r0, [r10,#1]
	MOV r0, #0
	STR r0, [r10,#2]
	MOV r0, #0
	STR r0, [r10,#3]
	MOV r0, #0
	STR r0, [r10,#4]
	MOV r0, #0
	STR r0, [r10,#5]
	MOV r0, #0
	STR r0, [r10,#6]

lab5_loop:
	BL simple_read_character
	CMP r0,#0xD
	BEQ lab5_ctn
	BL lab5_loop

lab5_ctn:
	BL uart_init
	BL gpio_interrupt_init
	BL uart_interrupt_init

	;print promptLog4
	ldr r0, ptr_to_promptLog5
	BL output_string
	;change line
	MOV r0, #10
	BL output_character
	MOV r0, #13
	BL output_character

	MOV r0, #0 ;playerHit
	MOV r1, #0 ;playerHit
	MOV r2, #0 ;ready_time_end flag & click_time_end flag
	STRB r0, [r10,#0]
	STRB r1, [r10,#1]
	STRB r2, [r10,#2]
	MOV r3, #0 ;playerScore
	MOV r4, #0 ;playerScore

	MOV r5, #0 ;playerRightToHit
	MOV r6, #0 ;playerRightToHit
	STRB r5, [r10,#5]
	STRB r6, [r10,#6]

ready_time_loop:

	SUB r9, #1
	LDRB r0, [r10,#0]
	LDRB r1, [r10,#1]

	LDRB r5, [r10,#5]
	LDRB r6, [r10,#6]
	AND r7, r5, r6
	CMP r7,#1
	BEQ press_too_early

	CMP r9,#0
	BEQ ready_time_loop_end
	BL ready_time_loop

ready_time_loop_end:

	MOV r9,#0xFFFF ;timer
	MOVT r9,#0x002F ;timer

	MOV r0, #0
	MOV r1, #0
	STRB r0, [r10,#0]
	STRB r1, [r10,#1]

	;print promptLog6
	ldr r0, ptr_to_promptLog6
	BL output_string
	;change line
	MOV r0, #10
	BL output_character
	MOV r0, #13
	BL output_character

	MOV r2,#1
	STRB r2, [r10,#2]

	MOV r0, #0
	MOV r1, #0

click_time_loop:
	LDRB r0, [r10,#0]
	LDRB r1, [r10,#1]
	ORR r3, r0, r1
	CMP r3,#1
	BEQ click_time_loop_end
	BL click_time_loop

click_time_loop_end:
	CMP r0, #1
	BEQ ADD_player0score
	BL ADD_player1score

ADD_player0score:
	ADD r5,#1
	BL test_round

ADD_player1score:
	ADD r6,#1
	BL test_round

test_round:
	CMP r5, #3
	BEQ lab5_end
	CMP r6, #3
	BEQ lab5_end

	;print promptLog4
	ldr r0, ptr_to_promptLog7
	BL output_string
	;change line
	MOV r0, #10
	BL output_character
	MOV r0, #13
	BL output_character

walt:
	BL simple_read_character
	CMP r0,#32
	BEQ lab5_ctn
	BL walt

press_too_early:
	MOV r7,#0
	BL lab5_loop

lab5_end:

	; This is where you should implement a loop, waiting for the user to
	; enter a q, indicating they want to end the program.

	POP {lr}		; Restore registers to adhere to the AAPCS
	MOV pc, lr



uart_interrupt_init:

	; Your code to initialize the UART0 interrupt goes here

		;set UARTIM
		MOV r1, #0xC038
		MOVT r1, #0x4000
		LDR r0, [r1, #0]
		ORR r0, #0x10
		STR r0, [r1, #0]

		;set EN0
		MOV r1, #0xE100
		MOVT r1, #0xE000
		LDR r0, [r1, #0]
		ORR r0, #0x20
		STR r0, [r1, #0]

	MOV pc, lr


gpio_interrupt_init:

	; Your code to initialize the SW1 interrupt goes here
	; Don't forget to follow the procedure you followed in Lab #4
	; to initialize SW1.

	    ;enables clock for GPIO Ports
		;for input of board port F
		MOV r1, #0xE608
		MOVT r1, #0x400F
		LDRB r0, [r1, #0]
		ORR r0, #0x20
		STRB r0, [r1, #0]
		;set direction of GPIO port F Pin 4 as 0
		MOV r1, #0x5400
		MOVT r1, #0x4002
		LDRB r0, [r1, #0]
		AND r0, #0xEF
		STRB r0, [r1, #0]
		;set GPIO port F Pin 1 as Digital
		MOV r1, #0x551c
		MOVT r1, #0x4002
		LDRB r0, [r1, #0]
		ORR r0, #0x10
		STRB r0, [r1, #0]
		; Pull-Up Resistor port F pin 4
		MOV r1, #0x5510
		MOVT r1, #0x4002
		LDRB r0, [r1, #0]
		ORR r0, #0x10
		STRB r0, [r1, #0]

		;set port F pin 4 GPIO Interrupt Sense Register bit4 -> 0
		MOV r1, #0x5404
		MOVT r1, #0x4002
		LDRB r0, [r1, #0]
		AND r0, #0xEF
		STRB r0, [r1, #0]
		;set port F pin 4 GPIO Interrupt Both Edges Register bit4 -> 0
		MOV r1, #0x5408
		MOVT r1, #0x4002
		LDRB r0, [r1, #0]
		AND r0, #0xEF
		STRB r0, [r1, #0]
		;set port F pin 4 GPIO Interrupt Event Register bit4 -> 0
		MOV r1, #0x540C
		MOVT r1, #0x4002
		LDRB r0, [r1, #0]
		AND r0, #0xEF
		STRB r0, [r1, #0]
		;set port F pin 4 GPIO Interrupt Mask Register bit4 -> 0
		MOV r1, #0x5410
		MOVT r1, #0x4002
		LDRB r0, [r1, #0]
		ORR r0, #0x10
		STRB r0, [r1, #0]

		;set Allow GPIO Port F to Interrupt Processor
		MOV r1, #0xE100
		MOVT r1, #0xE000
		LDR r0, [r1, #0]
		ORR r0, #0x40000000
		STR r0, [r1, #0]

	MOV pc, lr


UART0_Handler:

	; Your code for your UART handler goes here.
	; Remember to preserver registers r4-r11 by pushing then popping
	; them to & from the stack at the beginning & end of the handler

	PUSH {r4-r12,lr}
		;set Clear Interrupt of GPIO
		MOV r7, #0xC000
		MOVT r7, #0x4000
		LDR r8, [r7, #0]
		CMP r8, #0xD
		BEQ UART0_Handler_End

		MOV r10,#0x0000
		MOVT r10,#0x2000

		LDRB r2, [r10,#2] ;ready_time_end flag & click_time_end flag
		CMP r2, #0
		BEQ p1_disq

		LDRB r5, [r10,#5] ;
		CMP r5, #1
		BEQ UART0_Handler_End

		MOV r0, #1
		STRB r0, [r10,#0]

		MOV r7, #0xC044
		MOVT r7, #0x4000
		LDR r8, [r7, #0]
		ORR r8, #0x10
		STR r8, [r7, #0]

		BL UART0_Handler_End
p1_disq:
		MOV r7, #0xC044
		MOVT r7, #0x4000
		LDR r8, [r7, #0]
		ORR r8, #0x10
		STR r8, [r7, #0]

		MOV r5, #1
		STRB r5, [r10,#5]

		MOV r0, #1
		STRB r0, [r10,#0]

UART0_Handler_End:

	POP {r4-r12,lr}

	BX lr       	; Return


Switch_Handler:

	; Your code for your UART handler goes here.
	; Remember to preserver registers r4-r11 by pushing then popping
	; them to & from the stack at the beginning & end of the handler

	PUSH {r4-r12,lr}
		;set Clear Interrupt of GPIO

		MOV r10,#0x0000
		MOVT r10,#0x2000

		LDRB r2, [r10,#2] ;ready_time_end flag & click_time_end flag
		CMP r2, #0
		BEQ p2_disq

		LDRB r6, [r10,#6] ;ready_time_end flag & click_time_end flag
		CMP r6, #1
		BEQ Switch_Handler_End

		MOV r7, #0x541C
		MOVT r7, #0x4002
		LDR r8, [r7, #0]
		ORR r8, #0x10
		STR r8, [r7, #0]

		MOV r1, #1
		STRB r1, [r10,#1]

		BL Switch_Handler_End
p2_disq:
		MOV r7, #0x541C
		MOVT r7, #0x4002
		LDR r8, [r7, #0]
		ORR r8, #0x10
		STR r8, [r7, #0]

		MOV r6, #1
		STRB r6, [r10,#6]

Switch_Handler_End:

	POP {r4-r12,lr}

	BX lr       	; Return


Timer_Handler:

	; Your code for your Timer handler goes here.  It is not needed for
	; Lab #5, but will be used in Lab #6.  It is referenced here because
	; the interrupt enabled startup code has declared Timer_Handler.
	; This will allow you to not have to redownload startup code for
	; Lab #6.  Instead, you can use the same startup code as for Lab #5.
	; Remember to preserver registers r4-r11 by pushing then popping
	; them to & from the stack at the beginning & end of the handler.

	BX lr       	; Return


simple_read_character:

	MOV r1, #0xC000
	MOVT r1, #0x4000
	LDRB r0, [r1, #0]
	MOV r2,  #0
	STR r2, [r1, #0]
	MOV pc, lr	; Return
	.end
