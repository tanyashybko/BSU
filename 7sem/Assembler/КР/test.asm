.model small
.stack 100h

.data
    DTA       db 43 dup(0)
    finddata  db '????????.???', 0
    msg_err   db 'No files found!$'
    newline   db 13, 10, '$'
    fullpath  db 80 dup(0), '$'

.code
start:
    mov ax, @data
    mov ds, ax
    mov es, ax

    mov ah, 1Ah
    mov dx, offset DTA
    int 21h

    mov ah, 4Eh
    mov cx, 0
    lea dx, finddata
    int 21h
    jc no_files

    mov fullpath[0], 'C'
    mov fullpath[1], ':'
    mov fullpath[2], '\'

    mov ah, 47h
    mov dl, 0
    lea si, fullpath[3]
    int 21h
    jc no_files

    lea di, fullpath + 3
    
add_to_end:
        lodsb
        stosb
        cmp al, 0
        jnz add_to_end

    dec di
    cmp byte ptr [di-1], '\'
    je skip_slash

    mov byte ptr [di], '\'
    inc di

skip_slash:
    lea si, [DTA+30]
append_filename:
        lodsb
        stosb
        cmp al, 0
        jnz append_filename

    mov byte ptr [di-1], '$'

    lea dx, fullpath
    mov ah, 09h
    int 21h

    lea dx, newline
    mov ah, 09h
    int 21h

    jmp exit

no_files:
    mov ah, 09h
    lea dx, msg_err
    int 21h

exit:
    mov ax, 4C00h
    int 21h
end start