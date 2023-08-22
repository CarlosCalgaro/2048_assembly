
WRITE_TELA_AUTOMATICO proc
    PUSH BX CX DX
    PUSH SI 
    MOV SI, offset TelaAutomaticoStr
    MOV DL, 4
    MOV DH, 2
    MOV DI, SI
    call STR_LENGTH
    XOR BX, BX
    MOV BL, 10
    call write_string_graphic
    
    MOV AH, 02H
    XOR BX, BX ;page number (0 for graphics modes)
    MOV DH, 3 ;row
    MOV DL, 4 ;= ;column
    INT 10H
    
    call LER_UINT16
    
    MOV SI, offset NumeroSimulacao
    MOV [SI], AX
    POP SI
    POP DX CX BX
    ret
endp


SALVA_JOGADA_MEMORIA MACRO TARGET, SCORE, JOGADA  ; Target precisa ser SI ou DI
    PUSH TARGET
    MOV DS:[TARGET], SCORE
    ADD TARGET, 2
    ADD JOGADA, 1 ; PRECISA PQ NO LOOP NAO FOI PROCESSADO AINDA
    MOV DS:[TARGET], JOGADA
    POP TARGET
ENDM

SUBS_MELHOR_SIMULACAO PROC
    PUSH AX BX CX DX
    PUSH DI SI    
    MOV SI, offset MelhorSimulacao
    MOV DI, offset ResultadoSimulacao
    
    MOV AX, 0
    MOV BX, 0
    
    MOV CX, 7
    subs_melhor_testa_zero:
        CMP word ptr DS:[SI], 0 
        JE subs_melhor_cmp_di
        INC AX
        subs_melhor_cmp_di:
        CMP word ptr DS:[DI], 0 
        JE subs_melhor_prox
        INC BX
        subs_melhor_prox:
        ADD SI, 4
        ADD DI, 4
    loop subs_melhor_testa_zero
    
    CMP AX, BX
    JE  subs_melhor_valor_final
    JB  subs_melhor_troca
    JMP subs_melhor_ret
    
    subs_melhor_valor_final:
    MOV CX, 7
    subs_melhor_testa_final:
        SUB SI, 4
        SUB DI, 4
        MOV DX, DS:[DI]
        CMP DS:[SI], DX
        JB subs_melhor_troca
        JA subs_melhor_ret 
    loop subs_melhor_testa_final
    JMP subs_melhor_ret
    
    subs_melhor_troca:
        MOV DI, offset MelhorSimulacao
        MOV SI, offset ResultadoSimulacao
        MOV CX, 16
        REP MOVSW
        
    subs_melhor_ret:
    MOV DI, offset ResultadoSimulacao
    XOR AX, AX
    MOV CX, 16
    REP STOSW
    POP SI DI
    POP DX CX BX AX
    ret
endp

SALVA_JOGADA_AUTOMATICO proc ; Recebe em SI o novo valor
    PUSH AX BX
    PUSH SI DI
    
    MOV DI, offset ResultadoSimulacao
    MOV AX, JogadaLocal
    MOV BX, ScoreLocal
    CMP word ptr [SI], 32
    JE SALVA_JOGADA_FIM
    CMP word ptr [SI], 64
    JE SALVA_JOGADA_64
    CMP word ptr [SI], 128
    JE SALVA_JOGADA_128
    CMP word ptr [SI], 256
    JE SALVA_JOGADA_256
    CMP word ptr [SI], 512
    JE SALVA_JOGADA_512
    CMP word ptr [SI], 1024
    JE SALVA_JOGADA_1024
    CMP word ptr [SI], 2048
    JE SALVA_JOGADA_2048
    JMP SALVA_JOGADA_RET
    
    SALVA_JOGADA_64:
        ADD DI, 4
    JMP SALVA_JOGADA_FIM

    SALVA_JOGADA_128:
        ADD DI, 8
    JMP SALVA_JOGADA_FIM

    SALVA_JOGADA_256:
        ADD DI, 12
    JMP SALVA_JOGADA_FIM

    SALVA_JOGADA_512:
        ADD DI, 16
    JMP SALVA_JOGADA_FIM
    SALVA_JOGADA_1024:
        ADD DI, 20
    JMP SALVA_JOGADA_FIM
    SALVA_JOGADA_2048:
        ADD DI, 24
    SALVA_JOGADA_FIM:
        CMP byte ptr DS:[DI], 0 ; PRIMEIRO MERGE COM ESSAS CARAC
        JNE SALVA_JOGADA_RET
        SALVA_JOGADA_MEMORIA DI, BX, AX
    SALVA_JOGADA_RET:
    POP DI SI
    POP BX AX
    ret
endp

CLEAN_LOCAL_SIMULATION MACRO
    ; Macro responsavel por limpar os resultados da simulacao local
    PUSH AX CX DX
    PUSH DI
    MOV DI, offset ResultadoSimulacao
    XOR AX, AX
    MOV CX, 16
    REP STOSW
    POP DI
    POP DX CX AX
ENDM 

DUMP_TOTAL_PLAY_AUTO proc
    PUSH DX BX
    PUSH SI DI
    MOV SI, offset ResultadoSimulacao
    MOV BX, 28
    
    MOV DI, offset ScoreLocal
    MOV DX, [DI]
    MOV DS:[SI][BX], DX
    
    MOV DI, offset JogadaLocal
    MOV DX, [DI]
    ADD BX, 2
    MOV DS:[SI][BX], DX
    POP DI SI
    POP BX DX
    ret
endp

JOGAR_AUTOMATICO proc
   PUSH AX
   PUSH BX
   PUSH DI 
       MOV DI, offset JogadaPossivel
       call TEST_MOVIMENTO_BAIXO
       cmp byte ptr DS:[DI], 0
       JZ  automatico_esquerda
       call MOVIMENTO_BAIXO
       jmp automatico_fim
       
       automatico_esquerda:
       call TESTA_MOVIMENTO_ESQUERDA
       cmp byte ptr DS:[DI], 0
       JZ  automatico_direita
       call MOVIMENTO_ESQUERDA
       jmp automatico_fim

       automatico_direita:
       
       call TESTA_MOVIMENTO_DIREITA
       cmp byte ptr DS:[DI], 0
       JZ automatico_cima
       call MOVIMENTO_DIREITA
       jmp automatico_fim
       
       automatico_cima:
       call MOVIMENTO_CIMA
   automatico_fim:
   POP DI
   POP BX
   POP AX
   ret
endp

WRITE_SIMULATION_DATA proc
    PUSH AX BP DX SI
    
    CMP BP, 4096
    JE WRITE_SIMULATION_DATA_SCORES
    MOV AX, BP
    call ESC_UINT16
    WRITE_SIMULATION_DATA_SCORES:
    ADD DL, 12
    MOV AH, 02H
    INT 10H
    
    MOV AX, word ptr DS:[SI] 
    call ESC_UINT16
    
    ADD DL, 12
    ADD SI, 2
    
    MOV AH, 02H
    INT 10H
    
    MOV AX, word ptr DS:[SI] 
    call ESC_UINT16
    
    POP SI DX BP AX
    ret
endp

PRINT_BEST_SIMULATION proc
        PUSH AX BX CX DX
        PUSH SI DI
        CALL CLEAR_SCREEN
        MOV SI, offset TelaMelhorSimulacao
        XOR AX, AX
        XOR CX, CX
        MOV DI, SI
        call STR_LENGTH
        mov DL, 15
        mov DH, 1
        XOR BH, BH
        MOV BL, 9
        call write_string_graphic
        
        MOV DL, 2
        ADD DH, 4
        
        ADD SI, CX
        INC SI
        MOV CX, 3
        INC BL
        XOR AX, AX ; Vai servir para fazer meu loop
        WRITE_BEST_SIMULATION_TABLE_HEAD:
            PUSH CX
            MOV DI, SI
            call STR_LENGTH
            call write_string_graphic
            ADD DL, CL
            ADD DL, 8
            ADD SI, CX
            INC SI
            POP CX
        LOOP WRITE_BEST_SIMULATION_TABLE_HEAD
        
        MOV CX, 8
        MOV SI, offset MelhorSimulacao
        MOV BP, 32
        XOR BX, BX
        WRITE_BEST_SIMULATION_TABLE_BODY:
                ADD DH, 2
                MOV DL, 5
                MOV AH, 02H
                INT 10H
                call WRITE_SIMULATION_DATA
                ADD SI, 4
                SHL BP, 1
        LOOP WRITE_BEST_SIMULATION_TABLE_BODY
        POP DI SI
        POP DX CX BX AX
        ret
endp

DELAY_1_SECOND proc
    PUSH AX CX DX
    MOV CX, 0FH
    MOV DX, 4240H
    MOV AH, 86H
    INT 15H
    POP DX CX AX
    ret
endp