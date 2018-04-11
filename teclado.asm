org 0x7e00
jmp 0x0000:start

teste db 'o rato roeu a roupa do rei de roma', 0

teclado:        ; funcao para ler o input do teclado
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
    cmp dl, 80
    je .controle_direita
    mov ah, 02h ; setar o cursor
    mov bh, 0   ; pagina
    inc dl
    int 10h
    ret

    .controle_direita:
    mov ah, 02h ; setar o cursor
    mov bh, 0   ; pagina
    mov dl, 20
    inc dh
    int 10h
    ret

printa_char:
    mov cx, 1
    mov ah, 09h ; codigo para printar caractere apenas onde esta o cursor
    mov bh, 0   ; seta a pagina
    int 10h
    ret

backspace:
    cmp dl, 20
    je .controle_esquerda

    .printa_espaco:
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

    .controle_esquerda:
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
        mov bl, 2  ; seta a cor do caractere, nesse caso, branco
        call seta_cursor
        call printa_char
        jmp teclado

    caracter_vermelho:
        mov bl, 4  ; seta a cor do caractere, nesse caso, branco
        call seta_cursor
        call printa_char
        jmp teclado

start:
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