;; PRINT STRING LENGTH


.model small

.stack 900H


.data
    
    Tabuleiro dw  0,0,0,1,1,0,0,0,1,0,0,0,1,0,0,0
        ;4 DUP( 4 DUP(0H));0FFFH,0BCDH,0AAAH,12357,51511,61353,7,8,9,10,11,12,13,14,15,163
    String db 80
    
    TelaInicial db '2048','$','Jogar 2048','$','Recordes','$','Automatico','$','Sair','$'
    

.code
    
   include basico.asm ; FUNCOES  DE ESCRITA DE MATRIZ
   include tela.asm ; FUNCOES QUE ESCREVEM TELA INICIAL
   
   

       
    main:

    
    mov AX, @DATA
        mov ES, AX
        mov DS, AX
        
        MOV AX,13H ;TROCA PARA MODO GRAFICO
        INT 10H

        call write_tela
        call PROCESSAR_INPUT
       
        
       
       
    end main

