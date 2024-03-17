	.data

board:  .string "#---------------------#", 0xA, 0xD  ;This is a 21*21 size map (inside wall)
		.string "|                     |", 0xA, 0xD  ;Since its impossible put point in center of map if it 20*20
		.string "|                     |", 0xA, 0xD  ;And I'm going to die hard If I don't put that right in the center
		.string "|                     |", 0xA, 0xD	 ;Center position (11,11)
		.string "|                     |", 0xA, 0xD
		.string "|                     |", 0xA, 0xD
		.string "|                     |", 0xA, 0xD
		.string "|                     |", 0xA, 0xD
		.string "|                     |", 0xA, 0xD
		.string "|                     |", 0xA, 0xD
		.string "|                     |", 0xA, 0xD
		.string "|          *          |", 0xA, 0xD
		.string "|                     |", 0xA, 0xD
		.string "|                     |", 0xA, 0xD
		.string "|                     |", 0xA, 0xD
		.string "|                     |", 0xA, 0xD
		.string "|                     |", 0xA, 0xD
		.string "|                     |", 0xA, 0xD
		.string "|                     |", 0xA, 0xD
		.string "|                     |", 0xA, 0xD
		.string "|                     |", 0xA, 0xD
		.string "|                     |", 0xA, 0xD
		.string "#---------------------#", 0x0

direction:	.string	"00" ,0				; This is direction of next frame
location:	.string	"0000" ,0			; This is location of node
scoreText:	.string "      SCORE: " ,0	; This is score string
scoreValue:	.string "0000",0				; This is score value
gameOverFlag:	.string "00" 			; This is flag to show the game is over or not 1->Over 0->Looping
singleChar: .string "00" 				; This is address to store single chat sub rout result

	.text

ptr_to_board:				.word board
ptr_to_direction:			.word direction
ptr_to_location:			.word location
ptr_to_scoreText:			.word scoreText
ptr_to_scoreValue:			.word scoreValue
ptr_to_gameOverFlag:		.word gameOverFlag
ptr_to_singleChar:			.word singleChar


	.global uart_interrupt_init
	.global gpio_interrupt_init
	.global time_interrupt_init
	.global read_tiva_push_button
	.global UART0_Handler
	.global Switch_Handler
	.global Timer_Handler			; This is needed for Lab #6
	.global simple_read_character
	.global output_character		; This is from your Lab #4 Library
	.global read_string				; This is from your Lab #4 Library
	.global output_string			; This is from your Lab #4 Library
	.global int2string
	.global div_and_mod
	.global uart_init					; This is from your Lab #4 Library
	.global lab6

lab6:								; This is your main routine which is called from
; your C wrapper.
	PUSH {r4-r12,lr}   		; Preserve registers to adhere to the AAPCS

	BL uart_init
	BL uart_interrupt_init
	BL gpio_interrupt_init
	BL time_interrupt_init


	LDR r0, ptr_to_gameOverFlag		;Initialize gameOverFlag; 0 -> keep loop 1-> gameover
	MOV r1, #0
	STRB r1, [r0]

	LDR r0, ptr_to_scoreValue		;Initialize scoreValue; store int value of score
	STR r1, [r0]

	LDR r0, ptr_to_direction		;Initialize direction; defult value is 'w'
	MOV r1, #0x77
	STRB r1, [r0]

	LDR r1, ptr_to_board
	ADD r1, #0x11E
	ldr r0, ptr_to_location			;Initialize start * location
	STR r1, [r0]

lab_loop:
	LDR r0, ptr_to_gameOverFlag
	LDRB r10, [r0]
	CMP r10, #0
	BEQ lab_loop

		MOV r7, #0xC044
		MOVT r7, #0x4000
		LDR r8, [r7, #0]
		ORR r8, #0x10
		STR r8, [r7, #0]

		MOV r7, #0x541C
		MOVT r7, #0x4002
		LDR r8, [r7, #0]
		ORR r8, #0x10
		STR r8, [r7, #0]

		MOV r7, #0x0024
		MOVT r7, #0x4003
		LDR r8, [r7, #0]
		ORR r8, #0x1
		STR r8, [r7, #0]

		MOV r1, #0x0000
		MOVT r1, #0x4003
		LDR r0, [r1, #0x00C]
		AND r0, #0xFE
		STR r0, [r1, #0x00C]

	POP {r4-r12, lr}		; Restore registers to adhere to the AAPCS
	MOV pc, lr


get_current_input:
	PUSH {r4-r12,lr}
	BL simple_read_character
	LDR r0, ptr_to_singleChar
	LDRB r1, [r0]
	CMP r1, #0x77 ;w
	BEQ get_current_input_vaild_input
	CMP r1, #0x61 ;a
	BEQ get_current_input_vaild_input
	CMP r1, #0x73 ;s
	BEQ get_current_input_vaild_input
	CMP r1, #0x64 ;d
	BEQ get_current_input_vaild_input
	BL get_current_input_end

get_current_input_vaild_input:
	LDR r0, ptr_to_direction
	STRB r1, [r0]
get_current_input_end:
	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

update_map:
	PUSH {r4-r12,lr}

	LDR r0, ptr_to_direction
	LDRB r1, [r0]
	CMP r1, #0x77 ;w
	BEQ update_map_wInput
	CMP r1, #0x61 ;a
	BEQ update_map_aInput
	CMP r1, #0x73 ;s
	BEQ update_map_sInput
	CMP r1, #0x64 ;d
	BEQ update_map_dInput
	BL update_map_end

update_map_wInput:
	LDR r0, ptr_to_location ;get current location store in r1
	LDR r1, [r0]
	SUB r1, #0x19	; sub/add r1 to last line , left , next line , right.
	STR r1, [r0]	; store new location to location address
	LDRB r0, [r1]	; get char from new location
	CMP r0, #0x20	; if it not space
	BEQ update_map_ctn
	BL update_map_gameOver
update_map_aInput:
	LDR r0, ptr_to_location
	LDR r1, [r0]
	SUB r1, #0x1
	STR r1, [r0]
	LDRB r0, [r1]
	CMP r0, #0x20
	BEQ update_map_ctn
	BL update_map_gameOver
update_map_sInput:
	LDR r0, ptr_to_location
	LDR r1, [r0]
	ADD r1, #0x19
	STR r1, [r0]
	LDRB r0, [r1]
	CMP r0, #0x20
	BEQ update_map_ctn
	BL update_map_gameOver
update_map_dInput:
	LDR r0, ptr_to_location
	LDR r1, [r0]
	ADD r1, #0x1
	STR r1, [r0]
	LDRB r0, [r1]
	CMP r0, #0x20
	BEQ update_map_ctn
	BL update_map_gameOver

update_map_ctn:
	MOV r0, #0x2A
	STRB r0, [r1]
	LDR r0, ptr_to_scoreValue
	LDRH r1, [r0]
	ADD r1, r1, #1
	STRH r1, [r0]
	BL update_map_end

update_map_gameOver:
	MOV r0, #0x2A
	STRB r0, [r1]
	LDR r1, ptr_to_gameOverFlag
	MOV r0, #0x1
	STRB r0, [r1]

update_map_end:
	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

print_map:
	PUSH {r4-r12,lr}
	MOV r0, #0xC
	BL output_character
	LDR r0, ptr_to_scoreText
	BL output_string
	LDR r0, ptr_to_scoreValue
	LDR r1, [r0]
	MOV r0, #0x7000
	MOVT r0, #0x2000
	BL int2string
	BL output_string
	; change line
	MOV r0, #10
	BL output_character
	MOV r0, #13
	BL output_character

	LDR r0, ptr_to_board
	BL output_string
	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

uart_init:
	PUSH {r4-r12,lr}	; Spill registers to stack

        ; Your code is placed here

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

	POP {r4-r12,lr}  	; Restore registers from stack
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

time_interrupt_init:

	; Your code to initialize the UART0 interrupt goes here

		;set RCGCTIMER
		MOV r1, #0xE604
		MOVT r1, #0x400F
		LDR r0, [r1, #0x0]
		MOV r0, #0x1
		STR r0, [r1, #0]

		;set GPTMCTL
		MOV r1, #0x0000
		MOVT r1, #0x4003
		LDRB r0, [r1, #0x0C]
		AND r0, #0xFE
		STRB r0, [r1, #0x0C]

		;set GPTMCFG
		LDR r0, [r1, #0x0]
		ORR r0, #0x0
		STR r0, [r1, #0x0]

		;set GPTMTAMR
		LDRB r0, [r1, #0x4]
		MOV r0, #0x2
		STRB r0, [r1, #0x4]

		;set GPTMTAILR
		MOV r0, #0x1200
		MOVT r0, #0x007A
		STR r0, [r1, #0x28]

		;set GPTMIMR
		LDR r0, [r1, #0x18]
		ORR r0, #0x1
		STR r0, [r1, #0x18]

		;set EN0
		MOV r1, #0xE100
		MOVT r1, #0xE000
		LDR r0, [r1, #0]
		ORR r0, #0x80000
		STR r0, [r1, #0]

		;set GPTMCTL
		MOV r1, #0x0000
		MOVT r1, #0x4003
		LDR r0, [r1, #0x00C]
		ORR r0, #0x1
		STR r0, [r1, #0x00C]

	MOV pc, lr


UART0_Handler:

	; Your code for your UART handler goes here.
	; Remember to preserver registers r4-r11 by pushing then popping
	; them to & from the stack at the beginning & end of the handler

	PUSH {r4-r12,lr}

		;disable all interrupts
		MOV r1, #0xC038
		MOVT r1, #0x4000
		LDRB r0, [r1, #0]
		AND r0, #0xEF
		STRB r0, [r1, #0]

		MOV r1, #0x5410
		MOVT r1, #0x4002
		LDRB r0, [r1, #0]
		AND r0, #0xEF
		STRB r0, [r1, #0]

		MOV r1, #0x0000
		MOVT r1, #0x4003
		LDR r0, [r1, #0x00C]
		AND r0, #0xFE
		STR r0, [r1, #0x00C]

		;set Clear Interrupts
		MOV r7, #0xC044
		MOVT r7, #0x4000
		LDR r8, [r7, #0]
		ORR r8, #0x10
		STR r8, [r7, #0]

		MOV r7, #0x541C
		MOVT r7, #0x4002
		LDR r8, [r7, #0]
		ORR r8, #0x10
		STR r8, [r7, #0]

		MOV r7, #0x0024
		MOVT r7, #0x4003
		LDR r8, [r7, #0]
		ORR r8, #0x1
		STR r8, [r7, #0]

		BL get_current_input

		;enable all interrupts
		MOV r1, #0xC038
		MOVT r1, #0x4000
		LDR r0, [r1, #0]
		ORR r0, #0x10
		STR r0, [r1, #0]

		MOV r1, #0x5410
		MOVT r1, #0x4002
		LDRB r0, [r1, #0]
		ORR r0, #0x10
		STRB r0, [r1, #0]

		MOV r1, #0x0000
		MOVT r1, #0x4003
		LDR r0, [r1, #0x00C]
		ORR r0, #0x1
		STR r0, [r1, #0x00C]

	POP {r4-r12,lr}

	BX lr       	; Return


Switch_Handler:

	; Your code for your UART handler goes here.
	; Remember to preserver registers r4-r11 by pushing then popping
	; them to & from the stack at the beginning & end of the handler

	PUSH {r4-r12,lr}

		;disable all interrupts
		MOV r1, #0xC038
		MOVT r1, #0x4000
		LDRB r0, [r1, #0]
		AND r0, #0xEF
		STRB r0, [r1, #0]

		MOV r1, #0x5410
		MOVT r1, #0x4002
		LDRB r0, [r1, #0]
		AND r0, #0xEF
		STRB r0, [r1, #0]

		MOV r1, #0x0000
		MOVT r1, #0x4003
		LDR r0, [r1, #0x00C]
		AND r0, #0xFE
		STR r0, [r1, #0x00C]

		;set Clear Interrupts
		MOV r7, #0xC044
		MOVT r7, #0x4000
		LDR r8, [r7, #0]
		ORR r8, #0x10
		STR r8, [r7, #0]

		MOV r7, #0x541C
		MOVT r7, #0x4002
		LDR r8, [r7, #0]
		ORR r8, #0x10
		STR r8, [r7, #0]

		MOV r7, #0x0024
		MOVT r7, #0x4003
		LDR r8, [r7, #0]
		ORR r8, #0x1
		STR r8, [r7, #0]

Switch_Handler_check_release1_loop:
		MOV r0, #0x0
		BL read_tiva_push_button
		CMP r0, #0xF
		BEQ Switch_Handler_check_release1_loop

Switch_Handler_check_release2_loop:
		MOV r0, #0xF
		BL read_tiva_push_button
		CMP r0, #0x0
		BEQ Switch_Handler_check_release2_loop

Switch_Handler_check_release3_loop:
		MOV r0, #0x0
		BL read_tiva_push_button
		CMP r0, #0xF
		BEQ Switch_Handler_check_release3_loop

		;set Clear Interrupts
		MOV r7, #0xC044
		MOVT r7, #0x4000
		LDR r8, [r7, #0]
		ORR r8, #0x10
		STR r8, [r7, #0]

		MOV r7, #0x541C
		MOVT r7, #0x4002
		LDR r8, [r7, #0]
		ORR r8, #0x10
		STR r8, [r7, #0]

		MOV r7, #0x0024
		MOVT r7, #0x4003
		LDR r8, [r7, #0]
		ORR r8, #0x1
		STR r8, [r7, #0]


		;enable all interrupts
		MOV r1, #0xC038
		MOVT r1, #0x4000
		LDR r0, [r1, #0]
		ORR r0, #0x10
		STR r0, [r1, #0]

		MOV r1, #0x5410
		MOVT r1, #0x4002
		LDRB r0, [r1, #0]
		ORR r0, #0x10
		STRB r0, [r1, #0]

		MOV r1, #0x0000
		MOVT r1, #0x4003
		LDR r0, [r1, #0x00C]
		ORR r0, #0x1
		STR r0, [r1, #0x00C]

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
	PUSH {r4-r12,lr}

		;disable all interrupts
		MOV r1, #0xC038
		MOVT r1, #0x4000
		LDRB r0, [r1, #0]
		AND r0, #0xEF
		STRB r0, [r1, #0]

		MOV r1, #0x5410
		MOVT r1, #0x4002
		LDRB r0, [r1, #0]
		AND r0, #0xEF
		STRB r0, [r1, #0]

		MOV r1, #0x0000
		MOVT r1, #0x4003
		LDR r0, [r1, #0x00C]
		AND r0, #0xFE
		STR r0, [r1, #0x00C]

		;set Clear Interrupts
		MOV r7, #0xC044
		MOVT r7, #0x4000
		LDR r8, [r7, #0]
		ORR r8, #0x10
		STR r8, [r7, #0]

		MOV r7, #0x541C
		MOVT r7, #0x4002
		LDR r8, [r7, #0]
		ORR r8, #0x10
		STR r8, [r7, #0]

		MOV r7, #0x0024
		MOVT r7, #0x4003
		LDR r8, [r7, #0]
		ORR r8, #0x1
		STR r8, [r7, #0]

		LDR r0, ptr_to_gameOverFlag
		LDRB r10, [r0]
		CMP r10, #1
		BEQ Timer_Handler_close

		BL update_map
		BL print_map

Timer_Handler_open:

		;enable all interrupts
		MOV r1, #0xC038
		MOVT r1, #0x4000
		LDR r0, [r1, #0]
		ORR r0, #0x10
		STR r0, [r1, #0]

		MOV r1, #0x5410
		MOVT r1, #0x4002
		LDRB r0, [r1, #0]
		ORR r0, #0x10
		STRB r0, [r1, #0]

		MOV r1, #0x0000
		MOVT r1, #0x4003
		LDR r0, [r1, #0x00C]
		ORR r0, #0x1
		STR r0, [r1, #0x00C]

Timer_Handler_close:

	POP {r4-r12,lr}


	BX lr       	; Return


simple_read_character:
	PUSH {r4-r12,lr}
	MOV r1, #0xC000
	MOVT r1, #0x4000
	LDRB r0, [r1, #0]
	LDR r1, ptr_to_singleChar
	STRB r0, [r1, #0]
	POP {r4-r12,lr}
	MOV pc, lr	; Return

int2string:
	PUSH {r4-r12,lr} 	; Store any registers in the range of r4 through r12
							; that are used in your routine.  Include lr if this
							; routine calls another routine.

		; Your code for your int2string routine is placed here
	MOV r5, r1 ;store dividend
	MOV r6, #10 ;stroe divisor
	MOV r7, #0 ;store quotient
	MOV r8, #0 ;store remain
	MOV r4, r0 ;store address to assign
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

div_and_mod:
	PUSH {r4-r12,lr}	; Spill registers to stack

          ; Your code is placed here
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

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

output_character:
	PUSH {r4-r12,lr}	; Spill registers to stack

          ; Your code is placed here
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

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

output_string:
	PUSH {r4-r12,lr}	; Spill registers to stack

          ; Your code is placed here
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

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

read_tiva_push_button:
	PUSH {r4-r12,lr}	; Spill registers to stack

          ; Your code is placed here
    	MOV r4, #0x53FC
		MOVT r4, #0x4002
		LDRB r5, [r4, #0]
		AND r5, #0x10
		CMP r5, #0x10
		BEQ tiva_push_button_return_on
		MOV r0, #0xF
		BL read_tiva_pushbutton_exit
tiva_push_button_return_on:
		MOV r0, #0
read_tiva_pushbutton_exit:

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr



	.end
