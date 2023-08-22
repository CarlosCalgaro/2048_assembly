
.model small

.stack 900H


.data
    
    Tabuleiro dw  8,8,8,8,8,8,8,8,8,2,2,2,2,2,2,2 ;4 DUP( 4 DUP(0H));0FFFH,0BCDH,0AAAH,12357,51511,61353,7,8,9,10,11,12,13,14,15,163
    String db 80
    TelaInicial db '2048','$','Jogar 2048','$','Recordes','$','Automatico','$','Sair','$','Autores: Carlos Calgaro e Eduardo Spinelli', '$' ; DEPENDENCIA DA tela.asm
    NumeroAleartorio dw 3
.code
    
   include basico.asm ; FUNCOES  DE ESCRITA DE MATRIZ
   include tela.asm ; FUNCOES QUE ESCREVEM TELA INICIAL
        

   
      main:
    
        mov AX, @DATA
        mov ES, AX
        mov DS, AX
  
        MOV AX,13H ;TROCA PARA MODO GRAFICO
        INT 10H
        
        MOV SI, offset Tabuleiro
        ADD SI, 2
        MOV DI, offset Tabuleiro
        call merge
        call ESC_MATRIZ
        
        MOV AX, 04C00H ;DESLIGA O PROGRAMA E RETORNA STATUS 0
        INT 21h    
    end main

