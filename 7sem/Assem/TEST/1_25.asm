.model small
.stack 100h
.code

start:
    mov ax, cs
    call print_hex
    mov ah, 4Ch
    int 21h

print_hex proc
    push ax
    push dx
    mov cx, 4
    mov dx, ax

next_nibble:
    rol dx, 4
    mov al, dl
    and al, 0Fh
    add al, '0'
    cmp al, '9'
    jbe print_char
    add al, 7

print_char:
    mov ah, 0Eh
    int 10h
    loop next_nibble
    pop dx
    pop ax
    ret
print_hex endp

end start
