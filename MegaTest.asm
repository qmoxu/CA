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
              mov lineLenght, 0                
    read_char:
              mov ah, 3Fh                     ; читаємо з файлу
              mov bx, handle                  ; вказуємо на файл
              mov cx, 1                       ;1 байт
              mov dx, offset line          
              add dl, lineLenght
              int 21h
              inc lineLenght
    
              mov bx, dx                      ; вказуємо на зчитаний байт
              cmp byte ptr [bx], 0Ah          
              je  eof                       ; якщо кінець
              cmp byte ptr [bx], 0Dh        
              je  eof                         ; якщо кінець
              or  ax, ax                      ; нова лінія
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