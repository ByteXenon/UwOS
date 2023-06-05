; Set the origin of the program to 0x7C00
org 0x7C00

; Macro for printing a null-terminated string
; %1 - Color code
; %2 - String
%macro print 2
    xor bx, bx        ; Clear BX register
    
    ; https://yassinebridi.github.io/asm-docs/8086_bios_and_dos_interrupts.html
    mov ah, 0x0E      ; Set AH = 0x0E (print character)

    %%.L1:
        mov al, [%2 + bx]  ; Load a character from the string
        push bx            ; Save BX register on the stack
        mov bx, %1
        int 0x10           ; Call video interrupt 0x10 to print the character
        pop bx             ; Restore BX register from the stack
        inc bx             ; Increment BX to move to the next character

        cmp al, 0          ; Check if the character is null
        je %%.EXIT         ; Jump to exit if end of string
        jmp %%.L1          ; Jump to print the next character

    %%.EXIT:
        ; No operation here, just a placeholder
        nop
%endmacro

; ------- INSTRUCTIONS ------- ;

; Set video mode 0x13 to enable graphics mode
; https://www.columbia.edu/~em36/wpdos/videomodes.txt
; https://ctyme.com/intr/rb-0106.htm
mov al, 13h
mov ah, 0
int 0x10

MoePrint:
    xor dx, dx           ; Clear DX register (counter)

    .L1:
        cmp dx, 64       ; Check if DX is equal to 64
        je .RESET        ; Jump to RESET if DX is 64

        print dx, string1
        inc dx
        print dx, string2

        add dx, 1         ; Increment DX
        jmp .L1           ; Jump to the beginning of the loop

    .RESET:
        xor dx, dx        ; Reset DX to 0
        jmp .L1           ; Jump to the beginning of the loop



; ------- DATA ------- ;
string1 db 'UwU', 0
string2 db 'OwO', 0

; Fill the remaining space up to the boot sector size with zeros
TIMES 510 - ($ - $$) db 0

; Boot signature (0xAA55) to mark the bootable sector
dw 0xAA55