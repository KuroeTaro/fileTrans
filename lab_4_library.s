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

gpio_btn_and_LED_init:
	PUSH {r4-r12,lr}	; Spill registers to stack

          ; Your code is placed here

    	;enables clock for GPIO Ports
		;for input of board port F D B
		MOV r1, #0xE608
		MOVT r1, #0x400F
		LDRB r0, [r1, #0]
		ORR r0, #0x2A
		STRB r0, [r1, #0]

		;set direction of GPIO port F Pin 4 as 0, Pin 1 2 3 as 1
		MOV r1, #0x5400
		MOVT r1, #0x4002
		LDRB r0, [r1, #0]
		ORR r0, #0xE
		AND r0, #0xEF
		STRB r0, [r1, #0]

		;set GPIO port F Pin 1 2 3 4 as Digital
		MOV r1, #0x551c
		MOVT r1, #0x4002
		LDRB r0, [r1, #0]
		ORR r0, #0x1E
		STRB r0, [r1, #0]

		; Pull-Up Resistor port F pin 4
		MOV r1, #0x5510
		MOVT r1, #0x4002
		LDRB r0, [r1, #0]
		ORR r0, #0x10
		STRB r0, [r1, #0]

		;set direction of GPIO port D Pin 0 1 2 3 as 0
		MOV r1, #0x7400
		MOVT r1, #0x4000
		LDRB r0, [r1, #0]
		AND r0, #0xF0
		STRB r0, [r1, #0]

		;set GPIO port D Pin 0 1 2 3 as Digital
		MOV r1, #0x751c
		MOVT r1, #0x4000
		LDRB r0, [r1, #0]
		ORR r0, #0xF
		STRB r0, [r1, #0]

		;set direction of GPIO port B Pin 0 1 2 3 as 1
		MOV r1, #0x5400
		MOVT r1, #0x4000
		LDRB r0, [r1, #0]
		ORR r0, #0xF
		STRB r0, [r1, #0]

		;set GPIO port B Pin 0 1 2 3 as Digital
		MOV r1, #0x551c
		MOVT r1, #0x4000
		LDRB r0, [r1, #0]
		ORR r0, #0xF
		STRB r0, [r1, #0]

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

read_character:
	PUSH {r4-r12,lr}	; Spill registers to stack

          ; Your code is placed here
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

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

read_string:
	PUSH {r4-r12,lr}	; Spill registers to stack

          ; Your code is placed here
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

read_from_push_btns:
	PUSH {r4-r12,lr}	; Spill registers to stack

        ; Your code is placed here
        MOV r4, #0x73FC
		MOVT r4, #0x4000
		LDRB r5, [r4, #0]
		MOV r0, #0
		ORR r5, r5, #0xF0
		MOV r0, r5

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

illuminate_LEDs:
	PUSH {r4-r12,lr}	; Spill registers to stack

          ; Your code is placed here
        MOV r4, #0x53FC
		MOVT r4, #0x4000
		STRB r0, [r4, #0]

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

illuminate_RGB_LED:
	PUSH {r4-r12,lr}	; Spill registers to stack

          ; Your code is placed here
        MOV r4, #0x53FC
		MOVT r4, #0x4002
		STRB r0, [r4, #0]

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

	.end
