.model small

.stack 100H

.data

SQUARE_LENGTH EQU 80
SQUARE_HEIGHT EQU 50

QUAD    DD

.code

    ESC_QUAD proc ; AL= COR DO QUADRADO EM DW; DI = COME?O DO QUADRADO; 
        push AX
        push BX
        push CX
        push DI
        push ES
        
        MOV BX, 0A000H
        MOV ES, BX
        MOV AH, AL
        MOV CX, 40
        MOV BX, 50
    DUMP:
        stosw
        CMP CX, 1
        JE LINHA
        JMP FIM_LOOP
    LINHA:
        cmp BX, 0
        JE FIM_LOOP
        mov CX, 41 
        SUB DI, 80
        add DI, 320
        dec BX
    FIM_LOOP:
        loop DUMP
    RETO:
        pop ES
        pop DI
        pop CX
        pop BX
        pop AX    
        ret
    endp
    
    main:
        MOV AX, @DATA
        MOV ES, AX

       
        MOV AX,13H ;TROCA PARA MODO GRAFICO
        INT 10H
       
        ;mov AX,03H ;TROCA PARA MODO GRAFICO
        ;int 10H
        
        mov AL, 02H
        mov DI, 0
        call ESC_QUAD

        mov AL, 11
        mov DI, 80
        call ESC_QUAD
        
        mov AL, 13
        mov DI, 160
        call ESC_QUAD
        
        mov AL, 12
        mov DI, 240
        call ESC_QUAD
        
        MOV AX, 08H
        int 21h
        
        MOV AX, 04C00H
        INT 21h
    END main