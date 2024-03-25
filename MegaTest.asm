.model small
.stack 100h
.data
line    db 255 dup(0)
lineLenght db 0
handle    dw 0h
.code
main proc
oneLine:
              mov ax, @data
              mov ds, ax
              mov lineLenght, 0                ; reset length
    read_char:
              mov ah, 3Fh                     ; read from file
              mov bx, handle                  ; stdin handle
              mov cx, 1                       ; read 1 byte
              mov dx, offset line           ; read into line
              add dl, lineLenght
                           ; specify the position to store the next character
              int 21h
              inc lineLenght
    
              mov bx, dx                      ; move the address of the line to bx
              cmp byte ptr [bx], 0Ah          ;chech if its end of file
              je  eof                       ; end of line
              cmp byte ptr [bx], 0Dh          ;chech if its end of file
              je  eof                         ; end of line
              or  ax, ax                      ; check if its a new line
              jnz read_char
    eof: 
    mov ah, 40h
    mov cx, word ptr [lineLenght]
    mov bx, 1
    mov dx, offset line
    int 21h
    mov ah, 4Ch
    int 21h
main endp
end main