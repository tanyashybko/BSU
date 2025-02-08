.MODEL Small
.DATA
    iter    DB 0
    num     DB '?', '$'
    hexRow  DB ' 0x??', '$'
    newRow  DB 13, 10, '$'
    text    DB 'Code: ', '$'
.CODE
START:
    MOV AX, @DATA
    MOV DS, AX

LOOP_START:
    CMP iter, 32
    JE LOOP_END

    LEA DX, text
    MOV AH, 9
    INT 21h

    MOV DL, iter
    MOV AH, 2
    INT 21h

    MOV DL, ' '
    INT 21h

    MOV AL, iter
    MOV AH, 0
    MOV CX, 4

HEX_CONVERT:
    SHL AL, 4
    MOV BL, AL
    SHR BL, 4
    CMP BL, 9
    JG HEX_LETTER
    ADD BL, '0'
    JMP HEX_PRINT
HEX_LETTER:
    ADD BL, 'A' - 10
HEX_PRINT:
    MOV DI, OFFSET hexRow
    ADD DI, CX
    MOV [DI], BL
    LOOP HEX_CONVERT

    LEA DX, hexRow
    MOV AH, 9
    INT 21h

    LEA DX, newRow
    MOV AH, 9
    INT 21h

    INC iter
    JMP LOOP_START

LOOP_END:
    MOV AH, 4Ch
    INT 21h
END START
