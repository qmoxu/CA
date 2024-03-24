IDEAL
model small
stack 100h
dataseg
string db 255 dup(0)
lenght db 0
handle dw 0h
CODESEG
proc main

read_line:
mov length, 0 ; reset length

read_char:
    mov ah, 3Fh ; read from file
    mov bx, handle ; stdin handle
    mov cx, 1   ; read 1 byte
    mov dx, offset string   ; read into string
    add dl, lenght       ; specify the position to store the next character
    int 21h   
    inc lenght   
    mov bx, dx               ; move the address of the string to bx
    cmp byte ptr [bx], 0Ah   ;chech if its end of file
    je end ; end of line
    cmp byte ptr [bx], 0Dh    ;chech if its end of file
    je end ; end of line
    or ax, ax                ; check if its a new line
    jnz read_char 


end:
    mov ah, 4Ch
    int 21h
    
main endp
end main
