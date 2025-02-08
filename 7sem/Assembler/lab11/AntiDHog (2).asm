MoveFPos macro F_Handle, FPos
    mov  ax, 4200h
    mov  bx, F_Handle
    xor  cx, cx
    mov  dx, FPos
    int  21h
    endm
    
PutStr macro Text
	mov ah,09h
	mov dx,offset Text
	int 21h
endm

seg000 segment byte public 'CODE'
    assume cs:seg000
    org 100h
    assume es:nothing, ss:nothing, ds:seg000

public start
start    proc near
    PutStr TitleStr
    mov ah, 1ah
    mov dx, offset DTA    
    mov cx, 27h
    int 21h

    mov ah,4eh
    mov dx,offset a_MaskForVir
    int 21h

    mov ax, offset DTA

BegScan:
    	push	ds
	pop 	es
	mov 	si,FN_Ofs
	mov 	di,offset FName
	mov 	cx,13
	rep 	movsb

	mov 	ah,43h
	mov 	al,0
	mov 	dx,offset FName
	int 	21h

	mov 	ah,43h
	mov 	al,1
	mov 	dx,offset FName
	xor	cx, cx
	int 	21h

	mov 	ax,3d02h
	mov 	dx,offset FName
	int 	21h

	mov 	FHandle,ax
	mov 	ah,40h
	mov 	cl,44h
	nop
	nop

	call InfoAboutFile
        
	call 	ReadSignature
	cmp 	SignatureFound, 0
	je	NextFile

	call 	ClearFile
	call 	KillExecutable
	call 	RemoveExecutable

NextFile:
	call 	CureInfo

	mov 	ah,4fh
	int 	21h
	jnb 	BegScan
        call    FreeMem
	int 	20h
start endp

a_MaskForVir 	db 	'*.*', 0
DTA 		db 	43 dup(0)
FN_Ofs 		equ 	offset DTA+1eh
FSize_Ofs	equ 	offset DTA+1ah
FName 		db 	128 dup(0)
IName 		db 	128 dup(0)
SignatureFound 	db 	0
SignatureArray 	db 	14 dup(0)
VirSignature 	db 	0cdh,21h,0b4h,43h,0b0h,01h,0bah
		db 	9eh,00h,0b1h,00h,0cdh,21h,0b8h
Int20Cmd 	db 	0cdh,20h
FHandle 	dw 	0
FSize		dw	0	; первые 2 байта размера файла
FSize2		dw	0   ; вторые 2 байта размера файла
FCurPos		dw	0
Zero 		db	0
TitleStr 	db 	'+----------------------------+',13,10
		db 	'|AntiDHog - antivirus example|',13,10
		db 	'+----------------------------+',13,10,'$'
NormStr 	db 	' - Ok',13,10,'$'
CureStr 	db 	' - deleted!',13,10,'$'

ReadSignature proc near
	mov SignatureFound,0
	MoveFPos FHandle 0eh
	mov ah,3fh
	mov bx,FHandle
	mov cx,14
	mov dx,offset SignatureArray
	int 21h
	
	cld
	push ds
	pop es
	mov si, offset VirSignature
	mov di, offset SignatureArray
	mov cx,14

	repe cmpsb
	jnz Finish

	mov SignatureFound,1
	
Finish:
	ret
	ReadSignature endp

KillExecutable proc near
	MoveFPos FHandle 0
	mov ah,40h
	mov bx,FHandle
	mov cx,2
	mov dx,offset Int20Cmd
	int 21h
	
	mov ah,3eh
	mov bx,FHandle
	int 21h
	ret
KillExecutable endp

RemoveExecutable proc near
	mov ah,41h
	mov dx,offset FName
	int 21h
	ret
RemoveExecutable endp

InfoAboutFile proc near
	push ds
	pop es
	mov si,offset FName
	mov di,offset IName
	
NextChar:
	lodsb
	stosb
	cmp al,0
	jne NextChar
	dec di
	mov byte ptr [di],'$'
	PutStr IName
	ret
InfoAboutFile endp

CureInfo proc near
	mov ah,9
	mov dx,offset NormStr
	cmp SignatureFound,0
	je ContMsg
	mov dx,offset CureStr
	
ContMsg:
	int 21h
	ret
CureInfo endp

FreeMem proc near
	mov ah, 49h
        int 21h
	ret
FreeMem endp

ClearFile proc near
	push	ds
	pop 	es
	mov 	si, FSize_Ofs + 2		
	mov 	di, offset FSize2
	mov 	cx,2
	rep 	movsb

	mov cx, FSize2	
	cmp cx, 0
	je NoBlocks	; размер файла меньше 65536 байт

NextBlock:
	push cx
	mov cx, 0
NextByteInBlock:
	mov  ax, 4200h
	mov  bx, FHandle 
	mov dx, cx
	dec dx
	pop cx
	dec cx
	int  21h

	inc dx
	push dx
	inc ax
	push ax

	mov ah, 40h
	mov bx, FHandle
	mov cx, 1
	mov dx, offset Zero
	int 21h
	
	pop cx
	loop NextByteInBlock
	
	pop cx
loop NextBlock

NoBlocks:
	push	ds
	pop 	es
	mov 	si, FSize_Ofs
	mov 	di, offset FSize
	mov 	cx,2
	rep 	movsb

	mov cx, FSize

NextByte:
	mov  ax, 4200h
	mov  bx, FHandle 
	mov dx, cx
	dec dx
	mov cx, FSize2
	int  21h

	inc ax
	push ax

	mov ah, 40h
	mov bx, FHandle
	mov cx, 1
	mov dx, offset Zero
	int 21h
	
	pop cx
loop NextByte
	ret
ClearFile endp

seg000 ends
end start
