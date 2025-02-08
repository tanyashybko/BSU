.Model Small
.Data
CONST16	DB	16
ROW_ITERATION DB ?
COLUMN_ITERATION DB ?
CURRENT_CODE DB ?
.code
.STARTUP
    mov ax,3
    int 10h
	
	MOV	AX, 40h
	MOV	ES, AX
	
	MOV ROW_ITERATION, 0
	MOV COLUMN_ITERATION, 0
	MOV CURRENT_CODE, 0
	
cycle:
	;ADD ROW CURSOR
	mov COLUMN_ITERATION, 0
	
inner_cycle:
		INC 	CURRENT_CODE
		
		;PRINT CHARACTER
		MOV		BH, ES: [ 62h ]
		MOV		BL, 0
		MOV		AH, 0ah      
		MOV		AL, CURRENT_CODE	
		MOV		CX, 1
		INT		10h
	
		;ADD COLUMN CURSOR
		MOV		AH, 03h
		INT		10h
		MOV		AH, 02h
		ADD 	dl, 3
		INT		10h
		
		INC COLUMN_ITERATION
		
		cmp COLUMN_ITERATION, 16
		jne inner_cycle
	
    MOV		AH, 03h
	INT		10h
	MOV		AH, 02h
	add		dh, 1
	mov		dl, 0
	INT		10h	
	
	INC ROW_ITERATION	
	cmp ROW_ITERATION, 16
	jne cycle
	
conclusion:
	MOV		AH, 4ch
	INT 	21h	
end
