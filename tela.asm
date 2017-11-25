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
    
       
    PROCESSAR_INPUT PROC
        PUSH AX
        PUSH BX
        INICIO_TELA_PROC: 
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
            MOV AX, 04C00H ;DESLIGA O PROGRAMA E RETORNA STATUS 0
            INT 21h 
        
        records:
        iniciar_automatico:  
        iniciar_jogo:
            call ADD_RANDOM
            call ADD_RANDOM
            call GAME_LOOP
        POP BX
        POP AX
        ret
    ENDP
  
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
    