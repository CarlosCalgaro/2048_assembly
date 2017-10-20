.model SMALL

.stack 100H

.data

FRASE   DB 'Carlos'

.code

    main:
        MOV AX, @DATA
        MOV ES, AX
        

        ;AL = modo
        ;bit 0: 1- atualiza a posi??o do cursor ap?s a escrita
        ;bit 1: 1- string cont?m caracteres e atributos
        ;BL = atributo do caractere se o bit 1 em AL for 0
        ;BH = n?mero da p?gina de v?deo
        ;DH,DL = linha, coluna da posi??o de impress?o
        ;CX = tamanho, em caracteres, da string
        ;ES:BP = endere?o do in?cio da string
        

        
        mov AX,13H ;TROCA PARA MODO GRAFICO
        int 10H
        
        mov AH, 13h
        mov al, 0
        mov bh, 0
        mov bl, 11
        mov CX, 6
        mov DL, 10
        mov DH, 7
        mov BP, offset FRASE
        int 10h
        
        ;mov AX,03H ;TROCA PARA MODO GRAFICO
        ;int 10H
        
        
        MOV AX, 04C00H
        int 21h
    end main