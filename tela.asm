    write_string_graphic proc
        ; DH  row,column to start writing
        ; CX length of string
        ; BL video attributes BH video page
        ; BP String address
        push AX
        push BX
        push CX 
        push BP
        ;xor AX,AX
        mov AX, 1300h

        mov BP, SI
        int 10h
        pop BP   
        pop CX
        pop BX
        pop AX
     ret
    endp  
    
    WRITE_RECORD_SCREEN proc
        PUSH AX BX CX DX
        PUSH DI SI 
        XOR AX, AX
        XOR CX, CX
        MOV SI, offset TelaRecords
        MOV DI, SI
        call STR_LENGTH
        mov DL, 15
        mov DH, 1
        XOR BH, BH
        MOV BL, 9
        call write_string_graphic
        
        
        MOV DL, 4
        ADD DH, 4
        
        ADD SI, CX
        INC SI
        MOV CX, 3
        XOR AX, AX ; Vai servir para fazer meu loop
        WRITE_RECORD_TABLE_HEAD:
            PUSH CX
            MOV DI, SI
            call STR_LENGTH
            INC BL
            call write_string_graphic
            ADD DL, CL
            ADD DL, 8
            ADD SI, CX
            INC SI
          
            POP CX
        LOOP WRITE_RECORD_TABLE_HEAD
         
        MOV CX, 5 
        MOV SI, offset MelhoresResultados
        WRITE_RECORD_TABLE_BODY:
            MOV DL, 4
            ADD DH, 2
            call WRITE_TOP_SCORE
        LOOP WRITE_RECORD_TABLE_BODY
        POP SI DI
        POP DX CX BX AX 
        ret
    endp
    
    WRITE_TOP_SCORE proc ; RECEBE EM SI O INICIO DO VETOR SCORE, RECEBE DX E BX RETORNA EM SI ONDE TERMINOU DE ESCREVER
        PUSH AX BX CX DX
        PUSH DI
        MOV AX, 13H
        MOV word ptr DI, DS:[SI] ; DI <- Score
        ADD SI, 2
        mov CX, 10
        call write_string_graphic
        
        ADD DL, 14
        
        MOV AH, 02H
        INT 10H
        
        MOV AX, DI
        call ESC_UINT16
        
        ADD DL, 13
        MOV AH, 02H
        INT 10H
        
        ADD SI, 10
        MOV AX, [SI]
        call ESC_UINT16
        
        ADD SI, 2
        POP DI
        POP DX CX BX AX
        ret
        
    endp
       
    PROCESSAR_INPUT PROC
        PUSH AX
        PUSH BX
        INICIO_TELA_PROC:
        call write_tela
        
        MOV AH, 10h
        INT 16h
        
        cmp ax, 246AH   ; JOGAR
        je  iniciar_jogo
        cmp ax, 1372H  ; RECORDES
        je  records
        cmp ax, 1E61H   ;AUTOMATICO
        je  iniciar_automatico
        cmp ax, 1F73H   ;SAIR
        je  end_game
        jmp INICIO_TELA_PROC

        end_game:
            call CLEAR_SCREEN
            MOV AX, 04C00H ;DESLIGA O PROGRAMA E RETORNA STATUS 0
            INT 21h 
        records:
            call CLEAR_SCREEN
            call WRITE_RECORD_SCREEN
            MOV AH, 10h
            INT 16h
            JMP processar_input_return 
        iniciar_automatico:  
            call CLEAR_SCREEN
            call WRITE_TELA_AUTOMATICO
            call TELA_AUTOMATICO
            JMP  processar_input_return
        iniciar_jogo:
            call GAME_LOOP
            JMP  processar_input_return
        processar_input_return:
        call CLEAR_SCREEN
        POP BX
        POP AX
        ret
    ENDP
  
    TELA_AUTOMATICO PROC
        MOV SI, offset NumeroSimulacao
        MOV CX, [SI]
        
        MOV DI, offset MelhorSimulacao  ;ZERA A MELHOR SIMULA??O
        XOR AX, AX
        MOV CX, 16
        REP STOSW
        
        TELA_AUTOMATICO_SIMULAR:
            MOV SI, offset ModoAutomatico
            MOV AX, 1H
            MOV byte ptr DS:[SI], AL
            call ADD_RANDOM
            call ADD_RANDOM
            call GAME_LOOP
            call SUBS_MELHOR_SIMULACAO
            call NOVO_JOGO
            CLEAN_LOCAL_SIMULATION
            


        loop TELA_AUTOMATICO_SIMULAR
        call PRINT_BEST_SIMULATION
        MOV AH, 10h
        INT 16h
        ret
    endp
    
    WRITE_GAME_INFO proc
        push AX BX CX DX
        push SI DI
        call WRITE_SCORE
        call WRITE_MOVES
        call WRITE_BEST
        POP DI SI
        pop DX CX BX AX
        ret
    endp
    
    WRITE_BEST proc
        PUSH AX BX CX DX
        PUSH SI 
        
        MOV AX, 13H
        MOV SI, offset TelaJogo + 17
        mov DL, 27
        mov DH, 23
        mov CX, 6
        XOR BX, BX
        MOV BL, 14
        call write_string_graphic
        MOV AH, 02H
        XOR BX, BX ;page number (0 for graphics modes)
        MOV DH, 23 ;row
        MOV DL, 35 ;= ;column
        INT 10H
        
        MOV BX,  JogadaLocal
        call WRITE_BEST_RESULT
        
        MOV AH, 02H
        XOR BX, BX ;page number (0 for graphics modes)
        MOV DH, 0 ;row
        MOV DL, 0 ;= ;column
        INT 10H
        
        POP SI
        POP DX CX BX AX
        ret
    endp
    
    WRITE_BEST_RESULT proc
        PUSH AX BX CX
        MOV BX, offset MelhoresResultados
        XOR AX, AX
        MOV CX, 5
        WRITE_BEST_FIND:
            CMP word ptr [BX], AX
            JNA WRITE_BEST_NOT_OVERWRITE
            MOV AX, [BX]
            WRITE_BEST_NOT_OVERWRITE:
            ADD BX, 14
        loop WRITE_BEST_FIND
        CALL ESC_UINT16
        POP CX BX AX
        ret
    endp
    
    WRITE_MOVES proc
        PUSH AX BX CX DX
        PUSH SI 
        
        MOV AX, 13H
        MOV SI, offset TelaJogo + 8
        MOV DL, 13
        MOV DH, 23
        MOV CX, 8
        XOR BX, BX
        MOV BL, 10
        call write_string_graphic
        
        MOV AH, 02H
        XOR BX, BX ;page number (0 for graphics modes)
        MOV DH, 23 ;row
        MOV DL, 22 ;= ;column
        INT 10H
        
        MOV BX, offset JogadaLocal
        MOV AX, [BX]
        CALL ESC_UINT16
        
        MOV AH, 02H
        XOR BX, BX ;page number (0 for graphics modes)
        MOV DH, 0 ;row
        MOV DL, 0 ;= ;column
        INT 10H
        
        POP SI
        POP DX CX BX AX
        ret
    endp
    
    WRITE_SCORE proc
        PUSH AX BX CX DX
        PUSH SI 
        MOV AX, 13H
        MOV SI, offset TelaJogo
        MOV DL, 0
        MOV DH, 23
        MOV CX, 7
        XOR BX, BX
        MOV BL, 4H
        call write_string_graphic
        
        
        MOV AH, 02H
        XOR BX, BX ;page number (0 for graphics modes)
        MOV DH, 23 ;row
        MOV DL, 8 ;= ;column
        INT 10H
        
        MOV BX, offset ScoreLocal
        MOV AX, [BX]
        CALL ESC_UINT16
        
        MOV AH, 02H
        XOR BX, BX ;page number (0 for graphics modes)
        MOV DH, 0 ;row
        MOV DL, 0 ;= ;column
        INT 10H
        
        POP SI
        POP DX CX BX AX
        ret
    endp
    
    ESC_GRAPH_MAT proc
        push AX BX CX DX
        push SI DI
        
        MOV AX, 13H
        
        MOV SI, offset TelaJogo
        mov DL, 0
        mov DH, 23
        mov CX, 7
        XOR BX, BX
        MOV BL, 4H
        call write_string_graphic
        
        MOV SI, offset ScoreLocal
        MOV AX, [SI]
        MOV SI, offset String
        call UINT16_STR
        MOV AX, 13H
        MOV DI, SI
        call STR_LENGTH
        DEC CX ; RETIRA O CARACTER $
        mov DL, 7
        mov DH, 23
        XOR BX, BX
        MOV BL, 4H
        call write_string_graphic
        
        MOV SI, offset TelaJogo + 8
        mov DL, 13
        mov DH, 23
        mov CX, 8
        XOR BX, BX
        MOV BL, 10
        call write_string_graphic
        
        MOV SI, offset TelaJogo + 25
        mov DL, 21
        mov DH, 23
        mov CX, 4
        XOR BX, BX
        MOV BL, 4H
        call write_string_graphic
        
        MOV SI, offset TelaJogo + 17
        mov DL, 27
        mov DH, 23
        mov CX, 6
        XOR BX, BX
        MOV BL, 14
        call write_string_graphic
        
        MOV SI, offset TelaJogo + 25
        mov DL, 34
        mov DH, 23
        mov CX, 4
        XOR BX, BX
        MOV BL, 4H
        call write_string_graphic
       
        POP  DI SI
        POP  DX CX BX AX
        ret
    endp
    
    write_tela proc
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        PUSH SI
        ;ESCREVE o  2048 
        mov   ax, 1124h
        int   10h
        
        MOV SI, offset TelaInicial
        mov DL, 16
        mov DH, 2
        mov CX, 4
        mov BX, 0009h
        call write_string_graphic
       
        ; ESCREVE JOGAR
        mov   ax, 1123h
        int   10h
        
        MOV SI, offset TelaInicial + 5
        mov DL, 12
        mov DH, 8
        mov CX, 10
        XOR BX, BX
        MOV BL, 3H
        call write_string_graphic
        
        MOV SI, offset TelaInicial + 16
        mov DL, 12
        mov DH, 10
        mov CX, 8
        XOR BX, BX
        MOV BL, 4H
        call write_string_graphic
        
        MOV SI, offset TelaInicial + 25
        mov DL, 12
        mov DH, 12
        mov CX, 10
        XOR BX, BX
        MOV BL, 5H
        call write_string_graphic
        
         
        MOV SI, offset TelaInicial + 36
        mov DL, 12
        mov DH, 14
        mov CX, 4
        XOR BX, BX
        MOV BL, 14H
        call write_string_graphic
        
        MOV SI, offset TelaInicial + 41
        mov DL, 0
        mov DH, 20
        mov CX, 42
        XOR BX, BX
        MOV BL, 12
        call write_string_graphic
        
        
        POP SI
        POP DX
        POP CX
        POP BX
        POP AX
        ret
    endp
    