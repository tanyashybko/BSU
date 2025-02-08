.model small
.stack 100h
.data
    msg db "Press a key:$"         ; Сообщение для приглашения
    newline db 13, 10, '$'         ; Символы новой строки и возврата каретки
    code_msg db "Scan code (hex):$"
    char_msg db "Character pressed:$"
    scan_code db ?                 ; Переменная для скан-кода
    input_char db ?                ; Переменная для символа
    hex_output db "00$", 0         ; Буфер для 2-символьного HEX-кода

.code
main proc
    mov ax, @data
    mov ds, ax

    ; Выводим сообщение "Press a key" и переносим на новую строку
    mov ah, 09h
    lea dx, msg
    int 21h
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Читаем клавишу и получаем её скан-код и символ
    mov ah, 00h          ; Функция BIOS для получения символа и скан-кода
    int 16h              ; Вызов прерывания клавиатуры
    mov scan_code, ah    ; Сохраняем скан-код в переменную
    mov input_char, al   ; Сохраняем символ в переменную

    ; Печатаем сообщение "Character pressed:"
    mov ah, 09h
    lea dx, char_msg
    int 21h
    mov ah, 02h          ; Функция для вывода символа
    mov dl, input_char   ; Загружаем символ в DL
    int 21h              ; Выводим символ на экран

    ; Печатаем новую строку
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Выводим сообщение "Scan code (hex):"
    mov ah, 09h
    lea dx, code_msg
    int 21h

    ; Печатаем новую строку
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Преобразуем скан-код в шестнадцатеричный формат
    mov al, scan_code    ; Скан-код в AL
    call ByteToHex       ; Преобразование в HEX

    ; Печатаем HEX-код
    mov ah, 09h
    lea dx, hex_output
    int 21h

    ; Завершаем программу
    mov ah, 4Ch
    int 21h
main endp

; Процедура для преобразования байта в шестнадцатеричную строку
; Вход:
;   AL - байт для преобразования
; Выход:
;   hex_output - строка с шестнадцатеричным представлением байта
ByteToHex proc
    push ax             ; Сохраняем AX на стеке
    push bx             ; Сохраняем BX на стеке

    ; Обработка старшего полубайта
    mov ah, 0           ; Очистим AH
    mov bl, al          ; Сохраняем оригинальный байт
    shr al, 4           ; Сдвигаем старший полубайт в младший
    call NibbleToHex    ; Преобразуем полубайт в символ
    mov hex_output[0], al   ; Сохраняем символ в буфер

    ; Обработка младшего полубайта
    mov al, bl          ; Восстанавливаем оригинальный байт
    and al, 0Fh         ; Оставляем только младший полубайт
    call NibbleToHex    ; Преобразуем полубайт в символ
    mov hex_output[1], al   ; Сохраняем символ в буфер

    ; Завершаем строку нулевым символом (так как DOS требует строки с '$')
    mov hex_output[2], '$'

    pop bx              ; Восстанавливаем BX
    pop ax              ; Восстанавливаем AX
    ret
ByteToHex endp

; Процедура для преобразования полубайта (4 бита) в HEX-символ
; Вход:
;   AL - полубайт (0-15)
; Выход:
;   AL - ASCII-символ ('0'-'9' или 'A'-'F')
NibbleToHex proc
    cmp al, 9           ; Проверяем, является ли полубайт <= 9
    jbe ConvertToDigit  ; Если да, то это цифра
    add al, 7           ; Если нет, добавляем 7 (для перехода от '9' к 'A')
ConvertToDigit:
    add al, '0'         ; Преобразуем в ASCII-символ
    ret
NibbleToHex endp

end main
