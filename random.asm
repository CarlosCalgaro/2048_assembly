;; PRINT STRING LENGTH


.model small

.stack 900H


.data
    
    Tabuleiro dw  2,2,2,2,2,8,2,8,2,8,2,8,2,8,2,8      ;4 DUP( 4 DUP(0H));0FFFH,0BCDH,0AAAH,12357,51511,61353,7,8,9,10,11,12,13,14,15,163
    String db 80
    TelaInicial db '2048','$','Jogar 2048','$','Recordes','$','Automatico','$','Sair','$','Autores: Carlos Calgaro e Eduardo Spinelli', '$' ; DEPENDENCIA DA tela.asm
    ScoreLocal dw 0
    TelaJogo db 'ESCORE ','$','JOGADAS ','$','MELHOR ','$','2048'
    NumeroAleartorio dw 3
.code
    
   include basico.asm
   include contr.asm
   include tela.asm 
   main:
        ; Inicializando o segmento de dados
        mov  ax,@data     ; Initialize DS to address 
        mov  ds,ax        ; of data segment 
        mov  ES, AX
        MOV AX, 13H ;TROCA PARA MODO GRAFICO
        INT 10H
        
        mov DI, offset Tabuleiro
        call MOVIMENTO_ESQUERDA_POS
        
        MOV AX, 04C00H ;DESLIGA O PROGRAMA E RETORNA STATUS 0
        INT 21h    
    end main 