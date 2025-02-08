;====================== AntiDHog.asm ======================================
;====================== Переместить указатель в файле =====================
MoveFPos macro F_Handle, FPos
    mov ax, 4200h
    mov bx, F_Handle
    xor cx, cx
    mov dx, FPos
    int 21h
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
;====================== S U B R O U T I N E ===============================
    public start
start proc near
    PutStr TitleStr
;====================== Поставить DTA =====================================
    mov ah, 1Ah
    mov dx, offset DTA
    mov cx, 27h
    int 21h
;==========================================================================
    mov ah, 4Eh
    mov dx, offset a_MaskForVir ;Поиск первого файла по маске *.*
    int 21h
BegScan:
;====================== Переслать имя в переменную FName ==================
    push ds
    pop es
    mov si,FN_Ofs
    mov di, offset FName
    mov cx, 13
    rep movsb
;==========================================================================
    mov ah, 43h
    mov al, 0
    mov dx, offset FName ;Получить атрубуты найденного файла
    int 21h
    mov ah, 43h
    mov al, 1
    mov dx, offset FName
    mov cl, 0 ;Сбросить атрибуты
    int 21h
    mov ax, 3D10h
    mov dx, offset FName ;Открыть файл-жертву для записи/чтения
    int 21h
    mov FHandle, ax
    mov ah, 40h
    mov cl, 44h
    nop
    nop
; Выдать имя файла
    call InfoAboutFile
; Проверка сигнатуры
    call ReadSignature
    cmp SignatureFound, 0
    je NextFile
; Записать в начало команду int 20h
    call KillExecutable
; Стереть файл
    call RemoveExecutable

NextFile:
    call CureInfo
    mov ah, 4Fh ; Искать следующий
    int 21h
    jnb BegScan ; Пока есть непроверенные файлы, крутимся в этом цикле
    int 20h
start endp

;==========================================================================

a_MaskForVir    db  '*.*', 0 ; Маска в формате ASCIIZ
DTA db 43 dup (0)
FN_Ofs  equ offset DTA+1Eh
FName   db 128 dup(0)
IName db 128 dup(0)
SignatureFound db 0
SignatureArray db 14 dup(0)
VirSignature    db 0CDh, 21h, 0B4h, 43h, 0B0h, 01h, 0BAh
                db 9Eh, 00h, 0B1h, 0h, 0CDh, 21h, 0B8h
Int20cmd    db 0CDh, 20h
FHandle dw 0
TitleStr    db '+---------------------------+', 13, 10
            db 'AntiDHog - antivirus example!', 13, 10
            db '+---------------------------+', 13, 10, '$'
NormStr db ' - Ok', 13, 10, '$'
CureStr db ' - has been deleted!', 13, 10, '$'

;==========================================================================
; Прочесть и проверить сигнутуру вируса

ReadSignature proc near
; Сбросить флаг найденной сигнатуры
    mov SignatureFound, 0
; Переместить указатель на смещение 0Eh
    MoveFPos FHandle 0Eh
; Прочесть первые 68 байт вируса
    mov ah, 3Fh
    mov bx, FHandle
    mov cx, 14
    mov dx, offset SignatureArray
    int 21h
; Проверить чтение
    cld
    push ds
    pop es
    mov si, offset VirSignature
    mov di, offset SignatureArray
    mov cx, 14
repe cmpsb
    jnz Finish
; Сигнатура найдена!
    mov SignatureFound, 1
Finish: 
    ret 
ReadSignature endp

KillExecutable proc near
; Переместить указатель
    MoveFPos FHandle 0
; "Убить" файл
    mov ah, 40h 
    mov bx, FHandle
    mov cx, 2
    mov dx, offset Int20cmd
    int 21h
; Закрыть файл
    mov ah, 3Eh
    mov bx, FHandle
    int 21h
    ret
KillExecutable endp

RemoveExecutable proc near
; "Вытереть" файл
    mov ah, 41h
    mov dx, offset FName
    int 21h
    ret
RemoveExecutable endp

InfoAboutFile proc near
    push ds
    pop es
    mov si, offset FName
    mov di, offset IName
NextChar: 
    lodsb
    stosb
    cmp al, 0
    jne NextChar
    dec di
    mov byte ptr [di], '$'
    PutStr IName
    ret
InfoAboutFile endp

CureInfo proc near
    mov ah, 9
    mov dx, offset NormStr
    cmp SignatureFound, 0
    je ContMsg
    mov dx, offset CureStr
ContMsg: 
    int 21h
    ret 
CureInfo endp

seg000 ends
end start