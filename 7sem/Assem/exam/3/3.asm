.model tiny
.code
main:
	mov word ptr cs:command, 0h
	mov al, 1
command:
	add al, 1

	mov ah, 02h
	mov dl, al
	add dl, 30h
	int 21h

finish:
	mov ah, 1h
	int 21h
	mov ah, 04Ch
	int 21h
end main