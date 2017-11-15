
.model small

.stack 900H


.data
    
    Tabuleiro dw  2,2,4,4,2,2,4,4,0,0,0,0,0,0,0,0 ;4 DUP( 4 DUP(0H));0FFFH,0BCDH,0AAAH,12357,51511,61353,7,8,9,10,11,12,13,14,15,163
    String db 80
    TelaInicial db '2048','$','Jogar 2048','$','Recordes','$','Automatico','$','Sair','$','Autores: Carlos Calgaro e Eduardo Spinelli', '$' ; DEPENDENCIA DA tela.asm
    NumeroAleartorio dw 3
.code
    
   include basico.asm ; FUNCOES  DE ESCRITA DE MATRIZ
   include tela.asm ; FUNCOES QUE ESCREVEM TELA INICIAL
   include contr.asm ; FUNCOES DE MOVIMENTACAO
    
MOVIMENTO_ESQUERDA proc
        push AX BX CX    
        push DI BP
        ; Setando BX e DI    
        MOV DI, offset Tabuleiro
    MOV_ESQ_LINHAS:
        MOV BX, 0
        MOV_ESQ_INICIO:
        PUSH BX
    ; VERIFICA SE BX EST? APONTANDO PARA INICIO DA LINHA
     MOV_ESC_CONTINUA:       
                MOV AX, DI
                LEA CX, [DI][BX]
                CMP CX, AX
                JZ MOV_ESC_PROXIMO_NUMERO
        
               ; NAO MOVEMOS NADA SE FOR 0
                CMP word ptr DS:[DI][BX], 0 
                jz MOV_ESC_PROXIMO_NUMERO

                MOV BP, BX
                SUB BP, 2            
                
                ; VERIFICAR SE PODE MOVER, COMPARAR BX - 2 COM 0
                 
                CMP word ptr DS:[DI][BP], 0
                 jz MOV_ESC_TROCA 
                
                 MOV AX, DS:[DI][BP]
                 CMP [DI][BX], AX ; VERIFICAR SE PODE FAZER MERGE, SE BX-2 FOR IGUAL A BX                        
                 JE MOV_ESC_EXEC_MERGE
                 jmp MOV_ESC_PROXIMO_NUMERO
                MOV_ESC_TROCA:
                    push SI
                    push DI
                    lea SI, DS:[DI][BP]
                    lea DI, DS:[DI][BX]
                    call TROCA_CAMPO
                    pop DI
                    pop SI
                    SUB BX, 2
                    JMP MOV_ESC_CONTINUA
                MOV_ESC_EXEC_MERGE:
                    push SI
                    push DI
                    lea SI, DS:[DI][BP]
                    lea DI, DS:[DI][BX]
                    call merge
                    pop DI
                    pop SI
        MOV_ESC_PROXIMO_NUMERO:
        POP BX
        ADD BX, 2
        CMP BX, 8
        JNE MOV_ESQ_INICIO
        ; IR PARA NOVA LINHA
        ADD DI, BX
        CMP DI,32
        JNE MOV_ESQ_LINHAS
        POP CX BX AX     
        POP BP DI 
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
        call MOVIMENTO_ESQUERDA
       
        MOV DI, offset Tabuleiro
        call ESC_MATRIZ
        
        MOV AX, 04C00H ;DESLIGA O PROGRAMA E RETORNA STATUS 0
        INT 21h    
    end main

