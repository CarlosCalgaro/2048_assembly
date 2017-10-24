.model small

.stack 100H

.data

    SQUARE_LENGTH EQU 80
    SQUARE_HEIGHT EQU 50
    SCREEN_LENGTH EQU 320
    SCREEN_HEIGHT EQU 200

.code

    ESQ_QUAD proc ; AL= COR DO QUADRADO EM DW; DI = COME?O DO QUADRADO; 
        MOV BX, 0A000H
        MOV ES, BX
        MOV AH, AL
        
        MOV BX, 50;SQUARE_HEIGHT
restart:
        MOV CX, 40;SQUARE_LENGTH/2
        print_lbl:        
        stosw
        loop print_lbl
        SUB DI, 80
        ADD DI, 320
        DEC BX
        CMP BX, 0
        jz return
        jmp restart
return:        
        ret

    endp
;        cmp CX,1
;        jz nova_linha
;        jmp fim_loop
;nova_linha:
;        dec BX
;        cmp BX,1
;        jz return
;        sub DI, 80
;        add DI, 320
;        mov CX, 41
            
    inicio:
        MOV AX, @DATA
        MOV ES, AX

       
        MOV AX,13H ;TROCA PARA MODO GRAFICO
        INT 10H
        
        MOV AL, 03  
        XOR DI, DI
        call ESQ_QUAD
        
        
        MOV AL, 04  
        MOV DI, 80
        call ESQ_QUAD
        
        
        MOV AL, 03  
        MOV DI, 160
        call ESQ_QUAD
        
        MOV AL, 04 
        MOV DI, 240
        call ESQ_QUAD


        MOV AL, 05
        MOV DI, 16000
        call ESQ_QUAD
        
        
        MOV AL, 06
        MOV DI, 16080
        call ESQ_QUAD
        
        
        MOV AL, 07
        MOV DI, 16160
        call ESQ_QUAD
        
        MOV AL, 08
        MOV DI, 16240
        call ESQ_QUAD
        
        
        MOV AL, 010
        MOV DI, 32000
        call ESQ_QUAD
        
        
        MOV AL, 09
        MOV DI, 32080
        call ESQ_QUAD

        
        MOV AL, 11
        MOV DI, 32160
        call ESQ_QUAD
        
        
        MOV AL, 12
        MOV DI, 32240
        call ESQ_QUAD
        
        
        
        MOV AL, 03
        MOV DI, 48000
        call ESQ_QUAD
        
        MOV AL, 05
        MOV DI, 48080
        call ESQ_QUAD
        
        
        MOV AL, 06
        MOV DI, 48160
        call ESQ_QUAD
        
        
        
        MOV AL, 07
        MOV DI, 48240
        call ESQ_QUAD
        
        
        
        
        
                
        
        
        ; MOV AX, 08H
        ;int 21h
        
        MOV AX, 04C00H ;DESLIGA O PROGRAMA E RETORNA STATUS 0
        INT 21h
    
    end inicio