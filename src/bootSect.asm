;;; Basic Boot Sector That Will Jump Continuously
;;;

here:
	jmp here					; Jump Repeatedly to Label 'loop'; Neverending

	times 510-($-$$) db 0		; Pads Out 0s Until We Reach 510th Byte

	dw 0xaa55					; BIOS Magic Number; BOOT Magic #