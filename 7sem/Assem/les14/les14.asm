.MODEL TINY
.CODE
ORG 100H

START:
    mov ah, 4Eh
    lea dx, a_MaskForVir
    int 21h

    jc NoFilesFound

    mov ax, dx
    call PrintDecimal
    mov ah, 02h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h

    call PrintHex

    mov ax, 4C00h
    int 21h

NoFilesFound:
    lea dx, NoFilesMsg
    mov ah, 09h
    int 21h

    mov ax, 4C00h
    int 21h

PrintDecimal:
    mov bx, 10
    xor cx, cx
DecimalLoop:
    xor dx, dx
    div bx
    push dx
    inc cx
    test ax, ax
    jnz DecimalLoop
PrintDecimalLoop:
    pop dx
    add dl, '0'
    mov ah, 02h
    int 21h
    loop PrintDecimalLoop
    ret

PrintHex:
    mov bx, 16
    xor cx, cx
HexLoop:
    xor dx, dx
    div bx
    push dx
    inc cx
    test ax, ax
    jnz HexLoop
PrintHexLoop:
    pop dx
    cmp dl, 10
    jl ConvertToASCII
    add dl, 'A' - 10
    jmp PrintHexChar
ConvertToASCII:
    add dl, '0'

PrintHexChar:
    mov ah, 02h
    int 21h
    loop PrintHexLoop
    ret

.DATA
a_MaskForVir DB '*.*', 0
NoFilesMsg DB 'files not found$', 0

END START
