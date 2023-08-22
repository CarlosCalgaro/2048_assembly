
.model small

.stack 900H


.data
    
    Tabuleiro dw  1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16;4 DUP( 4 DUP(0H)); INICIALIZA O TABULEIRO 4x4 COM 0
    String db 80
.code
    
   include basico.asm

    
   
   
    ESC_LINHA proc
        ;RECEBE O ENDERECO DA LINHA EM SI
        PUSH DI
        PUSH CX
        PUSH BX
        PUSH AX
        MOV CX, 4
        L_INICIO:
            MOV BX, 4
            SUB BX, CX
            shl BX, 1
            LEA DI, [SI + BX]
            MOV AX, DS:[DI]
            call UINT16_STR
            call ESC_STR
            loop L_INICIO
        pop AX
        pop BX
        pop CX
        POP DI
        ret
    endp
    
    ESC_MATRIZ proc
        MOV CX, 4
        M_INICIO:
            MOV SI, offset Tabuleiro
            MOV AX, 4
            MOV BX, 4
            SUB AX, CX
            MUL BX
            MOV BX, AX
            shl BX, 1
            lea SI, DS:[SI + BX]
            call ESC_LINHA
  ;        loop M_INICIO
        ret
    endp
    
    MATRIZ proc
        MOV CX, 1
        XOR BX, BX
        MOV AX, 4
        MUL BX
        MOV BX, AX
        shl BX, 1
        lea SI, DS:[Offset Tabuleiro + BX]
        call ESC_LINHA
    endp
    
    main:
        mov AX, @DATA
        mov ES, AX
        mov DS, AX
        
        MOV AX,13H ;TROCA PARA MODO GRAFICO
        INT 10H
        
        
        CALL MATRIZ

        MOV AX, 04C00H ;DESLIGA O PROGRAMA E RETORNA STATUS 0
        INT 21h    
    end main
