.model small

.stack 100H

.data
    str1 db '1- Jogar 2048'
    str2 db '2- Recordes'
    str3 db '3- Automaticos 2048'
    str4 db '4- Sair'
.code
    

    printf proc ; BP contem a string
        push AX
        push BX
        ;xor AX,AX
        mov AX, 1300h
        mov BX, 0011h
        mov CX, 13
        mov DL, 10
        mov DH, 7
        ; mov BP, offset str1
        int 10h   
    endp
    
    main:
       MOV AX, @DATA
       MOV ES, AX
       
       MOV AX,13H ;TROCA PARA MODO GRAFICO
       INT 10H
    
   
       mov BP, offset str1
       call printf
       
        MOV AX, 08H
        int 21h
       MOV AX, 04C00H ;DESLIGA O PROGRAMA E RETORNA STATUS 0
       INT 21h
    
    end main