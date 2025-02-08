.model tiny
.code
org 100h
main:
    mov ah, 01h
    int 21h
    sub al, '0'
    mov dl, al
    mov ah, 02h
    int 21h
    mov ah, 4Ch
    int 21h
end main
