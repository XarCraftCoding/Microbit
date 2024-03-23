;;;
;;; Simple Boot Loader That Uses INT 13 / AH 2 To Read From Disk Into Memory
;;;
	org 0x7c00				; Origin of Boot Code; Helps Make Sure Addresses Don't Change
	;; Set Up ES:BX Memory Address / Segment: Offset To Load Sector(s) Into
	mov bx, 0x1000			; Load Sector To Memory Address 0x1000
	mov es, bx
	mov bx, 0x0

	; Set Up Disk Read
	mov dh, 0x0				; Head 0
	mov dl, 0x0				; Drive 0
	mov ch, 0x0				; Cylinder 0
	mov cl, 0x02			; Starting Sector To Read From Disk

read_disk:
	mov ah, 0x02			; BIOS INT 13 / AH = 2 Read Disk Sectors
	mov al, 0x01			;
	int 0x13				; BIOS Interrupts For Disk Functions

	jc read_disk			; Retry If Disk Read Error (Carry Flag Set/ = 1)

	;; Reset Segment Registers for RAM
	mov ax, 0x1000			
	mov ds, ax				; Data Segment
	mov es, ax				; Extra Segment
	mov fs, ax				; ""
	mov gs, ax				; ""
	mov ss, ax				; Stack Segment

	jmp 0x1000:0x0			; Never Return From This!

	;; Included Files
	include 'print_string.asm'
	include 'disk_load.asm'

	;; Boot Sector Magic
	times 510-($-$$) db 0	; Pad File With 0s Until 510th Byte

	dw 0xaa55				; BIOS Magic Number In 511th And 512th Bytes