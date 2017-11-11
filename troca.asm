;; PRINT STRING LENGTH


.model small

.stack 900H


.data
    
    Tabuleiro dw  1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0;4 DUP( 4 DUP(0H));0FFFH,0BCDH,0AAAH,12357,51511,61353,7,8,9,10,11,12,13,14,15,163
    String db 80
.code
    
   include basico.asm
   include contr.asm
   
   TROCAR Proc
    ;SI ORIGEM
    ;DI DESTINO
    push SI
    push DI
    push AX
    push BX
    MOV SI, offset Tabuleiro 
    MOV AX, [SI]
    MOV BX, [DI]
    MOV [SI], BX
    MOV [DI], AX
    pop BX
    pop AX
    pop DI
    pop SI
    ret
   endp
   
   main:
        mov AX, @DATA
        mov ES, AX
        mov DS, AX
        
        MOV AX,13H ;TROCA PARA MODO GRAFICO
        INT 10H
        
        MOV SI, offset Tabuleiro
        MOV DI, [offset Tabuleiro+2]
        call TROCAR
        
        MOV DI, offset Tabuleiro
        call ESC_MATRIZ
        ;call PROCESSAR_INPUT
        MOV AX, 04C00H ;DESLIGA O PROGRAMA E RETORNA STATUS 0
        INT 21h    
    end main
