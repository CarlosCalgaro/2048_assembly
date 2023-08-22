;; PRINT STRING LENGTH


.model small

.stack 900H


.data
    Tabuleiro dw  1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0;2,4,2,4,2,4,2,4,2,4,2,4,2,4,0,0;1,2,3,4,05,06,07,08,09,10,11,12,13,0,0,0 ;1024,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15      ;4 DUP( 4 DUP(0H));0FFFH,0BCDH,0AAAH,12357,51511,61353,7,8,9,10,11,12,13,14,15,163
    String db 80
    TelaInicial db '2048','$','Jogar 2048','$','Recordes','$','Automatico','$','Sair','$','Autores: Carlos Calgaro e Eduardo Spinelli', '$' ; DEPENDENCIA DA tela.asm
    NumeroAleartorio dw 3
    ScoreLocal dw 0
    TelaJogo db 'ESCORE ','$','JOGADAS ','$','MELHOR ','$','2048','$'
    TelaRecords db 'RECORDS','$', 'NOME', '$', 'ESCORE', '$', 'JOGADAS', '$'
    MelhoresResultados1 db 01H, 00H, 'Carlos Alb', 02H, 00H,01H,00H, 'EduzaioAlb', 02H, 00h,01H,00H, 'aerfos Alb', 02H, 00h, 01H, 00H, 'gsusin gay', 02H,00h, 06H, 00H, 'Carlos Alb', 02H, 00H ; 65 bytes SCORE/NOME/JOGADAS
    MelhoresResultados db 70 DUP(0)
    JogadaPossivel db 0 ; Variavel que seta se jogada ? possivel, 0 ? invalido, 1 ? valido
    VitoriaLocal db 0 ; Variavel que seta status do jogo, se 0, jogo vigente, se 1, jogo ganho(Atingiu 2048), se 2, Jogo Perdido
    JogadaLocal dw 0 ;Armazena o numero de jogadas do usu?rio
    ModoAutomatico db 0
    TelaAutomaticoStr db 'DIGITE O NUMERO DE JOGADAS:', '$'
    NumeroSimulacao dw 0 
    MelhorSimulacao dw 0000H, 0000H, 0000H, 0000H,  0000H, 0000H,  0000H, 0000H,  0000H, 0000H,  0000H, 0000H,  0000H, 0000H, 0000H, 0000H; Score/Jogadas 32 - 2048 28 bytes
    ResultadoSimulacao dw 0000H, 0000H, 0000H, 0000H,  0000H, 0000H,  0000H, 0000H,  0000H, 0000H,  0000H, 0000H,  0000H, 0000H, 0000H, 0000H; Score/Jogadas 32 - 2048 28 bytes
    TelaMelhorSimulacao db 'RESULTADO','$','POTENCIA','$','SCORE','$','JOGADA','$'
    TelaMelhorSimulacaoTot db 'TOTAL','$','JOGADAS','$'
    TelaSalvarRecord db  0ah,0dh,0AH,0DH,'Digite seu nome para salvar:',0DH,0AH,'$'
    NameBuffer db 11 DUP(0)
.code
   include basico.asm
   include contr.asm
   include autom.asm
   include result.asm
   include tela.asm 
   main:
        ; Inicializando o segmento de dados 
        mov AX, @data     ; Initialize DS to address 
        mov DS, AX        ; of data segment 
        mov ES, AX
        MOV AX, 13H ;TROCA PARA MODO GRAFICO
        INT 10H
        
        
        
        ;call Condicao_VITORIA
        CALL TESTA_MOVIMENTO_DIREITA
        MOV SI, offset JogadaPossivel
        XOR AX,AX
        MOV byte ptr AL, [SI]
        call ESC_UINT16
        MOV AH, 10h
        INT 16h
        ;call DUMP_TOTAL_PLAY_AUTO
        ;call SUBS_MELHOR_SIMULACAO
        ;call PRINT_BEST_SIMULATION
        ;call CLEAR_SCREEN
        ;call WRITE_TELA_AUTOMATICO
        ;call TELA_AUTOMATICO
        
        MOV DI, offset Tabuleiro
        MOV AX, 04C00H ;DESLIGA O PROGRAMA E RETORNA STATUS 0
        INT 21h    
    end main 