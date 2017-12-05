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
   
ADD_RANDOM proc
    ; REFAZER ESTA FUNCAO
    push AX BX CX
    push SI
    
    MOV SI, offset NumeroAleartorio
    call RANDOM_NUM
    MOV BX, [SI]
    MOV AX, BX
    AND BX, 0FH
    SHL BX, 1 ; multiplica por 2 para achar o endere?o efetivo
    MOV SI, offset Tabuleiro
    CMP word ptr DS:[SI][BX], 0 ; Se n?o for  zero temos que achar outro campo
    JE add_random_select
    
    MOV CX, 16
    comeco:   
        ADD BX, 2 
        CMP word ptr DS:[SI][BX], 0
        JE add_random_select
        CMP BX, 30
        JNAE add_random_fim_loop
        MOV BX, -2
        add_random_fim_loop:
    loop comeco
    ; Perdeu o jogos
    MOV SI, offset VitoriaLocal
    MOV AX, 2
    MOV [SI], AL
    jmp add_random_fim
    
    add_random_select:
    AND AX, 1
    CMP AX, 1
    JZ add_random_set_4
    MOV AX, 2
    JMP add_random_insert
    add_random_set_4:
    MOV AX, 4
    add_random_insert:
    MOV SI, offset Tabuleiro
    MOV DS:[SI][BX], AX
    
    add_random_fim:
    POP SI
    POP CX BX AX
    ; AQUI SERIA O TRATAMENTO PARA ACABAR O JOGO
    ret
endp

MERGE proc
    ; DI = ENDERECO DO OPERADOR 1 INICIAL
    ; SI = ENDERECO DO OPERADOR 2 FINAL
    push SI
    push DI
    push BX
    push CX
    SHL word ptr [SI], 1
    MOV word ptr [DI] , 0
   
    MOV BX, offset ScoreLocal ; SOMA DO NOVO VALOR AO SCORE TOTAL
    MOV CX, [BX]
    ADD CX, [SI]
    MOV [BX], CX
    
    CMP DS:[SI], 2048
    JNZ merge_fim_proc
    ;FLAG DE VITORIA SETADA QUANDO 2048
    merge_fim_jogo:
    MOV BX, offset VitoriaLocal
    MOV CX, 1
    MOV [BX], CX
    merge_fim_proc:
    pop CX
    pop BX
    pop DI
    pop SI
    ret
endp


GAME_LOOP proc
    PUSH CX DI SI
    MOV DI, offset Tabuleiro

    LACO_GAME_LOOP:
        call CLEAR_SCREEN
        call ESC_MATRIZ
        MOV SI, offset VitoriaLocal
        CMP byte ptr DS:[SI], 1
        JZ GAME_LOOP_FIM_JOGO
        
        CMP byte ptr DS:[SI], 2
        JZ GAME_LOOP_FIM_JOGO
        
        call ESC_GRAPH_MAT
        call ESC_INFO
        MOV SI, offset ModoAutomatico
        CMP byte ptr DS:[SI], 1
        JZ GAME_LOOP_AUTOMATICO
        call PROCESSAR_JOGADA
        JMP GAME_LOOP_DPS_JOGADA
        
        GAME_LOOP_AUTOMATICO:
        call JOGAR_AUTOMATICO
        
        GAME_LOOP_DPS_JOGADA:
        
        MOV SI, offset JogadaPossivel ; COmpara se foi uma jogada valida
        cmp byte ptr DS:[SI], 0
        JZ LACO_GAME_LOOP
        call SOMA_JOGADA
        call ADD_RANDOM

    JMP LACO_GAME_LOOP
    GAME_LOOP_FIM_JOGO:
    POP SI DI CX
    ret
endp


SOMA_JOGADA proc
    PUSH SI
    MOV word ptr SI, offset JogadaLocal
    INC word ptr [SI]
    POP SI
    ret
endp

PROCESSAR_JOGADA PROC
   PUSH AX
   PUSH BX
   PUSH DI 
   jogada_invalida:
   XOR AX, AX
   MOV AH, 10h ; INTERRUPCAO QUE LE UMA TECLA DO TECLADO
   INT 16h     ; ---------------------------------------
   MOV DI, offset JogadaPossivel
   ;ESQUERDA 4B DIreita 4D  CIMA 48 BAIXO 50
   cmp AH, 4DH ;DIREITA'
   je  proc_jogada_direita
   cmp AH, 48h  ;CIMA
   je  proc_jogada_cima
   cmp AH, 50h   ;BAIXO;
   je  proc_jogada_baixo
   cmp AH, 4Bh   ;ESQUERDA
   je  proc_jogada_esquerda
   jmp jogada_invalida
   proc_jogada_direita:
       call TESTA_MOVIMENTO_DIREITA
       cmp byte ptr DS:[DI], 0
       JZ fim_processar_sem_jogar
       call MOVIMENTO_DIREITA
       jmp fim_processar_input
   proc_jogada_esquerda:
       call TESTA_MOVIMENTO_ESQUERDA
       cmp byte ptr DS:[DI], 0
       JZ fim_processar_sem_jogar
       call MOVIMENTO_ESQUERDA
       jmp fim_processar_input
   proc_jogada_baixo:
       call TEST_MOVIMENTO_BAIXO
       cmp byte ptr DS:[DI], 0
       JZ fim_processar_sem_jogar
       call MOVIMENTO_BAIXO
       jmp fim_processar_input
   proc_jogada_cima:
       call TESTA_MOVIMENTO_CIMA
       cmp byte ptr DS:[DI], 0
       JZ fim_processar_sem_jogar
       call MOVIMENTO_CIMA
       jmp fim_processar_input
   fim_processar_input:
   ; Soma uma jogada possivel
   MOV DI, offset JogadaLocal
   fim_processar_sem_jogar:
   POP DI
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
    
     TESTA_MOVIMENTO_ESQUERDA proc
        push AX BX CX DX
        push BP SI DI
        ; Verifica se ? possivel mexer pra esquerda, retorno 1 ou 0 em AX
        MOV SI, offset Tabuleiro
        MOV DI, SI
        MOV BX, 0
              
        TEST_ESQ_INICIO_LINHA:
        PUSH BX
        TEST_ESQ_INICIO:
            LEA AX, [DI][BX] ; Armazena o valor a ser testado
            CMP AX, SI ; Armazena o valor inicial da linha
            JZ TEST_ESQ_PROX_NUM ; Deve-se pular para o proximo numero

            ;CMP 0, word ptr[AX] ; Verifica se o valor a ser testado ? 0
            CMP word ptr DS:[DI][BX], 0
            JZ TEST_ESQ_PROX_NUM
           
            MOV BP, BX ; Endere?o do index anterior ao que vamos testar
            SUB BP, 2  ; ---------------------------------------------
          
            CMP word ptr DS:[DI][BP], 0
            JZ TEST_ESQ_PODE
           
            MOV CX, DS:[DI][BX]; Valor a ser testado
            CMP word ptr DS:[DI][BP], CX ; Testa o anterior com o valor a ser testado
            JZ TEST_ESQ_PODE
            JMP TEST_ESQ_PROX_NUM
           
            TEST_ESQ_PODE:
                POP BX
                MOV DI, offset JogadaPossivel
                MOV AX, 1
                MOV byte ptr DS:[DI], AL
                JMP TEST_ESQ_RET
            TEST_ESQ_PROX_NUM:
            POP BX
            ADD BX, 2
            CMP BX, 8
            JZ TEST_ESQ_NOVA_LINHA
            JMP TEST_ESQ_INICIO_LINHA
            TEST_ESQ_NOVA_LINHA:
            ADD DI, BX
            MOV SI, DI
            CMP DI, 32
            JZ TEST_ESQ_NAO_POSSIVEL
            XOR BX, BX
            JMP TEST_ESQ_INICIO_LINHA
           
            TEST_ESQ_NAO_POSSIVEL:
            MOV DI, offset JogadaPossivel
            MOV AX, 0
            MOV byte ptr DS:[DI], AL
            TEST_ESQ_RET:
           
            POP DI SI BP
            POP DX CX BX AX
            ret
   endp
   
   
   TESTA_MOVIMENTO_DIREITA proc
    PUSH AX BX CX
    PUSH SI BP DI
    MOV DI, offset Tabuleiro
    LEA SI, [6][DI] ; Copia SI
    MOV BX, 6
    TEST_DIR_INICIO_LINHA:
    PUSH BX
    TEST_DIR_INICIO:
        LEA AX, [DI][BX] ; Armazena o valor a ser testado
        CMP AX, SI ; Armazena o valor inicial da linha
        JZ TEST_DIR_PROX_NUM ; Deve-se pular para o proximo numero
   
        ;CMP 0, word ptr[AX] ; Verifica se o valor a ser testado ? 0
        CMP word ptr DS:[DI][BX], 0
        JZ TEST_DIR_PROX_NUM
       
       
        MOV BP, BX ; Endere?o do index anterior ao que vamos testar
        ADD BP, 2  ; ---------------------------------------------
      
        CMP word ptr DS:[DI][BP], 0
        JZ TEST_DIR_PODE
       
        MOV CX, DS:[DI][BX]; Valor a ser testado
        CMP word ptr DS:[DI][BP], CX ; Testa o anterior com o valor a ser testado
        JZ TEST_DIR_PODE
        JMP TEST_DIR_PROX_NUM
        TEST_DIR_PODE:
         POP BX  
         MOV DI, offset JogadaPossivel
         MOV AX, 1
         MOV byte ptr DS:[DI], AL
         JMP TEST_DIR_RET
      
        TEST_DIR_PROX_NUM:
        POP BX
        SUB BX, 2
        CMP BX, -2
        JZ  TEST_DIR_NOVA_LINHA
        JMP TEST_DIR_INICIO_LINHA
        TEST_DIR_NOVA_LINHA:
        ADD DI, 8
        LEA SI, [6][DI]
        CMP DI, 32
        JZ TEST_DIR_NAO_POSSIVEL
        MOV BX, 6
        JMP TEST_DIR_INICIO_LINHA
        TEST_DIR_NAO_POSSIVEL:
        MOV DI, offset JogadaPossivel
        MOV AX, 0
        MOV byte ptr DS:[DI], AL
        TEST_DIR_RET:

    POP DI BP SI     
    POP CX BX AX
    ret   
   endp
   
    TESTA_MOVIMENTO_CIMA proc
        PUSH AX BX CX
        PUSH DI SI BP
        MOV DI, offset Tabuleiro
        MOV SI, DI
        XOR BX, BX
        TEST_CIMA_INICIO_LINHA:
        PUSH BX
        TEST_CIMA_INICIO:
            LEA AX, [DI][BX]
            CMP AX, SI
            JZ TEST_CIMA_PROX_NUM
           
            CMP word ptr DS:[DI][BX], 0
            JZ TEST_CIMA_PROX_NUM
           
            MOV BP, BX
            sub BP, 8
           
            CMP word ptr DS:[DI][BP], 0
            JZ TEST_CIMA_PODE
           
            MOV CX, DS:[DI][BX]; Valor a ser testado
            CMP word ptr DS:[DI][BP], CX ; Testa o anterior com o valor a ser testado
            JZ TEST_CIMA_PODE
            JMP TEST_CIMA_PROX_NUM
          
            TEST_CIMA_PODE:
             POP BX  
             MOV DI, offset JogadaPossivel
            MOV AX, 1
            MOV byte ptr DS:[DI], AL
             JMP TEST_CIMA_RET
            
            
            TEST_CIMA_PROX_NUM:
            POP BX
            ADD BX, 8
            CMP BX, 32
            JZ TEST_CIMA_NOVA_LINHA
            JMP TEST_CIMA_INICIO_LINHA
            TEST_CIMA_NOVA_LINHA:
            ADD DI, 2
            ;LEA SI, [DI]
            MOV SI, DI
            CMP DI, 8
            JZ TEST_CIMA_NAO_POSSIVEL
            MOV BX, 0
            JMP TEST_CIMA_INICIO_LINHA
            TEST_CIMA_NAO_POSSIVEL:
            MOV DI, offset JogadaPossivel
            MOV AX, 0
            MOV byte ptr DS:[DI], AL
            TEST_CIMA_RET:
            POP BP SI DI      
            POP CX BX AX
            ret
   endp
   
    TEST_MOVIMENTO_BAIXO proc
        PUSH AX BX CX
        PUSH DI SI BP
       
        MOV DI, offset Tabuleiro
        LEA SI, [24][DI] ; Copia SI
            MOV BX, 24
        TEST_BAIXO_INICIO_LINHA:
        PUSH BX
        TEST_BAIXO_INICIO:
            LEA AX, [DI][BX]
            CMP AX, SI
            JZ TEST_BAIXO_PROX_NUM
           
            CMP word ptr DS:[DI][BX], 0
            JZ TEST_BAIXO_PROX_NUM
           
            MOV BP, BX
            ADD BP, 8
           
            CMP word ptr DS:[DI][BP], 0
            JZ TEST_BAIXO_PODE
           
            MOV CX, DS:[DI][BX]; Valor a ser testado
            CMP word ptr DS:[DI][BP], CX ; Testa o anterior com o valor a ser testado
            JZ TEST_BAIXO_PODE
            JMP TEST_BAIXO_PROX_NUM
          
            TEST_BAIXO_PODE:
             POP BX  
             MOV DI, offset JogadaPossivel
             MOV AX, 1
             MOV byte ptr DS:[DI], AL
             JMP TEST_BAIXO_RET
             TEST_BAIXO_PROX_NUM:
             
            POP BX
            SUB BX, 8
            CMP BX, -8
            JZ TEST_BAIXO_NOVA_LINHA
            JMP TEST_BAIXO_INICIO_LINHA
            TEST_BAIXO_NOVA_LINHA:
            ADD DI, 2
            ;LEA SI, [DI]
            LEA SI, [24][DI]
            CMP DI, 8
            JZ TEST_BAIXO_NAO_POSSIVEL
            MOV BX, 24
            JMP TEST_BAIXO_INICIO_LINHA
            TEST_BAIXO_NAO_POSSIVEL:
            MOV DI, offset JogadaPossivel
            MOV AX, 0
            MOV byte ptr DS:[DI], AL
            TEST_BAIXO_RET:
            POP BP SI DI      
            POP CX BX AX
            ret
   endp