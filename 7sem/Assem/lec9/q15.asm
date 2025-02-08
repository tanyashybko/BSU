.model small
.stack 100h

.data
    prompt db 'Enter a number (0-9): $'
    square_msg db 'Square: $'
    input db 2 dup(0)   ; Buffer for input
    square db 0          ; Variable to store the square
    newline db 0Dh, 0Ah, '$'  ; New line
    change_msg db 'Changed output: $'

.code
main proc
    ; ������� ��������� � �������� ������ �����
    mov ah, 09h
    lea dx, prompt
    int 21h

    ; ������ ����� � ����������
    mov ah, 0Ah
    lea dx, input
    int 21h

    ; ����������� ������ � �����
    sub byte [input + 1], '0'  ; ����������� ASCII � �����
    mov al, [input + 1]         ; ��������� ����� � AL
    mov ah, 0                   ; ������� AH ��� ���������
    imul ax                     ; �������� AX �� AX, ��������� � AX
    mov [square], al            ; ��������� ���������

    ; ������� ����� ������
    mov ah, 09h
    lea dx, newline
    int 21h

    ; ������� ��������� � ��������
    mov ah, 09h
    lea dx, square_msg
    int 21h

    ; ������� �������
    mov al, [square]
    add al, '0'                 ; ����������� ������� � ASCII
    mov dl, al
    mov ah, 02h                 ; ������� ��� ������ �������
    int 21h

    ; �������� ����������: ������� ������ ������������ �����
    mov ah, 09h
    lea dx, newline
    int 21h

    ; ������� ��������� � ���������
    mov ah, 09h
    lea dx, change_msg
    int 21h

    ; ������� ������������ �����
    mov al, [input + 1]
    add al, '0'                 ; ����������� ������� � ASCII
    mov dl, al
    mov ah, 02h
    int 21h

    ; ��������� ���������
    mov ax, 4C00h
    int 21h
main endp

end main