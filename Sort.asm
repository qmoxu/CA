.model small
.STACK 100h
.DATA
line_array DW 0,1,2,3
count_array DW 3, 2, 6, 4
count DW 4 
.CODE 
main proc 
    mov ax, @data
    mov ds, ax
    mov cx, word
outerLoop:
    push cx
    lea si, count_array
innerLoop:
    mov ax, [si]
    cmp ax, [si+2]
    jl nextStep
    xchg [si+2], ax
    mov [si], ax
nextStep:
    add si, 2
    loop innerLoop
    pop cx
    loop outerLoop
    mov ax, 4C00h 
    int 21h
main endp
end main
