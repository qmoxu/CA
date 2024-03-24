IDEAL
model small
stack 100h
DATASEG 
TailLen         EQU     0080h           ; Offset of param len byte
CommandTail     EQU     0081h           ; Offset of parameters
numParams       DW      ?               ; Number of parameters
params          DB      128 DUP (?)     ; 128-byte block for strings


substring_length db ?
substring db 128 dup(?)

CODESEG
proc MAIN
        mov     ax, @data               ; Initialize data segment
        mov     es, ax
        call   GetParams    
        mov ax, 04CH
        mov al, 00
        int 21h

endp MAIN

PROC    GetParams

;-----  Initialize counter (cx) and index registers (si,di)

        xor     ch, ch                  ; Zero upper half of cx
        mov     cl, [ds:TailLen]        ; cx = length of parameters
        inc     cx                      ; Include cr at end
        mov     si, CommandTail         ; Address parameters with si
        mov     di, offset params       ; Address destination with di

;-----  Skip leading blanks and tabs

@@10:
        call    Separators              ; Skip leading blanks & tabs
        jne     @@20                    ; Jump if not a blank or tab
        inc     si                      ; Skip this character
        loop    @@10                    ; Loop until done or cx=0

;-----  Copy parameter strings to global params variable

@@20:
        push    cx                      ; Save cx for later
        jcxz    @@30                    ; Skip movsb if count = 0
        cld                             ; Auto-increment si and di
        rep     movsb           ; copy cx bytes from ds:si to es:di

;-----  Convert blanks to nulls and set numParams

@@30:
        push    es                      ; Push es onto stack
        pop     ds                      ; Make ds = es
        pop     cx                      ; Restore length to cx
        xor     bx, bx                  ; Initialize parameter count
        jcxz    @@60                    ; Skip loop if length = 0
        mov     si, offset params       ; Address parameters with si
@@40:
        call    Separators              ; Check for blank, tab, or cr
        jne     @@50                    ; Jump if not a separator
        mov     [byte ptr si], 0        ; Change separator to null
        inc     bx                      ; Count number of parameters
@@50:
        inc     si                      ; Point to next character
        loop    @@40                    ; Loop until cx equals 0
@@60:
        mov     [numParams], bx         ; Save number of parameters
        ret                             ; Return to caller
ENDP    GetParams

PROC    Separators
        mov     al, [si]                ; Get character at ds:si
        cmp     al, 020h                ; Is char a blank?
        je      @@10                    ; Jump if yes
        cmp     al, 009h                ; Is char a tab?
        je      @@10                    ; Jump if yes
        cmp     al, 00Dh                ; Is char a cr?
@@10:
        ret                             ; Return to caller
ENDP    Separators
 
 PROC    ParamCount
        mov     dx, [numParams]         ; Get value from variable
        ret                             ; Return to caller
ENDP    ParamCount

END MAIN


