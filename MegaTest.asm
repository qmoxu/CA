.MODEL SMALL
.STACK 100H
.DATA 

BUFFER DB 255 DUP('$') ; Буфер для зберігання рядка

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    ; Відкриття файлу для читання
    MOV AH, 3DH
    MOV AL, 0 ; Режим читання
    INT 21H    

    ; Отримання дескриптора файлу
    MOV BX, AX
    
    ; Читання з файлу
READ:
    MOV AH, 3FH ; Функція читання з файлу
    MOV CX, 1 ; Читати 1 байт
    LEA DX, BUFFER ; Зберегти результат у буфер
    MOV BX, AX ; Використати дескриптор файлу
    INT 21H
    JC END_READ ; Якщо помилка читання (EOF або інша помилка), завершити
    
    ; Виведення зчитаного байта на екран
    MOV AH, 02H ; Функція виведення символу
    MOV DL, BUFFER ; Символ для виведення
    INT 21H
    
    JMP READ ; Повторити читання
    
END_READ:
    ; Закриття файлу
    MOV AH, 3EH ; Функція закриття файлу
    MOV BX, AX ; Використати дескриптор файлу
    INT 21H
    
    JMP FINISH ; Завершити програму
    
FINISH:
    MOV AH, 4CH
    INT 21H   
MAIN ENDP
END MAIN 