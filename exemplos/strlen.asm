;; PRINT STRING LENGTH


.model small

.stack 100H


.data

    str1 db 'CARL'
.code

    print_bx proc ;; IMPRIME BX
        MOV AH, 02h
        MOV DL, BH
        ADD DL, '0'
        int 21h
        MOV DL, BL
        ADD DL, '0'
        int 21h
       ret
    endp
    
    str_length proc ;armazena o tamanho em CX
        xor cx,cx
        xor ax,ax
        not cx
        cld
        repne scasb
        not cx
        dec cx
        ret
    endp
    
    main:
        MOV AX, @DATA
        MOV ES, AX
        xor AX,AX
        mov DI, offset str1
        call str_length
        MOV BX, CX
        call print_bx
        MOV AX, 04C00H ;DESLIGA O PROGRAMA E RETORNA STATUS 0
        INT 21h    
    end main
