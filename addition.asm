section .data
    first_num db "Enter the first number (0-9) "        
    len_first_num equ $ - first_num     

    second_num db "Enter the second number (0-9) "      
    len_second_num equ $ - second_num           

    disp_prompt db "The Sum is "                
    len_disp_prompt equ $ - disp_prompt 

    oversized_prompt db "The Sum is too large (over 99) "                
    len_oversized_prompt equ $ - oversized_prompt         ;

    invalid_input_prompt db "The input is empty / invalid. Program exit! "                
    len_invalid_input_prompt equ $ - invalid_input_prompt         ;

section .bss
    first resb 1
    second resb 1
    sum resb 1
    ten resb 1
    rem resb 1

section .text

global _start   
_start:         ; start label
    ; Prompt for the first input
    mov eax, 4      ; sys_write system call
    mov ebx, 1      ; stdio
    mov ecx, first_num      ; ecx=first_num
    mov edx, len_first_num  ; edx=len_first_num
    int 0x80        
    
    ; Read first input value
    mov eax, 3      ; sys_read system call
    mov ebx, 0      ; stdio
    mov ecx, first      
    mov edx, 2
    int 0x80

    ; validate first_num input
    ; if (first < 0 || first = ' '): prg exit
    mov al, [first]
    sub al, '0'
    cmp al, 0
    jl invalidInput ; jump to invalidInput label with the input < 0 or empty
    
    ; Prompt for the second input
    mov eax, 4      ; sys_write system call
    mov ebx, 1      
    mov ecx, second_num     ; ecx=second_num
    mov edx, len_second_num ; edx=len_second_num
    int 0x80
    
    ; Read second input value
    mov eax, 3      ; sys_read system call
    mov ebx, 0      
    mov ecx, second     
    mov edx, 2
    int 0x80

    ; validate second_num input
    ; if (second < 0 || second = ' '): prg exit
    mov al, [second]
    sub al, '0'
    cmp al, 0
    jl invalidInput  ; jump to invalidInput label with the input < 0 or empty

    mov eax,  [first]       ; Moving first value to accumulator
    sub eax, '0'        ; Converting to ASCII value
    mov ebx,  [second]      ; Moving second value to ebx
    sub ebx, '0'        ; Converting to ASCII value
    add eax, ebx        ; Adding the numbers in registers
    add eax, '0'        ; Converting to ASCII value
    mov [sum], eax      ; Storing the result in sum

    ; compare sum 
    mov al, [sum]
    sub al, '0'
    cmp al, 100
    jl print ; jump to print label if sum < 100

    ; Prompt if sum > 99
    mov eax, 4      ; sys_write system call
    mov ebx, 1      ; stdio
    mov ecx, oversized_prompt        ; ecx=disp_prompt
    mov edx, len_oversized_prompt    ; edx=len_disp_prompt
    int 0x80
    jmp exit

print:
    ; Prompt for sum
    mov eax, 4      ; sys_write system call
    mov ebx, 1      ; stdio
    mov ecx, disp_prompt        ; ecx=disp_prompt
    mov edx, len_disp_prompt    ; edx=len_disp_prompt
    int 0x80

    xor ah, ah      ; clear the high byte of eax
    mov al, [sum]   ; Moving value of sum into AL register
    sub al, '0'     ; Converting to ASCII value
    mov bl, 10      ; Giving BL(lower byte of EBX) value 10
    div bl          ; AL / BL
    add al, '0'     ; Converting to ASCII value
    mov [ten], al   ; Storing the result in ten
    add ah, '0'     ; Converting to ASCII value
    mov [rem], ah   ; Storing the remainder in rem
    
    ; Display the tens digit
    mov eax, 4
    mov ebx, 1
    mov ecx, ten
    mov edx, 1
    int 0x80
    
    ; Display the ones digit
    mov eax, 4
    mov ebx, 1
    mov ecx, rem
    mov edx, 1
    int 0x80
    jmp exit

invalidInput:
    ; Prompt for invalid input
    mov eax, 4      ; sys_write system call
    mov ebx, 1      ; stdio
    mov ecx, invalid_input_prompt        ; ecx=disp_prompt
    mov edx, len_invalid_input_prompt    ; edx=len_disp_prompt
    int 0x80
    jmp exit

exit:
    mov eax , 1     ; sys_exit system call
    mov ebx , 0     ; setting exit status
    int 0x80        ; Calling interrupt handler to exit program