%define SCAN_ESC    1
%define SCAN_LEFT   0x4B
%define SCAN_RIGHT  0x4D
%define SCAN_UP     0x48
%define SCAN_DOWN   0x50

DIR_LEFT    equ 0
DIR_RIGHT   equ 1
DIR_UP      equ 2
DIR_DOWN    equ 3

GET_INPUT:
    xor ax, ax
    int 0x16

    xchg al, ah
    cmp al, SCAN_ESC
    je SAIR
    cmp al, SCAN_LEFT
    je MOVE_LEFT
    cmp al, SCAN_RIGHT
    je MOVE_RIGHT
    cmp al, SCAN_UP
    je MOVE_UP
    cmp al, SCAN_DOWN
    je MOVE_DOWN
    jmp GET_INPUT

SAIR:
    mov cx, 0x0607
    ;call para modo texto 
    int 0x20

MOVE_LEFT:
    mov bl, DIR_LEFT
    jmp MOVER

MOVE_RIGHT:
    mov bl, DIR_RIGHT
    jmp MOVER

MOVE_UP:
    mov bl, DIR_UP
    jmp MOVER

MOVE_DOWN:
    mov bl, DIR_DOWN
    jmp MOVER
MOVER:
    ; TODO