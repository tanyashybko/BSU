.MODEL SMALL
.Data
CONST16	DB	16
HEXSYM	DB	'0123456789ABCDEF'
PATTERN	DB	'XX_$'
CODSYM	DB	?
WRTLN   DB  0ah, '$'


.CODE
.STARTUP

	MOV	AX, 40h
	MOV	ES, AX

	MOV		CODSYM, 0
	MOV		CX, 16

PRTABLE:
	PUSH	CX	 
	MOV		CX, 16		
POVT :

	MOV		AL, CODSYM

	;------------------------------

	MOV		AH, 0
	DIV		CONST16
	MOV		BX,  Offset HexSym
	XLAT
	MOV		PATTERN, AL
	MOV		AL, AH
	XLAT
	MOV		PATTERN + 1, AL
	MOV		ah, 9
	LEA		DX, PATTERN
	INT		21h

	;-------------------------------

	MOV		BH, ES: [ 62h ] ; активная видеостраница
	MOV		BL, 0 ; цвет символа
	MOV		AH, 10 ; номер функции
	MOV		AL, CODSYM ; код символа
	PUSH    CX 
	MOV		CX, 1 ; кол-во выводимых символов
	INT		10h

	MOV		AH, 03
	INT		10h
	; определили месторасположение курсора
	MOV		AH, 02
	ADD		DL, 2
	INT		10h
	; передвинули курсор
	ADD		CODSYM, 16  

	POP		CX
LOOP    POVT	
	POP		CX	
	INC CODSYM
	MOV     AH, 9
    LEA     DX, WRTLN
    INT     21h 
LOOP	PRTABLE

	MOV		AH, 4ch
	INT 	21h
	END