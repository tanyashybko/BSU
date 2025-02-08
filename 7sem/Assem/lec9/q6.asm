.model small
.stack 100h

.data
FName db 'q6.asm', 0       ; Имя файла
OblVvoda db 'Filename: $', 0 ; Буфер для вывода имени файла
HandleFile db 'Handle: $', 0 ; Буфер для вывода Handle файла
Handle db ?                  ; Хранение Handle файла (8-битное значение)

.code
start:
    mov ax, @data
    mov ds, ax

    ; Открыть файл
    mov ah, 3Dh              ; Функция для открытия файла
    xor al, al               ; Открыть для чтения
    lea dx, FName            ; Указатель на имя файла
    int 21h                  ; Вызов DOS
    mov Handle, al           ; Сохранить Handle файла

    ; Вывести имя файла
    mov ah, 9                ; Функция для вывода строки
    lea dx, OblVvoda         ; Указатель на строку "Filename: "
    int 21h                  ; Вызов DOS

    lea dx, FName            ; Указатель на имя файла
    int 21h                  ; Вызов DOS

    ; Вывести Handle файла
    mov ah, 9                ; Функция для вывода строки
    lea dx, HandleFile       ; Указатель на строку "Handle: "
    int 21h                  ; Вызов DOS

    ; Преобразование Handle в строку для вывода
    mov al, Handle           ; Получаем Handle
    call PrintNumber          ; Печатаем Handle

    ; Завершить программу
    mov ah, 4Ch
    xor al, al
    int 21h

; Процедура вывода 8-битного числа в строковом формате
PrintNumber proc
    push ax
    push dx
    push cx

    ; Проверяем, равен ли Handle нулю
    cmp al, 0
    je PrintZero

    ; Преобразуем AL в строку
    mov cx, 10               ; Основание для деления
    xor dx, dx               ; Обнуляем остаток
    mov bx, 0                ; Счетчик символов

    ; Деление на 10
PrintLoop:
    xor dx, dx
    div cx                   ; Делим AX на 10
    push dx                  ; Сохраняем остаток
    inc bx                   ; Увеличиваем счетчик
    test al, al
    jnz PrintLoop            ; Повторяем, пока не станет нулем

    ; Печатаем символы в обратном порядке
PrintDigits:
    pop dx                   ; Извлекаем остаток
    add dl, '0'              ; Преобразуем в символ
    mov ah, 2
    int 21h                  ; Выводим символ
    dec bx                   ; Уменьшаем счетчик
    jnz PrintDigits          ; Печатаем следующий символ

    pop cx
    pop dx
    pop ax
    ret

PrintZero:
    mov dl, '0'              ; Если число ноль
    mov ah, 2
    int 21h                  ; Выводим символ '0'

    pop cx
    pop dx
    pop ax
    ret
PrintNumber endp

end start