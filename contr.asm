
TROCA_CAMPO Proc
    ;SI ORIGEM
    ;DI DESTINO
    push SI
    push DI
    push AX
    push BX
    MOV SI, offset Tabuleiro 
    MOV AX, [SI]
    MOV BX, [DI]
    MOV [SI], BX
    MOV [DI], AX
    pop BX
    pop AX
    pop DI
    pop SI
    ret
   endp
   



PROCESSAR_INPUT PROC
    PUSH AX
    PUSH BX
    MOV AH, 10h
    INT 16h
    
    cmp ax, 4D00h   ;DIREITA'
    je  jogar_direita
    cmp ax, 4800h  ;CIMA
    je  jogar_cima
    cmp ax, 5000h   ;BAIXO
    je  jogar_baixo
    cmp ax, 4B00h   ;ESQUERDA
    je  jogar_esquerda
    
    jogar_direita:
        call MOVER_DIREITA
        jmp fim_processar_input
    jogar_esquerda:
        call MOVER_DIREITA
        jmp fim_processar_input
    jogar_baixo:
        call MOVER_DIREITA
        jmp fim_processar_input
    jogar_cima:
        call MOVER_DIREITA
        jmp fim_processar_input
    fim_processar_input:
    POP BX
    POP AX
    
    ret
ENDP