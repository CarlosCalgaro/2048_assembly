

READ_PLAYER_NAME PROC
    PUSH AX CX DX
    PUSH DI SI
        MOV DX,OFFSET TelaSalvarRecord    ; lea dx,input_m
        MOV AH,09
        INT 21H
        LEA SI, NameBuffer
        MOV CX, 10
READ_PLAYER_PROX:    MOV AH,01
        INT 21H
        MOV [SI],AL
        INC SI
        DEC CX
        CMP CX, 0 
        JZ READ_STRING_RET
        CMP AL,0DH
        JNZ READ_PLAYER_PROX
        
 READ_STRING_RET:
        MOV byte ptr[SI],'$'
        MOV DX,OFFSET NameBuffer
        MOV AH,09H
        INT 21H
    POP SI DI
    POP DX CX AX
RET
ENDP

SAVE_CURRENT_RECORD proc
    PUSH AX BX CX DX
    PUSH SI
    ; Recebe em DI o endereco inicial para salvar DI <- DI +10
    ;MOV DX, offset JogadaLocal
    MOV AX, JogadaLocal
    ;MOV DX, offset ScoreLocal
    MOV BX, ScoreLocal
    
    MOV SI, offset NameBuffer
    
    MOV DS:[DI], BX
    
    ADD DI, 2
    
    MOV CX, 5
    REP MOVSW
    MOV DS:[DI], AX
    POP SI
    POP DX CX BX AX 
ret
endp

CMP_CURRENT_RECORD proc
    PUSH AX BX CX 
    PUSH SI DI
    
    call CLEAR_SCREEN
    MOV SI, offset MelhoresResultados
    XOR BX, BX
    
    MOV AX, ScoreLocal
    MOV CX, 5
    CMP_CURRENT_RECORD_LOOP:
        CMP DS:[SI][BX], AX
        JBE CMP_CURRENT_TROCA
        ADD BX, 14
    loop CMP_CURRENT_RECORD_LOOP
    JMP CMP_CURRENT_RECORD_RET
    CMP_CURRENT_TROCA:
    call READ_PLAYER_NAME
    LEA DI, DS:[SI][BX]
    call SAVE_CURRENT_RECORD
    CMP_CURRENT_RECORD_RET:
    POP DI SI
    POP CX BX AX
ret
endp