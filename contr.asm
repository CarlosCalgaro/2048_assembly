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
    SAL byte ptr [SI] , 1
    MOV byte ptr [DI] , 0
    pop DI
    pop SI
    ret
endp

PROCESSAR_JOGADA PROC
   PUSH AX
   PUSH BX
   MOV AH, 10h
   INT 16h
;   
;   cmp ax, 4D00h   ;DIREITA'
;   je  jogar_direita
;   cmp ax, 4800h  ;CIMA
;   je  jogar_cima
;   cmp ax, 5000h   ;BAIXO;
;   je  jogar_baixo
   cmp ax, 4B00h   ;ESQUERDA
   je  jogar_esquerda
;   
;   jogar_direita:
;       call MOVER_DIREITA
;       jmp fim_processar_input
   jogar_esquerda:
   call MOVIMENTO_ESQUERDA
;       jmp fim_processar_input
;   jogar_baixo:
;       call MOVER_DIREITA
;       jmp fim_processar_input
;   jogar_cima:
;       call MOVER_DIREITA
;       jmp fim_processar_input
;   fim_processar_input:
;   POP BX
;   POP AX
    ;   
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