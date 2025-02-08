.model tiny
.stack 100h

.data
    msg db 'Searching for HOG.COM in HOG...$'
    found_msg db 'File HOG.COM found! Restoring...$'
    not_found_msg db 'File HOG.COM not found.$'
    filename db 'HOG\HOG.COM', 0
    backup_filename db 'HOG\HOG_RESTORED.COM', 0
    buffer db 512 dup(0)
    file_found db 0

.code
start:
    mov ax, @data
    mov ds, ax

    mov ah, 09h
    lea dx, msg
    int 21h

    call find_file

    cmp file_found, 0
    je file_not_found

    mov ah, 09h
    lea dx, found_msg
    int 21h

    call restore_file

    jmp exit_program

file_not_found:
    mov ah, 09h
    lea dx, not_found_msg
    int 21h

exit_program:
    mov ax, 4C00h
    int 21h

find_file:
    mov ah, 4Eh
    lea dx, filename
    int 21h
    jc file_not_found

    mov file_found, 1
    ret

restore_file:
    mov ah, 3Dh
    mov al, 0
    lea dx, filename
    int 21h
    jc file_not_found

    mov bx, ax

    mov ah, 3Ch
    lea dx, backup_filename
    int 21h
    jc file_not_found

    mov di, ax

read_loop:
    mov ah, 3Fh
    lea dx, buffer
    mov cx, 512
    int 21h
    jc done

    mov ah, 40h
    mov cx, ax
    lea dx, buffer
    int 21h
    jmp read_loop

done:
    mov ah, 3Eh
    int 21h
    mov ah, 3Eh
    int 21h
    ret

end start
