.model small
.stack 100h
.data

string db 255 dup(0)
len db 0
handle dw 0h
.code
main proc

read_line:
mov len, 0
read_char:
    mov ah, 3Fh ; read from file
    mov bx, handle ; stdin handle
    mov cx, 1   ; read 1 byte
    mov dx, offset string   ; read into string
    add dl,len; specify the position to store the next character
    int 21h   
    inc len
    mov bx, dx               ; move the address of the string to bx
    cmp byte ptr [bx], 0Ah   ;chech if its end of file
    je endF ; end of line
    cmp byte ptr [bx], 0Dh    ;chech if its end of file
    je endF ; end of line
    or ax, ax                ; check if its a new line
    jnz read_char 
endF:
    mov ah, 4Ch
    int 21h  
main endp
end main