;; PRINT STRING LENGTH


.model small

.stack 900H


.data
    
    Tabuleiro dw  0,0,0,1,1,0,0,0,1,0,0,0,1,0,0,0
        ;4 DUP( 4 DUP(0H));0FFFH,0BCDH,0AAAH,12357,51511,61353,7,8,9,10,11,12,13,14,15,163
    String db 80
    
    TelaInicial db '2048','$','Jogar 2048','$','Recordes','$','Autom?tico','$','Sair','$'
    

.code
    
   include basico.asm
       
   detecta_movimento_esquerda proc
    
       MOV DI, offset Tabuleiro  ;linha
       MOV BX, 6 ;coluna
       MOV BP, 4
       INICIO:
       MOV AX, [BX][DI] ; MOVE VALOR INICIAL PARA AX
       CMP AX, [BP][DI] ; COMPARA VALOR INICIAL COM O VETOR ANTERIOR
       
       ; AQUI FICAM OS TESTES
       
       SUB BP, 2
       CMP BP, 0
       JZ FIM
       loop INICIO
       
       
       ;JG fim:  ;deve retornar o valor valido

       FIM: 
       ret
   endp
   
   main:
        mov AX, @DATA
        mov ES, AX
        mov DS, AX
        
        MOV AX,13H ;TROCA PARA MODO GRAFICO
        INT 10H
        
        ;MOV SI, offset Tabuleiro +6
        ;MOV DI, offset Tabuleiro +4
        ;call TROCA_CAMPO
        call OI
        MOV DI, offset Tabuleiro
        call ESC_MATRIZ
        ;call PROCESSAR_INPUT
        MOV AX, 04C00H ;DESLIGA O PROGRAMA E RETORNA STATUS 0
        INT 21h    
    end main
