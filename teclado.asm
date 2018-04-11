org 0x7c00
jmp 0x0000:start

teste db 'o rato roeu a roupa do rei de roma. Fonseca eh uma otima pessoa e toscano eh um coco no fort', 0
points db 0

teclado:        ; funcao para ler o input do teclado na pilha
    push dx     ; salva o que tem em dh e dl

    mov ah, 02h ; escolhe a funcao de ler o tempo do sistema
    int 1aH     ; interrupcao que lida com o tempo do sistema

    cmp dh, 30
    jge done
    
    pop dx      ; retira da pilha os 2 bytes e salva-os em dx

    lodsb   ; carregando o que tá sendo apontado em si para al
    cmp al, 0
    je done

    mov cl , al ;guardando, pra não sobrescrever o que foi puxado da memória

    mov ah, 0   ; prepara o ah para a chamada do teclado
    int 16h     ; interrupcao para ler o caractere e armazena-lo em al
    
    cmp al, 8
    je backspace

    cmp al, cl ; compara o caracter texto e o caracter inserido

    je caracter_verde 
    jne caracter_vermelho
    
seta_cursor:
    cmp dl, 70
    je controle_direita
    retorno_c_d:
    mov ah, 02h ; setar o cursor
    mov bh, 0   ; pagina
    inc dl
    int 10h
    cmp bl, 2
    je aqui_vd
    jmp aqui_vm

    controle_direita:
    mov ah, 02h ; setar o cursor
    mov bh, 0   ; pagina
    mov dl, 20
    inc dh
    int 10h
    jmp retorno_c_d

printa_char:
    mov cx, 1
    mov ah, 09h ; codigo para printar caractere apenas onde esta o cursor
    mov bh, 0   ; seta a pagina
    int 10h
    cmp bl, 2
    je  retorno_pChar
    jmp retorno_pChar2

backspace:
    cmp dl, 20
    je controle_esquerda

    printa_espaco:
        mov al, ' '
        mov cx, 1
        mov ah, 09h ; codigo para printar caractere apenas onde esta o cursor
        mov bh, 0   ; seta a pagina
        mov bl, 15  ; seta a cor do caractere, nesse caso, branco
        int 10h

        dec dl
        mov ah, 02h ; setar o cursor
        mov bh, 0   ; pagina
        int 10h

        dec si
        dec si 
        
        jmp teclado

    controle_esquerda:
        cmp dh, 5
        je teclado

        mov al, ' '
        mov cx, 1
        mov ah, 09h ; codigo para printar caractere apenas onde esta o cursor
        mov bh, 0   ; seta a pagina
        mov bl, 15  ; seta a cor do caractere, nesse caso, branco
        int 10h

        dec si

        dec dh
        mov dl, 60
        mov ah, 02h ; setar o cursor
        mov bh, 0   ; pagina
        int 10h

        jmp teclado

    caracter_verde:
        mov bl, 2  ; seta a cor do caractere, nesse caso, verde
        jmp seta_cursor
        aqui_vd:
        jmp printa_char
        retorno_pChar:
        inc byte [points]
        jmp teclado

    caracter_vermelho:
        mov bl, 4  ; seta a cor do caractere, nesse caso, vermelho
        jmp seta_cursor
        aqui_vm:
        jmp printa_char
        retorno_pChar2:
        cmp byte [points], 0
        je teclado
        dec byte [points]
        jmp teclado

start:
    mov ah, 03h ; escolhe a funcao de ler o tempo do sistema
    mov ch, 0   ; horas
    mov cl, 0   ; minutos
    mov dh, 0   ; segundos
    mov dl, 1   ; seta o modo entre dia e noite do relogio do sistema(1 para dia)
    int 1aH     ; interrupcao que lida com o tempo do sistema
    
    xor ax, ax
    mov ds, ax
    mov es, ax

    mov ah, 0   ; escolhe o modo do video
    mov al, 12h ; modo VGA
    int 10h     ; interrupcao de tela

    mov ah, 0bh  ; chamada para mudar a cor do background
    mov bh, 0    ; seta a pagina do video, nesse caso como so existe uma, eh 0
    mov bl, 1    ; cor designada ao background
    int 10h

    mov ah, 02h ; setar o cursor
    mov bh, 0   ; pagina
    mov dh, 5   ; valor y
    mov dl, 20  ; valor x
    int 10h

    mov si, teste 
        
    jmp teclado

    done:
    jmp $
    times 510-($-$$) db 0 ;512 bytes
    dw 0xaa55             ;assinatura
