.MODEL small
.STACK 100h
.DATA
    input_cnt   db 20      
    line_cnt    db 0      
    inputs      dw 10 DUP(?) 

.CODE
main PROC
    mov ax, @data       
    mov ds, ax

    mov cx, 10          
    mov bx, offset inputs  
    mov al, input_cnt    
    mov ah, line_cnt   

fill_array:
    mov [bx], ax       
    add bx, 2          
    sub ah, 2          
    adc al, 0          
    loop fill_array     


    mov cx, 10
outerLoop:
    push cx
    lea si, inputs
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
main ENDP

END main
