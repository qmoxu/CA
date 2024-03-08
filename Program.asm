.model small
.stack 100h
.code 
main proc
    mov ax, 1
    xor ax,ax
    int 21h
main endp
end main