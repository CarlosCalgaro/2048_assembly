
.model small

.stack 900H


.data
    
    Tabuleiro dw  0,0,0,1,1,0,0,0,1,0,0,0,1,0,0,0
        ;4 DUP( 4 DUP(0H));0FFFH,0BCDH,0AAAH,12357,51511,61353,7,8,9,10,11,12,13,14,15,163
    String db 80
    
    TelaInicial db '2048','$','Jogar 2048','$','Recordes','$','Automatico','$','Sair','$'   
    
    NumeroAleartorio dw 3
.code
    
   include basico.asm ; FUNCOES  DE ESCRITA DE MATRIZ
   include tela.asm ; FUNCOES QUE ESCREVEM TELA INICIAL
   
   RANDOM_NUM proc
    push AX
    push BX
    push CX
    push SI
    ; VERIFICA SE CONTEUDO DA MEMORIA FOR 0, SE FOR 0 USA A MASCARA 
    MOV AX, 8016H ; MASCARA
    MOV SI, offset NumeroAleartorio
    MOV CX, 1H ; MOVER MASCARA PARA FAZER O AND
    MOV BX, [SI]
    AND CX, BX
    CMP CX, 0
    JNZ rotate_xor
    ROR BX, 1
    jmp fim_random_num
    rotate_xor:
    XOR BX, AX
    ROR BX, 1
    fim_random_num:
    MOV [SI], BX
    
    pop SI
    pop CX
    pop BX
    pop AX
    ret
   endp

       
    main:
    
        mov AX, @DATA
        mov ES, AX
        mov DS, AX
  
        MOV AX,13H ;TROCA PARA MODO GRAFICO
        INT 10H
        
        MOV DI, offset Tabuleiro

        
        call ESC_MATRIZ
        CLEAR_SCREEN
        call RANDOM_NUM
        
        MOV AX, 04C00H ;DESLIGA O PROGRAMA E RETORNA STATUS 0
        INT 21h    
    end main

