; =============================

; EARL GONZALES TN25 ASCII ART

; NASM 32-bit Linux

; =============================

section .data
    hat db "    .------\ /------.", 10
        db "    |       -       |", 10
        db "    |               |", 10
        db "    |               |", 10
        db "    |               |", 10
    hat_len equ $ - hat

    underscore db "_"
    newline db 10

    face db "===========.===========", 10
         db "  / ~~~~~     ~~~~~ ", 92, 10
         db " /|     |     |", 92, 10
         db " W   ---  / \  ---   W", 10
         db ' \.      |o o|      ./', 10
         db '  |                 |', 10
         db '  \    #########    /', 10
         db '   \  ## ----- ##  /', 10
         db '    \##         ##/', 10
         db '     \_____v_____/', 10
    face_len equ $ - face

section .text
    global _start

print_String:
    mov eax, 4
    mov ebx, 1
    mov ecx, esi
    int 0x80
    ret

_start:
    mov esi, hat
    mov edx, hat_len
    call print_String

    mov edi, 23

one_loop:
    mov esi, underscore
    mov edx, 1
    call print_String
    dec edi
    jnz one_loop

    mov esi, newline
    mov edx, 1
    call print_String

    mov esi, face
    mov edx, face_len
    call print_String

    mov eax, 1
    xor ebx, ebx
    int 0x80