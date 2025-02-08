.MODEL TINY
.CODE
ORG 100H

START:
	mov ah,4Eh
	mov dx,228h
	int 21h

    ;9eh было для имени
    mov al, ds:[95h]
    ;mov al, 20h

PRINT_RESULT:
	MOV BX,2660

    CMP AX, 0
    JE FINISH

PRINT_SYMBOL:
	DIV BL
    CMP AL, 0
    JE SKIP_ZERO
FINISH:
	ADD AL,'0'
	INT 29H
SKIP_ZERO:
	MOV AL,AH
	MUL BH
	CMP AL,0
	JNE PRINT_SYMBOL

	MOV AH,4CH
	INT 21H

FILE_NAME DB 256 DUP('$')
a_MaskForVir db '*.*',0

END START
