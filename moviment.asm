
.model small

.stack 900H


.data
    
    Tabuleiro dw  4 DUP( 4 DUP(1H));0FFFH,0BCDH,0AAAH,12357,51511,61353,7,8,9,10,11,12,13,14,15,163
    String db 80
    TelaInicial db '2048','$','Jogar 2048','$','Recordes','$','Automatico','$','Sair','$','Autores: Carlos Calgaro e Eduardo Spinelli', '$' ; DEPENDENCIA DA tela.asm
    NumeroAleartorio dw 3
    ScoreLocal dw 0
    TelaJogo db 'ESCORE ','$','JOGADAS ','$','MELHOR ','$','2048','$'
    
.code
    
   include basico.asm ; FUNCOES  DE ESCRITA DE MATRIZ
   include tela.asm ; FUNCOES QUE ESCREVEM TELA INICIAL
   include contr.asm ; FUNCOES DE MOVIMENTACAO
    
   
   main:
    
        mov AX, @DATA
        mov DS, AX
        ;MOV ES, AX
     
        MOV AX,13H ;TROCA PARA MODO GRAFICO
        INT 10H
        
        MOV CX, 16
        MOV SI, offset Tabuleiro    
        MOV BX, 0
        comeco:
            MOV DS:[SI][BX ], cx
            ADD BX, 2
        loop comeco    
        MOV AX, 04C00H ;DESLIGA O PROGRAMA E RETORNA STATUS 0
        INT 21h    
        
    end main

