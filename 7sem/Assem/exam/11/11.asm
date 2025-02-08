Ideal
Model tiny
Dataseg

Path db 64 dup (?),  '$'
attribute db (?), ' ', '$'
tempNum db (?)
currentBit db 7

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
cmp al, '\'
jne Dalshe
mov cx, di

Dalshe:
cmp al, 0
jne TO_TAIL

sub di, cx
sub bx, di
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
mov ah, 43h
mov al, 00h
lea dx, PATH
int 21h

mov tempNum, al

loo:
mov ah, tempNum
shl ah, 7
shr ah, 7
add ah, 30h
mov attribute, ah
shr tempNum, 1

mov ah, 9h
lea dx, attribute
int 21h

sub currentBit, 1
cmp currentBit, -1
jne loo

mov ah, 4ch
INT 21h

endp main
end main