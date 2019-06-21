
segment .text
global start

start:

    mov ah, 0	
    mov al, VGA_MODE	
    int 10h				

    mov ax, VMEM_OFFSET 
    mov es, ax			

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	mov word[iter_x], 0 

    loop_width: 		

		mov word[iter_y], 0	

		loop_height:
			
			mov bx, word[iter_x] 
			mov ax, word[iter_y] 

			mov byte[temp_c], COLOR_1 
			call SetPixel 			  
 
			inc word[iter_y]

		cmp word[iter_y], HEIGHT
		jle loop_height		

		inc word[iter_x]

	cmp word[iter_x], WIDTH
	jle loop_width

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	mov bx, 160		
	mov ax, 0
	mov byte[temp_c], COLOR_2
	call SetPixel

	mov word[iter_x], 20 

	rule_90: 

    loop_width_2:	

		mov word[iter_y], 1
		loop_height_2:
			
		
			mov ax, word[iter_x]
			dec ax
			mov word[previous], ax	

			mov ax, word[iter_x]
			inc ax
			mov word[next], ax 

			mov ax, word[iter_y]
			dec ax
			mov word[last_row], ax 

			mov bx, word[previous]
			mov ax, word[last_row]
			call GetPixelColor 

			mov  al, byte[temp_c]
			mov  byte[help_c], al 

			mov bx, word[next]
			mov ax, word[last_row]
			call GetPixelColor	

			mov al, byte[temp_c]
			xor al, byte[help_c]
			mov byte[temp_c], al

			mov bx, word[iter_x]
			mov ax, word[iter_y]
			call SetPixel 		
 
			inc word[iter_y]

		cmp word[iter_y], 180
		jle loop_height_2		

		inc word[iter_x]

	cmp word[iter_x], 300
	jle loop_width_2

	jmp rule_90

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	main_loop:

	mov ax,	0
	int 16h

    jz main_loop

    mov ah, 0
    mov ax, TEXT_MODE
    int		10h

SetPixel: 
	mov cx, WIDTH 
    mul cx
    add ax, bx
    mov di, ax 				
	mov dl, byte[temp_c]	
    mov [es:di], dl			
    ret

GetPixelColor: 
    mov cx, WIDTH
	mul cx
	add ax, bx
	mov di, ax				
	mov dl, [es:di]			
	mov byte[temp_c], dl
	ret

section .data

    VMEM_OFFSET equ 0A000h	
    VGA_MODE    equ 13h		
    TEXT_MODE   equ 3h		
    WIDTH       equ 320		
    HEIGHT      equ 200		

	COLOR_1 	equ 0
	COLOR_2 	equ 1
	
	previous 	dw 0 
	next	 	dw 0 
	last_row 	dw 0

    iter_x 			dw 0
    iter_y 			dw 0

	temp_c db 0
	help_c db 0
