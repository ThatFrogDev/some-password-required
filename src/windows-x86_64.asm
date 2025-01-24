; A very simple password generator written in pure Assembly.
; Copyright © 2025 Mart (@ThatFrogDev) on GitHub.

; The .data section stores all read-only variables.
section .data
    WELCOME_MESSAGE: db "Welcome to Some Password Required", 10, "Here is your generated password:", 10, 0 ; db saves an ASCII version of this string into memory. 10 is a newline character.
    PASSWD_LEN: equ 6 ; equ defines a number constant
    PASSWD: times PASSWD_LEN db 0 ; times creates a block of memory with a length of PASSWD_LEN, filled with 0s.

    ; TODO: Make separate arrays for symbols, letters of alphabet and numbers so people can choose what they want
    CHARACTERS: db "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ123456789~`!@#$%^&*();:-+,<.>/?"    
    CHAR_LEN: equ $ - CHARACTERS
    PRINTF_FORMAT: db "%c", 0

; The .bss section stores uninitialized data structures.
section .bss
    result resq 1

; All executable code goes into the .text section.
section .text
    global _start
    extern printf, ExitProcess

_start:
    ; Allocate space for the function call. Before calling a function, you must ensure that the stack is 16-byte aligned.
    ; rsp is 16-byte aligned by default, but a function call takes 8 bytes of space on the stack. 
    ; To ensure that the stack stays aligned by 16 bytes, we subtract 28h (40 bytes; 0x28 in hex) from the stack pointer.
    sub     rsp, 28h
    mov     rcx, WELCOME_MESSAGE ; RCX is the argument for the printf function.
    call    printf
    mov     ebx, PASSWD_LEN ; Set the "loop counter" to PASSWD_LEN (we use ebx since ecx is already used for something else)
gen_passwd_loop:
    rdtsc                       ; rdtsc: Read Time-Stamp Counter, output in EDX:EAX
    xor     edx, edx            ; clear EDX
    mov     ecx, CHAR_LEN       ; this is used so we know how much we need to loop over
    div     ecx                 ; divides EDX:EAX by ECX
    mov     [rel result], edx   ; EDX = [0, CHAR_LEN - 1]

    lea     rcx, [rel CHARACTERS] ; lea = load effective address: loads the address of CHARACTERS (rip-relative) and stores it in RCX
    mov     edx, [rel result]     ; -> RDX = [0, CHAR_LEN - 1]
    movzx   edx, byte [rcx + rdx] ; movzx = move with zero extend: moves byte [RCX + RDX] into EDX, filling the rest with 0s
    mov     rcx, PRINTF_FORMAT    ; this is used to ensure that it won't return a newline (by default it does) when a character is printed
    call    printf                ; call printf() with the format in RCX

    dec     ebx                   ; decreases EBX, our "loop counter"
    jnz     gen_passwd_loop       ; jump to the start if EBX isn't zero

    add     rsp, 28h            ; restore the stack pointer
    xor     ecx, ecx            ; clear ECX, or, in other words: ECX is now 0, the argument needed to call our ExitProcess(0)
    call    ExitProcess         ; call ExitProcess(0) because ECX is 0