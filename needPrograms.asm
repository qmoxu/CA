;---------------------------------------------------------------
; StrLength     Count non-null characters in a string
;---------------------------------------------------------------
; Input:
;       di = address of string (s)
; Output:
;       cx = number of non-null characters in s
; Registers:
;       cx
;---------------------------------------------------------------
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




;---------------------------------------------------------------
; StrCompare    Compare two strings
;---------------------------------------------------------------
; Input:
;       si = address of string 1 (s1)
;       di = address of string 2 (s2) 
; Output:
;       flags set for conditional jump using jb, jbe,
;        je, ja, or jae.
; Registers:
;       none
;---------------------------------------------------------------
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




;---------------------------------------------------------------
; StrPos        Search for position of a substring in a string
;---------------------------------------------------------------
; Input:
;       si = address of substring to find
;       di = address of target string to scan
; Output:
;       if zf = 1 then dx = index of substring
;       if zf = 0 then substring was not found
;       Note: dx is meaningless if zf = 0
; Registers:
;       dx
;---------------------------------------------------------------
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




;---------------------------------------------------------------
; SubstringCount     Count occurrences of a substring in a string
;---------------------------------------------------------------
; Input:
;       si = address of substring to find
;       di = address of target string to scan
; Output:
;       cx = number of occurrences of substring in string
; Registers:
;       cx
;---------------------------------------------------------------
PROC    SubstringCount
        push    ax              ; Save modified registers
        push    bx
        push    cx
        push    dx

        xor     cx, cx          ; Initialize counter
        xor     dx, dx          ; Initialize substring position
@@10:
        call    StrPos          ; Find position of substring
        or      dx, dx          ; Check if substring found
        jz      @@20            ; If not found, exit loop
        inc     cx              ; Increment counter
        add     dx, 2           ; Move to next character
        add     di, dx          ; Move target string pointer
        xor     dx, dx          ; Reset substring position
        jmp     @@10            ; Repeat search loop

@@20:
        pop     dx              ; Restore registers
        pop     cx
        pop     bx
        pop     ax
        ret                     ; Return to caller
ENDP    SubstringCount


;---------------------------------------------------------------
; PrintDecimal      Print a decimal number to stdout
;---------------------------------------------------------------
; Input:
;       ax = decimal number to print
; Output:
;       Number printed to stdout
; Registers:
;       ax, bx, cx, dx
;---------------------------------------------------------------
PROC    PrintDecimal
        push    ax              ; Save modified registers
        push    bx
        push    cx
        push    dx

        mov     bx, 10          ; Initialize divisor
@@10:
        xor     dx, dx          ; Clear dx
        div     bx              ; Divide ax by 10
        push    dx              ; Save remainder on stack
        test    ax, ax          ; Check if quotient is zero
        jnz     @@10            ; If not, continue division

@@20:
        pop     ax              ; Retrieve remainder from stack
        add     al, '0'         ; Convert remainder to ASCII
        mov     dl, al          ; Move ASCII character to dl
        mov     ah, 02h         ; Function to print character
        int     21h             ; Print character to stdout
        cmp     sp, bp          ; Check if stack pointer reached base
        jne     @@20            ; If not, continue printing

        pop     dx              ; Restore registers
        pop     cx
        pop     bx
        pop     ax
        ret                     ; Return to caller
ENDP    PrintDecimal

read_next:
    mov ah, 3Fh
    mov bx, 0h  ; stdin handle
    mov cx, 1   ; 1 byte to read
    mov dx, offset oneChar   ; read to ds:dx 
    int 21h   ;  ax = number of bytes read
    ; do something with [oneChar]
    or ax,ax
    jnz read_next