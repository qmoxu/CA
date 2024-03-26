.model small
.stack 100h
.data
line DB "aaaaa bbaa", 0
param DB "aaa", 0
param_length DB 3
occurrences DW 100 DUP(?)
occurrences_length dw ?

.code 
main PROC 
    mov ax, @data
    mov ds, ax
    call findParams
    mov ax, 4C00h
    int 21h
main ENDP
findParams PROC
    xor cx, cx
    mov bx, offset line
outer_loop:
    mov si, bx
    mov di, offset param
    mov dh, param_length
inner_loop:
    mov al, [si]
    cmp al, [di]
    jne noParam
    inc si
    inc di
    dec dh
    jnz inner_loop
    inc bx
    inc cx
noParam:
    inc bx
    cmp byte ptr [bx], 0
    jnz outer_loop

    mov si, offset occurrences
    mov bx, occurrences_length
    shl bx, 1
    add si, bx
    mov [si], cx
    inc occurrences_length
    ret
findParams ENDP
end main