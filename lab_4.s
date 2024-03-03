	.text
	.global uart_init
	.global gpio_btn_and_LED_init
	.global output_character
	.global read_character
	.global read_string
	.global output_string
	.global read_from_push_btns
	.global illuminate_LEDs
	.global illuminate_RGB_LED
	.global read_tiva_push_button
	.global div_and_mod
	.global lab4

	.global promptLog1
	.global promptLog2
	.global promptLog3
	.global promptLog4

promptLog1:		.string "Lab 4 test program", 0
ptr_to_promptLog1:			.word promptLog1

promptLog2:		.string "Part 1 Test read_tiva_push_button and illuminate_RGB_LED on the Tiva board.", 0
ptr_to_promptLog2:			.word promptLog2
promptLog3:		.string "1.Please now test the read_tiva_push_button and illuminate_RGB_LED by pressing sw1 on the Tiva board to light up the RGB LED.", 0
ptr_to_promptLog3:			.word promptLog3
promptLog4:		.string "2.If the Tiva board's LED lights up in white when you press sw1, both functions are working properly.", 0
ptr_to_promptLog4:			.word promptLog4
promptLog5:		.string "3.Please press the Enter key to enter the next test stage.", 0
ptr_to_promptLog5:			.word promptLog5
promptLog6:		.string "4.Please do NOT hold down the Enter key or it may cause the next stage to be skipped.", 0
ptr_to_promptLog6:			.word promptLog6

promptLog7:		.string "Part 2 Test read_from_push_btns and illuminate_LEDs on the Alice board.", 0
ptr_to_promptLog7:			.word promptLog7
promptLog8:		.string "1.Please now test the read_from_push_btns and illuminate_LEDs", 0
ptr_to_promptLog8:			.word promptLog8
promptLog9:		.string "2.When you press sw 2 3 4, the Tiva board's LED light should light up with color.", 0
ptr_to_promptLog9:			.word promptLog9
promptLog91:	.string "Press SW2 -> GREEN SW3 -> Blue SW4 -> RED SW5->No affect", 0
ptr_to_promptLog91:			.word promptLog91
promptLog10:	.string "3.The corresponding LED lights above sw 2 3 4 5 should also light up when pressed.", 0
ptr_to_promptLog10:			.word promptLog10
promptLog11:	.string "4.The LED lights produced by the sw 2 3 4 buttons can be mixed.", 0
ptr_to_promptLog11:			.word promptLog11
promptLog111:	.string "Press SW2+3 -> CYAN SW2+4 -> YELLOW SW3+4 -> PURPLE SW2+3+4 -> WHITE", 0
ptr_to_promptLog111:			.word promptLog111
promptLog12:	.string "5.If the above content can be reproduced successfully, it means that both read_from_push_btns and illuminate_LEDs functions are working properly.", 0
ptr_to_promptLog12:			.word promptLog12
promptLog13:	.string "The above is all the test content. Press Enter to end the test or press space to restart the test.", 0
ptr_to_promptLog13:			.word promptLog13

promptLog14:	.string "Program exited.", 0
ptr_to_promptLog14:			.word promptLog14


lab4:
	PUSH {r4-r12,lr}	; Spill registers to stack

restart:

        ; Your code is placed here
  		BL uart_init
		BL gpio_btn_and_LED_init

		;print promptLog1
		ldr r0, ptr_to_promptLog1
		BL output_string
		;change line
		MOV r0, #10
		BL output_character
		MOV r0, #13
		BL output_character
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
		;change line
		MOV r0, #10
		BL output_character
		MOV r0, #13
		BL output_character

		;print promptLog5
		ldr r0, ptr_to_promptLog5
		BL output_string
		;change line
		MOV r0, #10
		BL output_character
		MOV r0, #13
		BL output_character
		;change line
		MOV r0, #10
		BL output_character
		MOV r0, #13
		BL output_character

		;print promptLog6
		ldr r0, ptr_to_promptLog6
		BL output_string
		;change line
		MOV r0, #10
		BL output_character
		MOV r0, #13
		BL output_character
		;change line
		MOV r0, #10
		BL output_character
		MOV r0, #13
		BL output_character
		;change line
		MOV r0, #10
		BL output_character
		MOV r0, #13
		BL output_character
		;change line
		MOV r0, #10
		BL output_character
		MOV r0, #13
		BL output_character

		MOV r0, #0
		MOV r1, #0
		MOV r2, #0
		MOV r3, #0

		MOV r6, #0xC018
		MOVT r6, #0x4000

; if no key in keep loop
read_from_tiva_sw1_test_loop:
		MOV r4, #0x10
		LDRB r5, [r6, #0]
		AND r4, r4, r5

		MOV r0, #0xE
		BL read_tiva_push_button
		BL illuminate_RGB_LED

		CMP r4, #0x10
		BEQ read_from_tiva_sw1_test_loop

		;print line 7
		ldr r0, ptr_to_promptLog7
		BL output_string
		;change line
		MOV r0, #10
		BL output_character
		MOV r0, #13
		BL output_character
		;change line
		MOV r0, #10
		BL output_character
		MOV r0, #13
		BL output_character

		;print promptLog8
		ldr r0, ptr_to_promptLog8
		BL output_string
		;change line
		MOV r0, #10
		BL output_character
		MOV r0, #13
		BL output_character
		;change line
		MOV r0, #10
		BL output_character
		MOV r0, #13
		BL output_character

		;print promptLog9
		ldr r0, ptr_to_promptLog9
		BL output_string
		;change line
		MOV r0, #10
		BL output_character
		MOV r0, #13
		BL output_character
		;print promptLog91
		ldr r0, ptr_to_promptLog91
		BL output_string
		;change line
		MOV r0, #10
		BL output_character
		MOV r0, #13
		BL output_character
		;change line
		MOV r0, #10
		BL output_character
		MOV r0, #13
		BL output_character

		;print promptLog10
		ldr r0, ptr_to_promptLog10
		BL output_string
		;change line
		MOV r0, #10
		BL output_character
		MOV r0, #13
		BL output_character
		;change line
		MOV r0, #10
		BL output_character
		MOV r0, #13
		BL output_character

		;print promptLog11
		ldr r0, ptr_to_promptLog11
		BL output_string
		;change line
		MOV r0, #10
		BL output_character
		MOV r0, #13
		BL output_character
		;print promptLog111
		ldr r0, ptr_to_promptLog111
		BL output_string
		;change line
		MOV r0, #10
		BL output_character
		MOV r0, #13
		BL output_character
		;change line
		MOV r0, #10
		BL output_character
		MOV r0, #13
		BL output_character

		;print promptLog12
		ldr r0, ptr_to_promptLog12
		BL output_string
		;change line
		MOV r0, #10
		BL output_character
		MOV r0, #13
		BL output_character
		;change line
		MOV r0, #10
		BL output_character
		MOV r0, #13
		BL output_character

		;print promptLog13
		ldr r0, ptr_to_promptLog13
		BL output_string
		;change line
		MOV r0, #10
		BL output_character
		MOV r0, #13
		BL output_character
		;change line
		MOV r0, #10
		BL output_character
		MOV r0, #13
		BL output_character

; if key in keep loop
test_release_1:
		BL read_character
		CMP r0, #0x20
		BNE read_from_push_btns_test_loop
		BL test_release_1

read_from_push_btns_test_loop:
		MOV r4, #0x10
		LDRB r5, [r6, #0]
		AND r4, r4, r5

		BL read_from_push_btns
		BL illuminate_LEDs
		BL illuminate_RGB_LED

		CMP r4, #0x10
		BEQ read_from_push_btns_test_loop

test_restart:
		BL read_character
		CMP r0, #0x20
		BEQ Before_restart
		CMP r0, #0x0D
		BEQ lab4_end

Before_restart:
		;change line
		MOV r0, #10
		BL output_character
		MOV r0, #13
		BL output_character
		;change line
		MOV r0, #10
		BL output_character
		MOV r0, #13
		BL output_character
		;change line
		MOV r0, #10
		BL output_character
		MOV r0, #13
		BL output_character
		BL restart

lab4_end:
		;change line
		MOV r0, #10
		BL output_character
		MOV r0, #13
		BL output_character

		;print line 14
		ldr r0, ptr_to_promptLog14
		BL output_string
		;change line
		MOV r0, #10
		BL output_character
		MOV r0, #13
		BL output_character

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

	.end
