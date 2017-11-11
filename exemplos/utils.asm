.model small

.stack 100H

.data

    Mascara dw 8016H
    Random_number dw 9123H
.code

;Mascara= 1000 0000 0001 0110
;Se (n0 = 0 ) /* Testa o bit menos significativo*/
;Ni+1 = rotate_right(Ni);
;sen?o
;Ni+1 = rotate_right(XOR(Ni, Mascara));

    rand proc
        push DX
        mov DX,AX
        shr DX, 1
        jnz RAND_MASCARA
        rcr AX, 3
        jmp RAND_FIM
RAND_MASCARA:
        xor AX, Mascara
        rcr AX, 3
RAND_FIM:
        inc AX
        mov [BX], AX
        AND AX, 0FH
        pop DX
        ret
    endp 
    
    main:
       MOV AX, @DATA
       MOV ES, AX
       
       MOV AX, 4
       call rand
       MOV AX, 5
       call rand
       MOV AX, 6
       call rand
        
       MOV AX, 04C00H ;DESLIGA O PROGRAMA E RETORNA STATUS 0
       INT 21h
    
    end main