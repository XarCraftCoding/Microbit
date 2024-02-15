;;;
;;; Basic Boot Sector That Prints Characters Using BIOS Interrupts
;;;
	org 0x7c00					; Origin of Boot Code; Helps Make Sure Addresses Don't Change

	;; Set Video Mode
	mov ah, 0x00				; INT 0x10 / AH 0x00 = Set Video Mode
	mov al, 0x03				; 80x25 Text Mode
	int 0x10

	;; Change Color / Palette
	mov ah, 0x0B
	mov bh, 0x00
	mov bl, 0x01
	int 0x10

	;; Tele-type Output Strings
	mov bx, testString			; Moving Memory Address at 'testString' Into BX Register

	call print_string
	mov bx, string2
	call print_string

	mov dx, 0x12AB				; Sample Hex Number to Print
	call print_hex

	;; End Program
	jmp $						; Keep Jumping to Here; Neverending Loop

	;; Included Files
	include 'print_string.asm'
	include 'print_hex.asm'

	;; Variables
testString:		db 'Char Test: Hello, World!', 0xA, 0xD, 0	; 0 / Null to Null Terminate
string2:		db 'Hex Test: ', 0	

	;; Boot Sector Magic
	times 510-($-$$) db 0		; Pad File With 0s Until 510th Byte

	dw 0xaa55					; BIOS Magic Number in 511th and 512th Bytes