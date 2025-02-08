.model small
.stack 100h

.data
message db 'Mama', 10, 'Mila', 13, 'ramu', '10', 13, '$'

.code
main proc
    mov ax, @data
    mov ds, ax

    mov ah, 09h
    lea dx, message
    int 21h

    mov ah, 4Ch
    int 21h

main endp
end main
