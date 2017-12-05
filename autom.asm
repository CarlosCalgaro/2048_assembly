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
