.model small
.stack 100h

.data
    prompt db 'Enter file name to delete: $'
    filename db 100, 0  ; Buffer for file name (max 100 characters)
    success_msg db 0Dh, 0Ah, 'File deleted successfully!$'
    error_msg db 0Dh, 0Ah, 'Error deleting file!$'

.code
start:
    ; Инициализация сегмента данных
    mov ax, @data
    mov ds, ax

    ; Вывод подсказки
    mov ah, 09h
    lea dx, prompt
    int 21h

    ; Ввод имени файла
    mov ah, 0Ah
    lea dx, filename
    int 21h

    ; Удаление символа новой строки (0Dh)
    mov al, filename[1]   ; Длина введенной строки
    mov cl, al            ; Сохраняем длину строки
    lea si, filename + 2  ; Начало строки (пропуск первых 2 байтов)
    mov di, si            ; Указатель для формирования итоговой строки

remove_newline:
    lodsb                 ; Загружаем следующий символ
    cmp al, 0Dh           ; Проверяем, является ли это символ новой строки
    je end_remove_newline ; Если да, завершаем цикл
    stosb                 ; Иначе записываем символ в строку
    loop remove_newline   ; Переходим к следующему символу

end_remove_newline:
    mov byte ptr [di], 0  ; Добавляем NULL-терминатор в конце строки

    ; Удаление файла
    lea dx, filename + 2  ; Указатель на имя файла
    mov ah, 41h           ; Функция удаления файла
    int 21h

    ; Проверка успешности операции
    jc error              ; Если ошибка, переход к обработке

    ; Успешно завершено
    mov ah, 09h
    lea dx, success_msg
    int 21h
    jmp done              ; Завершение программы после вывода

error:
    ; Сообщение об ошибке
    mov ah, 09h
    lea dx, error_msg
    int 21h

done:
    ; Завершение программы
    mov ah, 4Ch
    int 21h

end start
