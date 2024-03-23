;;;
;;; Kernel: Basic Kernel Loaded From Our Bootsector
;;;
    ;; Set video mode
    mov ah, 0x00                ; INT 0x10/ AH 0x00 = Set Video Mode
    mov al, 0x03                ; 80x25 Text Mode
    int 0x10

    ;; Change Color / Palette
    mov ah, 0x0B
    mov bh, 0x00
    mov bl, 0x01
    int 0x10

    mov si, testString
    call print_string

    hlt                         ; Halt The CPU

print_string:
    mov ah, 0x0e                ; INT 10h / AH 0x0e BIOS Teletype Output
    mov bh, 0x0                 ; Page Number
    mov bl, 0x07                ; Color

print_char:
    mov al, [si]                ; Move Character Value At Address In BX Into AL
    cmp al, 0
    je end_print                ; Jump If Equal (AL = 0) To Halt Label
    int 0x10                    ; Print Character In AL
    add si, 1                   ; Move 1 Byte Forward / Get Next Character
    jmp print_char              ; Loop

end_print:
    ret

testString:     db 'Kernel Booted, Welcome to Microbit OS!', 0xA, 0xD, 0 

    ;; Sector Padding Magic
    times 512-($-$$) db 0       ; Pads Out 0s Until We Reach 512th Byte