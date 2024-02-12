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

	;; Tele-type Output
	mov ah, 0x0e				; INT 0x10 / AH 0x0e BIOS Teletype Output
	mov bx, testString			; Moving Memory Address at 'testString' Into BX Register

	call print_string
	mov bx, string2
	call print_string
	jmp end_pgn

print_string:
	mov al, [bx]				; Move Character Value at Address in BX Into AL
	cmp al, 0
	je end_print				; Jump If Equal (AL = 0) to Halt Label
	int 0x10					; Print Character in AL
	add bx, 1					; Move 1 Byte Forward / Get Next Character
	jmp print_string			; Loop

end_print:
	ret

	;; Variables
testString:		db 'TEST', 0xA, 0xD, 0	; 0 / Null to Null Terminate
string2:		db 'Also a Test!', 0

end_pgn:
	jmp $						; Keep Jumping to Here; Neverending Loop

	;; Boot Sector Magic
	times 510-($-$$) db 0		; Pad File With 0s Until 510th Byte

	dw 0xaa55					; BIOS Magic Number in 511th and 512th Bytes