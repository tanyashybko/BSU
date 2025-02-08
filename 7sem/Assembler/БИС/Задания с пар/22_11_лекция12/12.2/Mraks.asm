.model TINY
.data
OblVvoda        db      15,?,15 dup (?)
.code
.STARTUP
ORG 100H
        mov ax, 0
        mov [cs:0112h], ax
        mov [cs:0117h], ax
        mov     ah,10
        lea     dx,OblVvoda
        int     21h
        mov     OblVvoda+12,'P'
        mov     OblVvoda+14,'P'
        mov     ah,9
        lea     DX,OblVvoda+2
        mov     OblVvoda+16,'$'
        int     21h
        mov     ah,4ch
        int     21h
END