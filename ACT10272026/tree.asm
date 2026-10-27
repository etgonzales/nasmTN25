%macro PRINT_LINE 2
    mov ecx, %1          
    mov edx, %2          
    call print_line      
%endmacro

section .data
line1 db "                         I", 10
line1_len equ $ - line1

line2 db "                       wrote", 10
line2_len equ $ - line2

line3 db "                      a poem", 10
line3_len equ $ - line3

line4 db "                   in the shape", 10
line4_len equ $ - line4

line5 db "                  of a Christmas", 10
line5_len equ $ - line5

line6 db "               tree but then forgot", 10
line6_len equ $ - line6

line7 db "             to water it and only a few", 10
line7_len equ $ - line7

line8 db "                        days", 10
line8_len equ $ - line8

line9 db "                        later", 10
line9_len equ $ - line9

line10 db "", 10
line10_len equ $ - line10

line11 db "                       there", 10
line11_len equ $ - line11

line12 db "                   were", 10
line12_len equ $ - line12

line13 db "                             words", 10
line13_len equ $ - line13

line14 db "        all", 10
line14_len equ $ - line14

line15 db "                              over", 10
line15_len equ $ - line15

line16 db "             the", 10
line16_len equ $ - line16

line17 db "                                         carpet", 10
line17_len equ $ - line17

section .text
global _start

print_line:
    mov eax, 4             
    mov ebx, 1             
    int 0x80
    ret

_start:
    PRINT_LINE line1, line1_len
    PRINT_LINE line2, line2_len
    PRINT_LINE line3, line3_len
    PRINT_LINE line4, line4_len
    PRINT_LINE line5, line5_len
    PRINT_LINE line6, line6_len
    PRINT_LINE line7, line7_len
    PRINT_LINE line8, line8_len
    PRINT_LINE line9, line9_len
    PRINT_LINE line10, line10_len
    PRINT_LINE line11, line11_len
    PRINT_LINE line12, line12_len
    PRINT_LINE line13, line13_len
    PRINT_LINE line14, line14_len
    PRINT_LINE line15, line15_len
    PRINT_LINE line16, line16_len
    PRINT_LINE line17, line17_len

    mov eax, 1             ; sys_exit
    mov ebx, 0             ; exit status
    int 0x80