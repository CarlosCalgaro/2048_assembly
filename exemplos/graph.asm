.model SMALL

.stack 100H

.data


.code

	proc write_pixel: ;AX é Y ; BX é X; DL é cor
		pusha
		mov cx,320
		mul cx; multiply AX by 320 (cx value)
		add ax,bx ; and add X
		mov di,ax
		mov [es:di],dl
		popa
		ret
	endp

	main:
		xor AX,AX

		mov AX,13H
		int 10H

		mov AX, 0A000h
		mov ES, AX
		mov AX, 0
		mov di, AX
		mov dl, 7
		mov [es:di], dl

		mov ax, 10,
		mov bx, 20
		mov dl, 1
		call putpixel

		mov ax, 11,
		mov bx, 18
		mov dl, 2
		call putpixel
		
		mov ax, 12,
		mov bx, 19
		mov dl, 3
		call putpixel
		
		mov al, 00 ;Fechar o programa
	    mov ah, 04CH
	    int 21h; FIM FECHAR


	END main