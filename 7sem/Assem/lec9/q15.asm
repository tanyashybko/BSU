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
    ; Выводим сообщение с просьбой ввести число
    mov ah, 09h
    lea dx, prompt
    int 21h

    ; Читаем число с клавиатуры
    mov ah, 0Ah
    lea dx, input
    int 21h

    ; Преобразуем символ в число
    sub byte [input + 1], '0'  ; Преобразуем ASCII в число
    mov al, [input + 1]         ; Загружаем число в AL
    mov ah, 0                   ; Очищаем AH для умножения
    imul ax                     ; Умножаем AX на AX, результат в AX
    mov [square], al            ; Сохраняем результат

    ; Выводим новую строку
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Выводим сообщение о квадрате
    mov ah, 09h
    lea dx, square_msg
    int 21h

    ; Выводим квадрат
    mov al, [square]
    add al, '0'                 ; Преобразуем обратно в ASCII
    mov dl, al
    mov ah, 02h                 ; Функция для вывода символа
    int 21h

    ; Изменяем функционал: выводим просто оригинальное число
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Выводим сообщение о изменении
    mov ah, 09h
    lea dx, change_msg
    int 21h

    ; Выводим оригинальное число
    mov al, [input + 1]
    add al, '0'                 ; Преобразуем обратно в ASCII
    mov dl, al
    mov ah, 02h
    int 21h

    ; Завершаем программу
    mov ax, 4C00h
    int 21h
main endp

end main