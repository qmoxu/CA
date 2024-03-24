IDEAL
MODEL COMPACT
STACK 100H
DATASEG 

smallLine db 'aa', 0
big db 'aaa', 0 
ASCNull         EQU     0 

CODESEG
proc MAIN
MOV AX,@DATA
MOV DS,AX

mov di, offset big

mov si, offset smallLine
call StrLength
MOV AH,4CH
INT 21H   
endp MAIN

PROC    StrCompare
        push    ax              ; Save modified registers
        push    di
        push    si
        cld                     ; Auto-increment si
@@10:
        lodsb                   ; al <- [si], si <- si + 1
        scasb                   ; Compare al and [di]; di <- di + 1
        jne     @@20            ; Exit if non-equal chars found
        or      al, al          ; Is al=0? (i.e. at end of s1)
        jne     @@10            ; If no jump, else exit
@@20:
        pop     si              ; Restore registers
        pop     di
        pop     ax
        ret                     ; Return flags to caller
ENDP    StrCompare

PROC    StrPos
        push    ax              ; Save modified registers
        push    bx
        push    cx
        push    di

        call    StrLength       ; Find length of target string
        mov     ax, cx          ; Save length(s2) in ax
        xchg    si, di          ; Swap si and di
        call    StrLength       ; Find length of substring
        mov     bx, cx          ; Save length(s1) in bx
        xchg    si, di          ; Restore si and di
        sub     ax, bx          ; ax = last possible index
        jb      @@20            ; Exit if len target < len substring
        mov     dx, 0ffffh      ; Initialize dx to -1
@@10:
        inc     dx              ; For i = 0 TO last possible index
        mov     cl, [byte bx + di]      ; Save char at s[bx] in cl
        mov     [byte bx + di], ASCNull ; Replace char with null
        call    StrCompare              ; Compare si to altered di
        mov     [byte bx + di], cl      ; Restore replaced char
        je      @@20            ; Jump if match found, dx=index, zf=1
        inc     di              ; Else advance target string index
        cmp     dx, ax          ; When equal, all positions checked
        jne     @@10            ; Continue search unless not found

        xor     cx, cx          ; Substring not found.  Reset zf = 0
        inc     cx              ;  to indicate no match
@@20:
        pop     di              ; Restore registers
        pop     cx
        pop     bx
        pop     ax
        ret                     ; Return to caller
ENDP    StrPos

 PROC    StrLength
        push    ax              ; Save modified registers
        push    di

        xor     al, al          ; al <- search char (null)
        mov     cx, 0ffffh      ; cx <- maximum search depth
        cld                     ; Auto-increment di
        repnz   scasb           ; Scan for al while [di]<>null & cx<>0
        not     cx              ; Ones complement of cx
        dec     cx              ;  minus 1 equals string length

        pop     di              ; Restore registers
        pop     ax
        ret                     ; Return to caller
ENDP    StrLength
END MAIN