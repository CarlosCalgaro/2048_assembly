TROCA_CAMPO Proc
    ;SI ORIGEM
    ;DI DESTINO
    push SI
    push DI
    push AX
    push BX
    MOV AX, [SI]
    MOV BX, [DI]
    MOV word ptr[SI], BX
    MOV word ptr[DI], AX
    pop BX
    pop AX
    pop DI
    pop SI
    ret
endp
   

MERGE proc
    ; DI = ENDERECO DO OPERADOR 1 INICIAL
    ; SI = ENDERECO DO OPERADOR 2 FINAL
    push SI
    push DI
    SHL word ptr [SI], 1
    MOV word ptr [DI] , 0
    pop DI
    pop SI
    ret
endp


GAME_LOOP proc
    PUSH CX DI
    MOV DI, offset Tabuleiro
    MOV CX, 9999
    LACO_GAME_LOOP:
        call CLEAR_SCREEN
        call ESC_MATRIZ
        call PROCESSAR_JOGADA
    loop LACO_GAME_LOOP
    POP DI CX
    ret
endp

PROCESSAR_JOGADA PROC
   PUSH AX
   PUSH BX
   
   XOR AX, AX
   MOV AH, 10h ; INTERRUPCAO QUE LE UMA TECLA DO TECLADO
   INT 16h     ; ---------------------------------------

   ;ESQUERDA 4B DIreita 4D  CIMA 48 BAIXO 50
   cmp AH, 4DH ;DIREITA'
   je  proc_jogada_direita
   cmp AH, 48h  ;CIMA
   je  proc_jogada_cima
   cmp AH, 50h   ;BAIXO;
   je  proc_jogada_baixo
   cmp AH, 4Bh   ;ESQUERDA
   je  proc_jogada_esquerda
   jmp fim_processar_input
   proc_jogada_direita:
       call MOVIMENTO_DIREITA
       jmp fim_processar_input
   proc_jogada_esquerda:
       call MOVIMENTO_ESQUERDA
       jmp fim_processar_input
   proc_jogada_baixo:
       call MOVIMENTO_BAIXO
       jmp fim_processar_input
   proc_jogada_cima:
       call MOVIMENTO_CIMA
       jmp fim_processar_input
   fim_processar_input:
   POP BX
   POP AX
   ret
ENDP
   MOVIMENTO_ESQUERDA proc
    PUSH AX BX CX
    PUSH DI SI
    MOV DI, offset Tabuleiro
    MOV SI, DI ; Copia SI
    MOV BX, 0
    MOV_ESQ_INICIO_LINHA:
    PUSH BX
    MOV_ESQ_INICIO:
        LEA AX, [DI][BX] ; Armazena o valor a ser testado
        CMP AX, SI ; Armazena o valor inicial da linha
        JZ MOV_ESQ_PROX_NUM ; Deve-se pular para o proximo numero
    
        ;CMP 0, word ptr[AX] ; Verifica se o valor a ser testado ? 0 
        CMP word ptr DS:[DI][BX], 0
        JZ MOV_ESQ_PROX_NUM
        
        
        MOV BP, BX ; Endere?o do index anterior ao que vamos testar
        SUB BP, 2  ; ---------------------------------------------
       
        CMP word ptr DS:[DI][BP], 0
        JZ MOV_ESQ_TROCAR
        
        MOV CX, DS:[DI][BX]; Valor a ser testado
        CMP word ptr DS:[DI][BP], CX ; Testa o anterior com o valor a ser testado
        JZ MOV_ESQ_MERGE
        JMP MOV_ESQ_PROX_NUM
        MOV_ESQ_TROCAR:
            push SI
            push DI
            lea SI, DS:[DI][BP]
            lea DI, DS:[DI][BX]
            call TROCA_CAMPO
            pop DI
            pop SI
            SUB BX, 2
            JMP MOV_ESQ_INICIO
        MOV_ESQ_MERGE:
            push SI
            push DI
            lea SI, DS:[DI][BP]
            lea DI, DS:[DI][BX]
            call merge
            pop DI
            pop SI
            LEA SI, DS:[DI][BP]
            ADD SI, 2
   MOV_ESQ_PROX_NUM:
        POP BX
        ADD BX, 2
        CMP BX, 8
        JZ MOV_ESQ_NOVA_LINHA
        JMP MOV_ESQ_INICIO_LINHA
        MOV_ESQ_NOVA_LINHA:
        ADD DI, BX
        MOV SI, DI
        CMP DI, 32
        JZ MOV_ESQ_RET
        XOR BX, BX
        JMP MOV_ESQ_INICIO_LINHA
        MOV_ESQ_RET:

    POP SI DI       
    POP CX BX AX
    ret    
   endp

MOVIMENTO_DIREITA proc
    PUSH AX BX CX
    PUSH DI SI
    MOV DI, offset Tabuleiro
    LEA SI, [6][DI] ; Copia SI
    MOV BX, 6
    MOV_DIR_INICIO_LINHA:
    PUSH BX
    MOV_DIR_INICIO:
        LEA AX, [DI][BX] ; Armazena o valor a ser testado
        CMP AX, SI ; Armazena o valor inicial da linha
        JZ MOV_DIR_PROX_NUM ; Deve-se pular para o proximo numero
    
        ;CMP 0, word ptr[AX] ; Verifica se o valor a ser testado ? 0 
        CMP word ptr DS:[DI][BX], 0
        JZ MOV_DIR_PROX_NUM
        
        
        MOV BP, BX ; Endere?o do index anterior ao que vamos testar
        ADD BP, 2  ; ---------------------------------------------
       
        CMP word ptr DS:[DI][BP], 0
        JZ MOV_DIR_TROCAR
        
        MOV CX, DS:[DI][BX]; Valor a ser testado
        CMP word ptr DS:[DI][BP], CX ; Testa o anterior com o valor a ser testado
        JZ MOV_DIR_MERGE
        JMP MOV_DIR_PROX_NUM
        MOV_DIR_TROCAR:
            push SI
            push DI
            lea SI, DS:[DI][BP]
            lea DI, DS:[DI][BX]
            call TROCA_CAMPO
            pop DI
            pop SI
            ADD BX, 2
            JMP MOV_DIR_INICIO
        MOV_DIR_MERGE:
            push SI
            push DI
            lea SI, DS:[DI][BP]
            lea DI, DS:[DI][BX] 
            call merge
            pop DI
            pop SI
            LEA SI, DS:[DI][BP]
            SUB SI, 2
   MOV_DIR_PROX_NUM:
        POP BX
        SUB BX, 2
        CMP BX, -2
        JZ MOV_DIR_NOVA_LINHA
        JMP MOV_DIR_INICIO_LINHA
        MOV_DIR_NOVA_LINHA:
        ADD DI, 8
        LEA SI, [6][DI]
        ; \/ MELHOR ESSA CONDI??O ABAIXO
        CMP DI, 32
        JZ MOV_DIR_RET
        MOV BX, 6
        JMP MOV_DIR_INICIO_LINHA
        MOV_DIR_RET:

    POP SI DI       
    POP CX BX AX
    ret    
   endp
   
   
   
   MOVIMENTO_CIMA proc
        PUSH AX BX CX
        PUSH DI SI
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
            CMP DI, 8
            JZ MOV_CIMA_RET
            MOV BX, 0 
            JMP MOV_CIMA_INICIO_LINHA
            MOV_CIMA_RET:
            POP SI DI       
            POP CX BX AX
            ret
   endp
   
   MOVIMENTO_BAIXO proc
        PUSH AX BX CX
        PUSH DI SI
        
        MOV DI, offset Tabuleiro
        LEA SI, [24][DI] ; Copia SI
            MOV BX, 24
        MOV_BAIXO_INICIO_LINHA:
        PUSH BX
        MOV_BAIXO_INICIO:
            LEA AX, [DI][BX]
            CMP AX, SI
            JZ MOV_BAIXO_PROX_NUM
            
            CMP word ptr DS:[DI][BX], 0
            JZ MOV_BAIXO_PROX_NUM
            
            MOV BP, BX
            ADD BP, 8
            
            CMP word ptr DS:[DI][BP], 0
            JZ MOV_BAIXO_TROCAR
            
            MOV CX, DS:[DI][BX]; Valor a ser testado
            CMP word ptr DS:[DI][BP], CX ; Testa o anterior com o valor a ser testado
            JZ MOV_BAIXO_MERGE
            JMP MOV_BAIXO_PROX_NUM
           
            MOV_BAIXO_TROCAR:
                push SI
                push DI
                lea SI, DS:[DI][BP]
                lea DI, DS:[DI][BX]
                call TROCA_CAMPO
                pop DI
                pop SI
                ADD BX, 8
                JMP MOV_BAIXO_INICIO
           
            MOV_BAIXO_MERGE:
                push SI
                push DI
                lea SI, DS:[DI][BP]
                lea DI, DS:[DI][BX] 
                call merge
                pop DI
                pop SI
                LEA SI, DS:[DI][BP]
                SUB SI, 8
                
                 MOV_BAIXO_PROX_NUM:
            POP BX
            SUB BX, 8
            CMP BX, -8
            JZ MOV_BAIXO_NOVA_LINHA
            JMP MOV_BAIXO_INICIO_LINHA
            MOV_BAIXO_NOVA_LINHA:
            ADD DI, 2
            ;LEA SI, [DI]
            LEA SI, [24][DI]
            CMP DI, 8
            JZ MOV_BAIXO_RET
            MOV BX, 24
            JMP MOV_BAIXO_INICIO_LINHA
            MOV_BAIXO_RET:
            POP SI DI       
            POP CX BX AX
            ret
   endp
   
   