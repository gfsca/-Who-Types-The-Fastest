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
;are you ready for the biggest contest of your life?
;PRESS Y/N

start:
    xor ax, ax
    mov ds, ax
    mov es, ax

    mov ax, 0x7e0 ;endereço dado para o kernel: 0x7e00
    mov es, ax    ;logo, precisa de um shift left (hexadecimal)
    xor bx, bx    ;e somar com o offset, para termos o endereço do kernel.asm

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
    

    reset:
        mov ah, 00h ;reseta o controlador de disco
        mov dl, 0   ;floppy disk
        int 13h

        jc reset    ;se o acesso falhar, tenta novamente

        jmp load

    load_kernel:
        mov ah, 02h ;le o setor do disco
        mov al, 12  ;porção de setores ocupados pelo kernel.asm
        mov ch, 0   ;track 0
        mov cl, 2   ;setor 2
        mov dh, 0   ;head 0
        mov dl, 0   ;drive 0
        int 13h

        jc load     ;se o acesso falhar, tenta novamente

        jmp 0x7e00  ;pula para o setor de endereco 0x7e00, que é o kernel

    print_string:  
        lodsb ;carrega o que tá em SI
        cmp al, 0 ;vê se o que foi carregado em al é igual a /0
        je end_string ;se for, n tem mais o que printar

        mov ah, 0xe ;printa o caracter
        int 10h	
        
        jmp print_string 
        end_string:
            ret