.MODEL TINY
.CODE
.STARTUP
ORG 100H
	mov ax, 00h
	mov [cs:0113h], ax
	XOR AX,AX
	INT 16H
	SUB AL,'0'
	MUL AL
	CMP AL,16
	JG PRINT_RESULT
	MUL AL

PRINT_RESULT:
	MOV BX,2660

PRINT_SYMBOL:
	DIV BL
	ADD AL,'0'
	INT 29H
	MOV AL,AH
	MUL BH
	CMP AL,0
	JNE PRINT_SYMBOL

	MOV AH,4CH
	INT 21H
END
