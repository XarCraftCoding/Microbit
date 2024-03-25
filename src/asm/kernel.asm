;;;
;;; Kernel: Basic Kernel Loaded From Our Bootsector
;;;
	;; Set video mode
	mov ah, 0x00				; INT 0x10/ AH 0x00 = Set Video Mode
	mov al, 0x03				; 80x25 Text Mode
	int 0x10

	;; Change Color / Palette
	mov ah, 0x0B
	mov bh, 0x00
	mov bl, 0x01
	int 0x10

	;; Print Screen Heading And Menu Options
	mov si, menuString
	call print_string

	;; Get User Input, Print To Screen & Choose Menu Option Or Run Command Command
get_input:
	mov di, cmdString			; DI Now Pointing To cmdString
keyloop:
	mov ax, 0x00				; AH = 0x00, AL = 0x00
	int 0x16					; BIOS Int Get Keystroke AH = 0, Character Goes To AL
	mov ah, 0x0e
	cmp al, 0x0D				; Did User Press 'Enter' Key?
	je run_command
	int 0x10					; Print Input Character To Screen
	mov [di], al
	inc di
	jmp keyloop					; Loop For Next Character From User

run_command:
	mov byte [di], 0			; Null Terminate cmdString From DI
	mov al, [cmdString]
	cmp al, 'F'					; (F)ile Table Command / Menu Option
	cmp al, 'f'
	jne not_found
	cmp al, 'N'					; E(n)d Our Current Program
	je end_program
	mov si, success				; Command Found! Hooray
	call print_string
	jmp get_input
	
not_found:
	mov si, failure				; Command Not Found, Frowny Face...
	call print_string
	jmp get_input

print_string:
	mov ah, 0x0e				; INT 10h / AH 0x0e BIOS Teletype Output
	mov bh, 0x0					; Page Number
	mov bl, 0x07				; Color

print_char:
	mov al, [si]				; Move Character Value At Address In BX Into AL
	cmp al, 0
	je end_print				; Jump If Equal (AL = 0) To Halt Label
	int 0x10					; Print Character In AL
	add si, 1					; Move 1 Byte Forward / Get Next Character
	jmp print_char				; Loop

end_print:
	ret

end_program:
	cli							; Clear Interrupts
	hlt							; Halt The CPU

	;; Variables
menuString:		db 0xA, 0xD, \
	' ----------------------------------------------------------------------------- ', \
	0xA, 0xD, ' Kernel Booted, Welcome to Microbit OS!', 0xA, 0xD, \
	' ----------------------------------------------------------------------------- ', \
	0xA, 0xD, 0xA, 0xD, ' F - File & Program Browser / Loader', 0xA, 0xD, 0xA, 0xD, ' microbit@Microbit:/$ ', 0
success:		db 0xA, 0xD, 0x20, 'Command ran successfully!', 0xA, 0xD, 0xA, 0xD, ' microbit@Microbit:/$ ', 0
failure:		db 0xA, 0xD, 0x20, 'Oops! Something went wrong :(', 0xA, 0xD, 0xA, 0xD, ' microbit@Microbit:/$ ', 0
cmdString:		db ''

	;; Sector Padding Magic
	times 512-($-$$) db 0		; Pads Out 0s Until We Reach 512th Byte