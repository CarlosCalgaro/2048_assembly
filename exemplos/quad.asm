.model small

.stack 100H

.data

SQUARE_LENGTH EQU 80
SQUARE_HEIGHT EQU 50

VIDEO_CARD_SEGMENT EQU 0A000H

.code

    ESC_QUAD proc ; AL= COR DO QUADRADO EM DW; DI = COME?O DO QUADRADO; 
        push AX
        push BX
        push CX
        push DI
        push ES
        ; ELE ESCREVE 2 bytes por vez
        MOV BX, VIDEO_CARD_SEGMENT
        MOV ES, BX
        MOV AH, AL
        MOV CX, 41
        MOV BX, 51
        
write:
        stosw
        CMP CX, 1
        JZ new_line
        jmp end_of_loop
new_line:
        CMP BX, 0
        JE RETURN
        MOV CX, 41
        SUB DI, 81
        ADD DI, 320
        DEC BX 
end_of_loop: 
        loop write
return:
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

        ;mov AX,03H ;TROCA PARA MODO NORMAL
        ;int 10H
        
        mov AL, 02H
        mov DI, 0
        call ESC_QUAD

        ;mov AL, 11
        ;mov DI, 80
        ;call ESC_QUAD
        
        ;mov AL, 13
        ;mov DI, 160
        ;call ESC_QUAD
        
        ;mov AL, 12
        ;mov DI, 240
        ;     call ESC_QUAD

        
        MOV AX, 08H
        int 21h
        
        MOV AX, 04C00H
        INT 21h
    END main