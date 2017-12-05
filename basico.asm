   CLEAR_SCREEN PROC
    PUSH AX BX CX DX
    XOR BX,BX
    MOV AX,0600H    ;06 TO SCROLL & 00 FOR FULLJ SCREEN
    MOV BH,00H    ;ATTRIBUTE 7 FOR BACKGROUND AND 1 FOR FOREGROUND
    MOV CX,0000H    ;STARTING COORDINATES
    ;MOV CH, 0040:[0084]
    ;MOV CL, 0040:[0049]
    ;MOV DX, 0FF00H
    MOV DX, 1850H    ;ENDING COORDINATES
    
    INT 10H        ;FOR VIDEO DISPLAY
    MOV AX, 0200H ;AH = 02
    MOV BX, 0000H;BH = page number (0 for graphics modes)
    ;DH = row
    ;DL = column
    MOV DX, 0000H
    int 10h
    POP DX CX BX AX
    ret
   ENDP
    
    UINT16_STR proc 
            ; TRANSFORMA UM NUMERO DE 16 BITS EM STRING
            ;SI recebe o LUGAR PARA RETORNO 
            ;AX RECEBE O NUMERO A SER ESCRITO
            ;RETORNA EM SI O NUMERO CONVERTIDO PRA ASCII COM UM $ NO FINAL
            PUSH DX
            PUSH BX
            PUSH AX
            
            MOV BX,10      
            MOV byte ptr 80[SI],'$'
            LEA SI,[SI+80]
    ASC2:
            mov dx,0            ; clear dx prior to dividing dx:ax by bx
            DIV BX              ;DIV AX/10
            ADD DX,48           ;ADD 48 TO REMAINDER TO GET ASCII CHARACTER OF NUMBER 
            dec si              ; store characters in reverse order
            mov [si],dl
            CMP AX,0            
            JZ EXIT             ;IF AX=0, END OF THE PROCEDURE
            JMP ASC2            ;ELSE REPEAT
    EXIT:
            POP AX
            POP BX
            POP DX
            ret
   endp
      
   ESC_MATRIZ proc
       ; ESCREVE A MATRIZ 4X4 PARA VISUALIZAR
       ; DI OFFSET DA MATRIZ
       ; SI OFFSET DE STRING
        MOV CX,16

        MOV BX, DI
        INICIO_1:
            push dx
            push ax
            push bx
                XOR DX, DX
                mov BX, 4
                mov ax, cx
                div bx
                cmp dx, 0
                jnz no_new_line
                call NEW_LINE
            no_new_line:
            pop bx
            pop ax
            pop dx
            
            MOV AX, [BX]
            ADD BX, 2
            MOV si, offset String
            call UINT16_STR
            call ESC_STR
            CALL M_WHITE_SPACE
           
        loop INICIO_1
        ret
   endp
   
   M_WHITE_SPACE proc
        PUSH DX
        PUSH AX
        PUSH CX
        MOV CX,3
        WS_LOOP:
            XOR AX, AX
            XOR DX, DX 
            MOV AH, 02H
            MOV DL, 20H
            INT 21H
        LOOP WS_LOOP
        POP CX
        POP AX
        POP DX
        RET
   endp
   
   NEW_LINE proc
       PUSH DX
       PUSH AX
       
       xor AX,AX
       xor DX,DX
       
       MOV AH, 02H
       MOV DL, 10
       int 21h
       
       xor AX,AX
       xor DX,DX
       
       MOV AH, 02H
       MOV DL, 13
       int 21h
       
       POP AX
       POP DX
       ret
   endp
   
   ESC_NEW proc
        PUSH DX
        PUSH AX
        MOV DX, 13
        MOV AX, 02H
        INT 21H
        MOV DX, 10
        MOV AX, 02H
        INT 21H
        POP AX
        POP DX
        RET
    endp
   
   ESC_STR proc ; ESCREVE A STRING SI
        ;SI RECEBE A STRING
        push DX
        push SI
        push AX
        xor ax,ax
        mov dx,si 
        mov ah,9            ; print string
        int 21h
        POP AX
        POP SI
        POP DX
        ret
   endp
   
   STR_LENGTH proc ;armazena o tamanho em CX String em DI
        push ax
        push di
        xor cx,cx
        xor ax,ax
        not cx
        cld
        repne scasb
        not cx
        dec cx
        pop di
        pop ax
        ret
    endp
    
    RANDOM_NUM proc
        push AX
        push BX
        push CX
        push SI
        ; VERIFICA SE CONTEUDO DA MEMORIA FOR 0, SE FOR 0 USA A MASCARA ISSO DEVE TERMINAR DEPOIS
        MOV AX, 8016H ; MASCARA
        MOV SI, offset NumeroAleartorio
        MOV CX, 1H ; MOVER MASCARA PARA FAZER O AND
        MOV BX, [SI]
        AND CX, BX
        JNZ rotate_xor
        jmp fim_random_num
        rotate_xor:
        XOR BX, AX
        fim_random_num:
        ROR BX, 1
        MOV [SI], BX
        pop SI
        pop CX
        pop BX
        pop AX
      ret
    endp
    
    ESC_INFO proc
    ret
    endp

    