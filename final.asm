%macro write_string 2
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 0x80
%endmacro

%macro read_num 2
    mov eax, 3
    mov ebx, 0
    mov ecx, %1
    mov edx, %2
    int 0x80
%endmacro

section .text
    global _start

_start:
    write_string msg1, len1
    read_num num1, 10
    mov [num1Len], eax
    write_string msg2, len2  
    read_num num2, 10  
    mov [num2Len], eax

    ; Convert num1 to integer
    mov esi, num1 
    mov ecx, [num1Len]
    dec ecx
    xor edx, edx ; Initialize edx to 0
.parse_loop:
    movzx eax, byte [esi]
    sub eax, '0'
    imul edx, edx, 10
    add edx, eax
    inc esi
    loop .parse_loop

    mov [result1], edx

    ; Convert num2 to integer
    mov esi, num2 
    mov ecx, [num2Len]
    dec ecx
    xor edx, edx ; Initialize edx to 0
.parse_loop2:
    movzx eax, byte [esi]
    sub eax, '0'
    imul edx, edx, 10
    add edx, eax
    inc esi
    loop .parse_loop2

    mov [result2], edx

    mov eax, [result1]
    add eax, [result2]
    mov [sum], eax


    ; Convert the sum to a string
    mov eax, [sum]         ; Load the sum into eax
    mov ecx, 10           ; Set the base for conversion (decimal)
    mov edi, result_sum   ; Point edi to the result_sum buffer 
    add edi, 10           ; Move edi to the end of the buffer

convert_loop:
    xor edx, edx      ; Clear any previous remainder
    div ecx           ; Divide eax by 10, 
    add dl, '0'       ; Convert remainder to ASCII
    dec edi           ; Move buffer pointer back
    mov [edi], dl     ; Store ASCII character
    test eax, eax     ; Check if quotient is zero 
    jnz convert_loop  ; If not, continue the loop


    ; Print the result
    write_string msg3, len3
    mov eax, 4
    mov ebx, 1
    mov ecx, result_sum
    mov edx, 10
    int 0x80


    ; Exit
    mov eax, 1
    int 0x80

section .data
    msg1 db 'First number: '
    len1 equ $ -msg1

    msg2 db 'Second number: '
    len2 equ $ -msg2

    msg3 db 'Sum is: '
    len3 equ $ -msg3



section .bss
    num1 resb 10
    num2 resb 10
    result1 resb 10
    result2 resb 10

    num1Len resd 1
    num2Len resd 1

    sum resb 16

    result_sum resb 10
    result_sum_len resd 1