.model tiny
.code
org 100h

start:
    mov  ah, 3Dh
    lea  dx, FName
    int  21h
    mov  Handle, ax

FillBuffer:
    mov  ah, 3Fh
    mov  bx, Handle
    mov  cx, 100h
    lea  dx, Buffer
    int  21h
    lea  si, Buffer
    cmp ax, 0
    je Exit

ReadBuffer:
    lodsb ; байт, на который указывает si поместить в al, si++
    call PrintSymb
    loop ReadBuffer
    jmp  FillBuffer

Exit:
    mov  bx, Handle
    mov  ah, 3Eh
    int  21h
    mov  ax, 4C00h
    int  21h

FName db "myfile.bin", 0
ScanCodes db 02h, 03h, 04h, 05h, 06h, 07h, 08h, 09h, 0Ah, 0Bh, 0Ch, 0Dh, 10h, 11h, 12h, 13h, 14h, 15h, 16h, 17h, 18h, 19h, 1Ah, 1Bh, 1Eh, 1Fh, 20h, 21h, 22h, 23h, 24h, 25h, 26h, 27h, 28h, 29h, 2Bh, 2Ch, 2Dh, 2Eh, 2Fh, 30h, 31h, 32h, 33h, 34h, 35h, 39h
ScanCodesLen = $ - ScanCodes
Symbs db "1234567890-=qwertyuiop[]asdfghjkl;'`\zxcvbnm,./ "
ShiftSymbs db '!@#$%^&*()_+QWERTYUIOP{}ASDFGHJKL:"~|ZXCVBNM<>? '

ShiftIsPushed db 0
Buffer db 100h dup(?) 
Handle dw 0
ENTR db 0Dh, 0Ah, "$"

CXStorage dw 0
BXStorage dw 0
SIStorage dw 0
DXStorage dw 0

PrintSymb proc near
    mov CXStorage, cx 
    mov DXStorage, dx
    mov SIStorage, si
    mov BXStorage, bx
    call SpecSymbsCheck
    jc   Finish
    lea  si, ScanCodes
    mov  cx, ScanCodesLen
    mov  dl, al
    FindScanCode:
        lodsb ; байт, на который указывает si поместить в al, si++
        cmp  dl, al
        je   FindSymb
        loop FindScanCode
    FindSymb:
        jcxz Finish
        mov  al, cl
        neg  al
        add  al, ScanCodesLen
        cmp  ShiftIsPushed, 0
        jnz  PrintShifted
        lea  bx, Symbs
        jmp  Print
    PrintShifted:
        lea  bx, ShiftSymbs
    Print:
        xlatb
        mov  dl, al
        mov  ah, 02h
        int  21h    
    Finish:
        mov cx, CXStorage
        mov bx, BXStorage
        mov si, SIStorage
        mov dx, DXStorage
        ret
PrintSymb endp

ShiftPressed proc near
    mov  bl, 2Ah
    cmp al, bl
    je ShiftPressedFinish
    mov  bl, 36h
    cmp al, bl
    je ShiftPressedFinish
    clc
    ret
ShiftPressedFinish:
    stc
    ret
ShiftPressed endp

ShiftReleased proc near
    mov  bl, 0AAh
    cmp al, bl
    je ShiftReleasedFinish
    mov  bl, 0B6h
    cmp al, bl
    je ShiftReleasedFinish
    clc
    ret
ShiftReleasedFinish:
    stc
    ret
ShiftReleased endp

EnterPressed proc near
    mov  bl, 1Ch
    cmp al, bl
    je EnterFinish
    clc
    ret
EnterFinish:
    stc
    ret
EnterPressed endp

SpecSymbsCheck proc near
    call ShiftPressed
    jnc  ShiftIsFree
    inc  ShiftIsPushed
    jmp  EndCheck
ShiftIsFree:
    call ShiftReleased
    jnc  EnterCheck
    dec  ShiftIsPushed
    jmp  EndCheck
EnterCheck:
    call EnterPressed
    jnc  EndCheck
    mov  ah, 09h
    lea  dx, ENTR
    int  21h
EndCheck:
    ret
SpecSymbsCheck endp
end start