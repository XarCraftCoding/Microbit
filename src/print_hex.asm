;;;
;;; Prints Hexadecimal Values Using Register DX 'print_string.asm'
;;;
;;; Ascii '0' - '9' = Hex 0x30 - 0x39
;;; Ascii 'A' - 'F' = Hex 0x41 - 0x46
;;; Ascii 'a' - 'f' = Hex 0x61 - 0x66
;;;
print_hex:
	pusha					; Save All Registers to The Stack
	mov cx, 0				; Initialize Loop Counter

hex_loop:
	cmp cx, 4				; Are We At End of Loop?
	je end_hexloop

	;; Convert DX Hex Values to Ascii
	mov ax, dx
	and ax, 0x000F			; Turn 1st 3 Hex to 0, Keep Final Digit to Convert
	add al, 0x30			; Get Ascii Number or Letter Value
	cmp al, 0x39			; Is Hex Value 0 - 9 (<= 0x39) or A - F (> 0x39)
	jle move_intoBX
	add al, 0x7				; To Get Ascii 'A' - 'F'

	;; Move Ascii Char Into BX String
move_intoBX:
	mov bx, hexString + 5	; Base Address of 'hexString' + Length of String
	sub bx, cx				; Subtract Loop Counter
	mov [bx], al
	ror dx, 4				; Rotate Right by 4 Bits
							; 0x12AB -> 0xB12A -> 0xAB12 -> 0x2AB1 -> 0x12AB
							
	add cx, 1				; Increment Counter
	jmp hex_loop			; Loop For Next Hex Digit in DX

end_hexloop:
	mov bx, hexString
	call print_string

	popa					; Restore All Registers From The Stack
	ret						; Return to Caller

	; Data
hexString:		db '0x0000', 0