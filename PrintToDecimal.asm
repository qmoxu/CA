.model SMALL
.stack 100H
.data

.code
    MAIN PROC
        MOV AX, @DATA
        MOV DS, AX
        
    MAIN ENDP

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

END MAIN
