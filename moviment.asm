
.model small

.stack 900H


.data
    
    Tabuleiro dw  0,0,0,0, 2,0,0,4, 2,0,0,4, 0,0,0,4 ;4 DUP( 4 DUP(0H));0FFFH,0BCDH,0AAAH,12357,51511,61353,7,8,9,10,11,12,13,14,15,163
    String db 80
    TelaInicial db '2048','$','Jogar 2048','$','Recordes','$','Automatico','$','Sair','$','Autores: Carlos Calgaro e Eduardo Spinelli', '$' ; DEPENDENCIA DA tela.asm
    NumeroAleartorio dw 3
.code
    
   include basico.asm ; FUNCOES  DE ESCRITA DE MATRIZ
   include tela.asm ; FUNCOES QUE ESCREVEM TELA INICIAL
   include contr.asm ; FUNCOES DE MOVIMENTACAO
    
   
   
   MOVIMENTO_CIMA proc
        MOV DI, offset Tabuleiro
        MOV SI, DI
        XOR BX, BX
        MOV_CIMA_INICIO_LINHA:
        PUSH BX
        MOV_CIMA_INICIO:
            LEA AX, [DI][BX]
            CMP AX, SI
            JZ MOV_CIMA_PROX_NUM
            
            CMP word ptr DS:[DI][BX], 0
            JZ MOV_CIMA_PROX_NUM
            
            MOV BP, BX
            sub BP, 8
            
            CMP word ptr DS:[DI][BP], 0
            JZ MOV_CIMA_TROCAR
            
            MOV CX, DS:[DI][BX]; Valor a ser testado
            CMP word ptr DS:[DI][BP], CX ; Testa o anterior com o valor a ser testado
            JZ MOV_CIMA_MERGE
            JMP MOV_CIMA_PROX_NUM
           
            MOV_CIMA_TROCAR:
                push SI
                push DI
                lea SI, DS:[DI][BP]
                lea DI, DS:[DI][BX]
                call TROCA_CAMPO
                pop DI
                pop SI
                SUB BX, 8
                JMP MOV_CIMA_INICIO
           
            MOV_CIMA_MERGE:
                push SI
                push DI
                lea SI, DS:[DI][BP]
                lea DI, DS:[DI][BX] 
                call merge
                pop DI
                pop SI
                LEA SI, DS:[DI][BP]
                ADD SI, 8
                
                 MOV_CIMA_PROX_NUM:
            POP BX
            ADD BX, 8
            CMP BX, 32
            JZ MOV_CIMA_NOVA_LINHA
            JMP MOV_CIMA_INICIO_LINHA
            MOV_CIMA_NOVA_LINHA:
            ADD DI, 2
            ;LEA SI, [DI]
            MOV SI, DI
            CMP DI, 38
            JZ MOV_CIMA_RET
            MOV BX, 0 
            JMP MOV_CIMA_INICIO_LINHA
            MOV_CIMA_RET:
            ret
   endp
   
   main:
    
        mov AX, @DATA
        mov DS, AX
        MOV ES, AX
  
        MOV AX,13H ;TROCA PARA MODO GRAFICO
        INT 10H
        
        
        ;SI ORIGEM
        ;DI DESTINO
       
        MOV DI, offset Tabuleiro
        call MOVIMENTO_CIMA
       
        MOV DI, offset Tabuleiro
        call ESC_MATRIZ
        
        MOV AX, 04C00H ;DESLIGA O PROGRAMA E RETORNA STATUS 0
        INT 21h    
    end main

