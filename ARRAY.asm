.model small
.stack 100h
.data
    input_cnt   db 20       ; Значення для input_cnt
    line_cnt    db 0       ; Значення для line_cnt
    inputs      dw 10 DUP(?) ; Масив inputs

.code
main PROC
    mov ax, @data       ; Ініціалізуємо сегмент даних
    mov ds, ax

    mov cx, 10          ; Завантажуємо лічильник циклу
    mov bx, offset inputs  ; Завантажуємо адресу масиву inputs в регістр BX
    mov ah, input_cnt    ; Завантажуємо значення змінної input_cnt в AL
    mov al, line_cnt    ; Завантажуємо значення змінної line_cnt в AH

fill_array:
    mov [bx], al        ; Записуємо значення AL в поточну комірку масиву
    sub ah, 2           ; Збільшуємо значення AL на 2
    adc al, 1           ; Збільшуємо значення AH на 1, якщо був перенос з AL
    mov [bx + 1], ah    ; Записуємо значення AH в наступну комірку масиву

    add bx, 2           ; Переходимо до наступної комірки масиву
    loop fill_array     ; Повторюємо, поки не заповнимо всі 10 комірок масиву

    ; Ваш код тут для подальшої обробки масиву, якщо потрібно

    mov ax, 4C00h       ; Завершуємо програму
    int 21h
main ENDP

END main