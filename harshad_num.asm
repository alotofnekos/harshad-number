
%include "io.inc"
section .text
section .data
    prompt db "Enter a positive integer: ", 0
    error_not_number db "Error: Invalid input.", 0
    error_negative db "Error: negative number input.", 0
    continue db "Do you want to continue (Y/N)?", 0
    success db "Harshad number: Yes", 0
    failure db "Harshad number: No", 0
    print db "Digits:",0
    comma db ",",0
    sum db "Sum of digits: ",0
    quotient db "Quotient: ",0
    remainder db "Remainder: ",0
    STRING times 255 db 0 
global CMAIN
CMAIN:
    MOV ebp, esp ; for correct debugging
.loop:
    NEWLINE 
    MOV EAX, 0
    MOV ECX, 0
    MOV EDX, 0
    MOV EBX, 0
    MOV EDI, 0
    PRINT_STRING prompt
    GET_STRING STRING,255
    MOV EAX, STRING
    MOV ESI, EAX
    JMP .is_valid
.dis:
    NEWLINE
    PRINT_STRING sum
    PRINT_DEC 4, EDI ; print the sum of digits
    MOV EAX, ESI
    JMP .quo
.quo:
    MOV EDX, 0 ; clear EDX for DIV operation
    MOV EAX, ESI
    DIV EDI ;EAX, EDX
    MOV ESI, EAX
    NEWLINE
    PRINT_STRING quotient
    PRINT_DEC 4, ESI 
    NEWLINE
    PRINT_STRING remainder
    PRINT_DEC 4, EDX 
    CMP EDX, 0
    JE .success
    JNZ .fail
.success:
    NEWLINE 
    PRINT_STRING success
    NEWLINE 
    JMP .cont
.fail:
    NEWLINE 
    PRINT_STRING failure
    NEWLINE 
    JMP .cont
.cont:
    XOR EAX, EAX 
    PRINT_STRING continue
    GET_STRING STRING,255
    MOV EAX, STRING
    CMP byte [eax], "Y"
    JE .loop
    CMP byte[eax], "N"
    JE .done
    JMP .cont
.done:
    XOR EAX, EAX ; set EAX to 0
    RET ; return
.write:  
    mov ebx, 10 ; divisor for extracting digits
    xor ecx, ecx ; counter for number of digits printed
    mov edx, 0 ; remainder
    jmp .extract_digit
.extract_digit:
    xor edx, edx ; clear eax for division
    div ebx ; divide by 10, quotient in eax, remainder in edx
    push edx ; save remainder on stack
    inc ecx ; increment digit counter
    test eax, eax ; check if quotient is zero
    jnz .extract_digit 
.print_digits:
    pop eax ; retrieve digit from stack
    ADD EDI,EAX
    PRINT_DEC 4, eax ; print digit
    dec ecx ; decrement digit counter
    test ecx, ecx ; check if all digits have been printed
    jz .dis
    PRINT_STRING comma
    jmp .print_digits
.is_valid:
    mov bl, byte [eax + ecx] ; load next character
    cmp bl, 10
    je .valid
    cmp bl, 0 ; end of string
    je .valid
    cmp bl, '-'
    je .minus
    cmp bl, 48 ; check if character is less than '0'
    jb .not_numeric
    cmp bl, 57 ; check if character is greater than '9'
    ja .not_numeric
    inc ecx 
    cmp ecx, 255 
    je .valid 
    jmp .is_valid
.valid:
    PRINT_STRING print
    MOV EBX, 0
    MOV ECX, 0
    JMP .str_to_int
.not_numeric:
    PRINT_STRING error_not_number
    jmp .loop
.neg:
    PRINT_STRING error_negative
    jmp .loop  
.minus:
    cmp ecx, 0
    je .neg
    jmp .not_numeric
.str_to_int:
    xor eax, eax     ; Initialize EAX to 0
    mov ecx, esi     ; Copy ESI to ECX for iteration
.loop_conv:
    movzx edx, byte [ecx] ; Load the current character into EDX
    cmp edx, '0'
    jl .pre_write         ; Exit loop if not a digit
    cmp edx, '9'
    jg .pre_write
    sub edx, '0'     ; Convert ASCII value to digit value
    imul eax, 10     ; Multiply current value of EAX by 10
    add eax, edx     ; Add the value of the digit to EAX
    inc ecx          ; Increment ECX to move to the next character
    jmp .loop_conv
.pre_write:
    mov ESI, EAX
    mov ECX, 0
    mov EDX, 0
    jmp .write
    ret

