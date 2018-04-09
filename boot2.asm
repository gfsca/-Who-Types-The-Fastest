org 0x500
jmp 0x0000:start
 
;como o endereço dado para o kernel é 0x7e00, devemos
;utilizar o método de shift left (hexadecimal)
;e somar o offset no adress base, para rodarmos o kernel.

loading db 'Loading structures for the kernel', 0
protectedMode db 'Setting up protected mode', 0
loadingKernel db 'Loading kernel in memory', 0
runningKernel db 'Running kernel', 0

start:
    xor ax, ax
    mov ds, ax
    mov es, ax

    mov ax, 0x7e0 ;endereço dado para o kernel: 0x7e00
    mov es, ax    ;logo, precisa de um shift left (hexadecimal)
    xor bx, bx    ;e somar com o offset, para termos o endereço do kernel.asm

    mov ah,0 
	mov al, 12h
	int 10h


    load_kernel:
    mov ah, 02h ;lê um setor do disco
    mov al, 20  ;quantidade de setores ocupados pelo kernel
    mov ch, 0   ;track 0
    mov cl, 3   ;setor 3
    mov dh, 0   ;head 0
    mov dl, 0   ;drive 0
    int 13h

    jc load     ;se o acesso falhar, tenta novamente

    jmp 0x7e00  ;pula para o setor de endereco 0x7e00 (start do boot2)

    print_string:  
        lodsb ;carrega o que tá em SI
        cmp al, 0 ;vê se o que foi carregado em al é igual a /0
        je endString ;se for, n tem mais o que printar

        mov ah, 0xe ;printa o caracter
        int 10h	
        
        jmp print_string 
    end_string:
    ret