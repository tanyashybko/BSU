.MODEL TINY
.CODE
ORG 100H

START:

	MOV	DX, OFFSET FName
	CALL	OPEN_FILE	

	CALL	GET_FILE_LENGTH	
	MOV	FLen, AX	

	PUSH	BX		

FIND_ALL_SYMBOLS:

	mov	ax, 4200h
	POP	BX
	PUSH	BX
	xor	cx, cx
	mov	dx, Count	
	int	21h
	inc	Count
	
	MOV	AX, Count
	CMP	AX, FLen
	JE	END_FILE

	mov	ah, 3Fh
	mov	cx, 1
	mov	dx, offset Symbol	
	int	21h

	CMP	AX, 0
	JE	END_FILE

	MOV	AL, 2Ah
	CMP	AL, Symbol
	JE	SHIFT_START

	MOV	AL, 170
	CMP	AL, Symbol
	JE	SHIFT_END

	MOV	CX, SymbolsLen
FIND_SYMBOL:		
	MOV	AX, CX
	SUB	AL, 1
	mov	bx,  offset Codes
	xlat
	CMP	AL, Symbol
	JE	SYMBOL_FOUND
	SUB	CX, 1

	CMP	CX, 65535
	JE	SYMBOL_NOT_FOUND
	JMP 	FIND_SYMBOL

SYMBOL_FOUND:
	MOV	AX, 0
	CMP	AX, Shift
	JE	WITHOUT_SHIFT

	mov	bx, offset ShiftSymbols
	JMP	CONT

WITHOUT_SHIFT:
	mov	bx, offset Symbols

CONT:
	MOV	AX, CX
	SUB	AX, 1
	xlat

	MOV	AH, 02H
	MOV	DX, AX
	INT	21H
	JMP	FIND_ALL_SYMBOLS

SHIFT_START:
	MOV	Shift, 1
	JMP	FIND_ALL_SYMBOLS

SHIFT_END: 
	MOV	Shift, 0
	JMP	FIND_ALL_SYMBOLS

SYMBOL_NOT_FOUND:
	JMP	FIND_ALL_SYMBOLS
	
END_FILE:
	POP	BX
	CALL	CLOSE_FILE	

	MOV	AX, 4C00H
	INT	21H

FName		DB	'myfile.bin', 0
Symbol		DB	1 dup (?)
Codes		DB	29h, 02h, 03h, 04h, 05h, 06h, 07h, 08h
		db 	09h, 0Ah, 0Bh, 0Ch, 0Dh, 2Bh, 10h, 11h
		db 	12h, 13h, 14h, 15h, 16h, 17h, 18h, 19h
		db 	1Ah, 1Bh, 1Eh, 1Fh, 20h, 21h, 22h, 23h
		db 	24h, 25h, 26h, 27h, 28h, 2Ch, 2Dh, 2Eh
		db 	2Fh, 30h, 31h, 32h, 33h, 34h, 35h, 39h
Symbols		DB	"`1234567890-=\qwertyuiop[]asdfghjkl;'zxcvbnm,./ "
SymbolsLen 	= $ - Symbols
ShiftSymbols 	db 	'~!@#$%^&*()_+|QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>? '
Count		DW	0
FLen		DW	0
Shift		DW	0

OPEN_FILE PROC NEAR 		
	MOV	AX, 3D00H
	INT	21H
	MOV	BX, AX
	RET
OPEN_FILE ENDP

CLOSE_FILE PROC NEAR 		
	MOV	AH, 3EH
	INT	21H
	RET
CLOSE_FILE ENDP

GET_FILE_LENGTH PROC NEAR 	
	MOV	AX, 4202H
	XOR	CX, CX
	XOR	DX, DX
	INT	21H
	RET
GET_FILE_LENGTH ENDP

END START
