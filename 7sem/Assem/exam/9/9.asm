Ideal
Model tiny
Dataseg

Path db 64 dup (?),  '$'

Codeseg
org 100h
proc main

;ПОИСК ИМЕНИ ФАЙЛА
mov ds, [2ch]
mov bx, 0

SEARCH_START:
add bx, 1
mov al, [bx]
cmp al,0
jne SEARCH_START
mov al, [bx+1]
cmp al, 1
jne SEARCH_START

mov di, -1
add bx, 2

TO_TAIL:
add bx,1
add di, 1
mov al, [bx]
cmp al, 0
mov cx, di
jne TO_TAIL

sub bx, di
sub bx, 1
mov di, -1
lea bp, CS:Path

SAVE:
add bx, 1
add di, 1
mov al, [bx]
mov [bp+di],al
cmp al, 0
jne SAVE
mov [bp + di], '$'
push cs
pop ds
xor cx, cx

push cx
mov ah, 9
lea dx, PATH
int 21h
mov ah, 4ch
INT 21h

endp main
end main
