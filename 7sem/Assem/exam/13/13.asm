.MODEL SMALL
.STACK 100H

.DATA
    filename DB '8.EXE', 0
    fileOffset DD 1234  ; смещение, где вы хотите изменить байт
    newByte  DB 0FFh  ; новое значение байта

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; Открыть файл
    MOV AH, 3DH
    LEA DX, filename
    MOV AL, 2   ; открыть для записи
    INT 21H
    MOV BX, AX  ; сохранить дескриптор файла

    ; Установить указатель файла на нужное место (смещение)
    MOV AH, 42H    ; функция 42H - установка смещения
    MOV AL, 0      ; смещение от начала файла
    MOV CX, word ptr fileOffset  ; младшее слово смещения
    MOV DX, word ptr fileOffset + 2 ; старшее слово смещения
    INT 21H

    ; Записать новое значение байта
    MOV AH, 40H
    MOV BX, AX  ; используем дескриптор файла
    LEA DX, newByte
    MOV CX, 1   ; записать один байт
    INT 21H

    ; Закрыть файл
    MOV AH, 3EH
    INT 21H

    ; Завершение программы
    MOV AH, 4CH
    INT 21H
MAIN ENDP

END MAIN
