org 0x500
jmp 0x0000:start
 
;como o endereço dado para o kernel é 0x7e00, devemos
;utilizar o método de shift left (hexadecimal)
;e somar o offset no adress base, para rodarmos o kernel.

loading db 'Loading structures for the kernel...', 0
protectedMode db 'Setting up protected mode...', 0
loadingKernel db 'Loading kernel in memory...', 0
runningKernel db 'Running kernel...', 0
challenge db 'Press Enter if you think you type fast enough.'

enter_input:
    mov ah, 0   ; prepara o ah para a chamada do teclado
    int 16h     ; interrupcao para ler o caractere e armazena-lo em al

    cmp al, 0xA

    je reset
    jne enter_input

print_string:
	lodsb
	cmp al,0
	je end

	mov ah, 0eh
	mov bl, 0x2
	int 10h

	mov dx, 0
	.delay_print:
	inc dx
	mov cx, 0
		.time:
			inc cx
			cmp cx, 10000
			jne .time

	cmp dx, 1000
	jne .delay_print

	jmp print_string

	end:
		mov ah, 0eh
		mov al, 0xd
		int 10h
		mov al, 0xa
		int 10h
		ret

start:
    xor ax, ax
    mov ds, ax
    mov es, ax

    mov ah,0 
	mov al, 12h
	int 10h ;setando modo gráfico

    
	mov ah,0xb
	mov bh,0
	mov bl, 0 
	int 10h ; colocando o fundo como preto

    ;parte pra printar as mensagens que quisermos

    mov si, loading
    call print_string


    mov si, protectedMode
    call print_string


    mov si, loadingKernel
    call print_string


    mov si, runningKernel
    call print_string

    mov si, challenge
    call print_string

    jmp enter_input
        

    reset:
        mov ah, 00h ;reseta o controlador de disco
        mov dl, 0   ;floppy disk
        int 13h

        jc reset    ;se o acesso falhar, tenta novamente

        jmp load_kernel

    load_kernel:
        ;Setando a posição do disco onde kernel.asm foi armazenado(ES:BX = [0x7E00:0x0])
        mov ax,0x7E0	;0x7E0<<1 + 0 = 0x7E00
        mov es,ax
        xor bx,bx		;Zerando o offset

        mov ah, 0x02 ;le o setor do disco
        mov al, 20  ;porção de setores ocupados pelo kernel.asm
        mov ch, 0   ;track 0
        mov cl, 3   ;setor 3
        mov dh, 0   ;head 0
        mov dl, 0   ;drive 0
        int 13h

        jc load_kernel ;se o acesso falhar, tenta novamente

        jmp 0x7e00  ;pula para o setor de endereco 0x7e00, que é o kernel

   ; print_string:  
    ;    lodsb ;carrega o que tá em SI
     ;   cmp al, 0 ;vê se o que foi carregado em al é igual a /0
      ;  je end_string ;se for, n tem mais o que printar
;
 ;       mov ah, 0xe ;printa o caracter
  ;      int 10h	
   ;     
    ;    jmp print_string 
     ;   end_string:
      ;      ret


    times 510-($-$$) db 0
    dw 0xaa55	