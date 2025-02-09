; Sample x64 Assembly Program 
extrn      MessageBoxA: PROC 
.data 
caption       db          '64-bit hello!', 0 
message     db          'Hello World!', 0 
.code 

Start proc   
    sub     rsp,28h               	; shadow space, aligns stack  
    mov     rcx, 0                  	; hWnd = HWND_DESKTOP  
    lea     rdx, message      	; LPCSTR lpText   
    lea     r8,  caption          	; LPCSTR lpCaption   
    mov     r9d, 0                    	; uType = MB_OK   
    call    MessageBoxA  ; call MessageBox API function   
;  mov    ecx, eax     ; uExitCode = MessageBox(...)   
    mov     message+6,'h'
    mov     message+7,'e'
    mov     message+8,'l'
    mov     message+9,'l'
    mov     message+10,'!'
    mov caption+11,'!'
 ; add    rsp,28h      		; shadow space, aligns stack  
    mov     rcx, 0       		; hWnd = HWND_DESKTOP  
    lea     rdx, message 	; LPCSTR lpText   
    lea     r8,  caption 	; LPCSTR lpCaption   
    mov     r9d, 0       		; uType = MB_OK   
    call    MessageBoxA  	; call MessageBox API function   
; call ExitProcess 
Start endp
end