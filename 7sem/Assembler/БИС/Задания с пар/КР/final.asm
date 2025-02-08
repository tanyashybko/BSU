.MODEL TINY
.CODE
.STARTUP
ORG 100H
	INT 16H
	XCHG AL, AH 
    MOV AH, 0
    MOV BX, 10 
    MOV CX, 0
TOSTACK:
    MOV DX, 0 
    DIV BX          
    ADD DX, 30h     
    PUSH DX         
    INC CX          
    TEST AX, AX     
    JNZ TOSTACK
PRINT:
    POP DX          
    MOV AH, 02h       
    INT 21h
    CMP CX, 0
LOOP PRINT  
    MOV AH,4CH
	INT 21H
END
