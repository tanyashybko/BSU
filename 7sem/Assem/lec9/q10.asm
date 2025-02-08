.model small
.stack 100h

.data
    FHandle dw 1          ; Дескриптор файла (должен быть открыт)
    FileOffset dw 0Eh     ; Смещение, используем для обозначения позиции

.code
; Макрорасширение для MoveFPos
MoveFPos MACRO FHandle, FileOffset
    mov ah, 42h            ; Функция DOS для установки позиции файла
    mov bx, FHandle        ; Дескриптор файла
    mov cx, FileOffset     ; Смещение
    int 21h                ; Вызов DOS
ENDM

main PROC
    ; Инициализация сегмента данных
    mov ax, @data
    mov ds, ax

    ; Пример использования макроса
    ; Убедитесь, что FHandle действительно открыт
    MoveFPos FHandle, FileOffset

    ; Завершение программы
    mov ax, 4C00h
    int 21h
main ENDP

END main