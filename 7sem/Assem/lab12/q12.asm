.model small
.data
Zu db "Ÿ„"
ZuZU dw 255 dup (?)
.code
YAD:
 MOV  AX, @data
 MOV  DS, AX
 LEA DX, Zu
 MOV ah, 10
 INT 21h
 end YAD