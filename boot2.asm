org 0x500
jmp 0x0000:start

loading db 'Loading structures for the kernel', 0
protectedMode db 'Setting up protected mode'
loadingKernel db 'Loading kernel in memory'
runningKernel db 'Running kernel'

start:
    xor ax, ax
    mov ds, ax
    mov es, ax


    







    jmp endereçokernel

    printString:  
        lodsb ;carrega o que tá em SI
        cmp al, 0 ;vê se o que foi carregado em al é igual a /0
        je endString ;se for, n tem mais o que printar

        mov ah, 0xe ;printa o caracter
        int 10h	
        
        jmp printString 
    endString:
    ret