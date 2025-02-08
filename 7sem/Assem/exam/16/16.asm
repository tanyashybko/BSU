.model small
.stack 100h

.data
    msg_read db 'Reading the executable file...$'
    msg_modify db 0Dh, 0Ah, 'Modifying the executable file...$'
    msg_done db 0Dh, 0Ah, 'Modification completed. Restart to see changes.$'
    self_file db '16.exe', 0  ; Имя файла программы
    mod_data db 'Original data.$', 0  ; Исходные данные для замены
    new_data db 'Modified data.', 0  ; Новая строка (ASCII)

.code
start:
    ; Инициализация сегмента данных
    mov ax, @data
    mov ds, ax

    ; Вывод сообщения о чтении файла
    mov ah, 09h
    lea dx, msg_read
    int 21h

    ; Открытие самого себя
    lea dx, self_file    ; Указатель на имя файла
    mov ah, 3Dh          ; Функция открытия файла
    mov al, 02h          ; Режим чтения-записи
    int 21h
    jc error_open        ; Переход при ошибке

    mov bx, ax           ; Дескриптор файла сохраняется в BX

    ; Перемещение указателя на начало данных для изменения
    mov cx, 0            ; Высокая часть смещения
    mov dx, offset mod_data ; Абсолютное смещение секции данных
    mov ah, 42h          ; Функция перемещения указателя
    mov al, 00h          ; Смещение от начала файла
    int 21h
    jc error_seek        ; Переход при ошибке

    ; Запись новых данных
    lea dx, new_data     ; Указатель на новые данные
    mov cx, 14           ; Размер строки (13 символов + NULL-терминатор)
    mov ah, 40h          ; Функция записи в файл
    int 21h
    jc error_write       ; Переход при ошибке

    ; Закрытие файла
    mov ah, 3Eh
    int 21h

    ; Сообщение об успешном завершении
    mov ah, 09h
    lea dx, msg_done
    int 21h
    jmp done

error_open:
    mov ah, 09h
    lea dx, msg_modify
    int 21h
    jmp done

error_seek:
    mov ah, 09h
    lea dx, msg_modify
    int 21h
    jmp done

error_write:
    mov ah, 09h
    lea dx, msg_modify
    int 21h

done:
    ; Завершение программы
    mov ah, 4Ch
    int 21h

end start
