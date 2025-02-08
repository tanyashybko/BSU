.model   small
.data
Zu  dw  "ßÄ"
ZuZU    dw  255 dup (?)
.code
UU:	     
    MOV     ax,@data
	MOV     ds,ax
    LEA     DX, Zu
	MOV     ah, 10
	INT     21h
	MOV     ah,4ch
 	INT	    21h
    END     UU
