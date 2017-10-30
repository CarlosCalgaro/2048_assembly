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

    RANDOM_N proc
        MOV BX, Mascara
        MOV CX, 0001H
        AND CX, AX
        CMP CX, 0
        JNZ rotate_right
        
        
       
    endp
    
    main:
       MOV AX, @DATA
       MOV ES, AX
       
    
    
    end main