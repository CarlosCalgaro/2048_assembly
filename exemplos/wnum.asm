
.model SMALL

.stack 100H

.data

   Numero dw 65535
   resp db 2 dup(0)
.code
    include basico.asm
   
    main: 
        mov AX, @DATA
        mov ES, AX
        mov DS, AX

        MOV CX, Numero
        LEA SI, Resp
        call UINT16_STR
        call ESC_STR
        
  
        MOV AX, 04C00H ;DESLIGA O PROGRAMA E RETORNA STATUS 0
        INT 21h    
    
    end main
    