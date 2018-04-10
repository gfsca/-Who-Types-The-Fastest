org 0x7c00
jmp 0x0000:start

teste db 'o rato roeu a roupa do rei de roma', 0
testeLen equ $-teste

start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov si, teste
    call videoSettings
    call writeString
    call testCaracteres
    jmp fim


videoSettings:  ; funcao para setar o video
    mov ah, 0   ; escolhe o modo do video
    mov al, 12h ; modo VGA
    int 10h     ; interrupcao de tela

    mov ah, 0bh  ; chamada mudar a cor do background
    mov bh, 0    ; seta a pagina do video, nesse caso como so existe uma, eh 0
    mov bl, 1    ; cor designada ao background
    int 10h

    ret

teclado:        ; funcao para ler o input do teclado
    mov ah, 0   ;prepara o ah para a chamada do teclado
    int 16h     ;interrupcao para ler o caractere e armazena-lo em al
    ret

pintaChar:      ; funcao para pintar de volta um caractere da cor padrao. Nesse caso o branco
    mov ah, 02h ; setar o cursor
    mov dl, 1
    mov dh, 5
    mov bh, 0
    int 10h

    mov al, 'a'
    mov cx, 1
    mov ah, 09h ; codigo para printar caractere apenas onde esta o cursor
    mov bh, 0   ; seta a pagina
    mov bl, 15  ; seta a cor do caractere, nesse caso, branco

    mov 

    ret

writeString:
    mov ah, 02h ; setar o cursor
    mov bh, 0   ; pagina
    mov dh, 5   ; valor y
    mov dl, 20  ; valor x
    int 10h

    .loadchar:
        mov ah, 02h ; setar o cursor
        int 10h

        lodsb 
        cmp al, 0
        je .break
        cmp al, 0

        mov cx, 1
        mov ah, 09h ; codigo para printar caractere apenas onde esta o cursor
        mov bh, 0   ; seta a pagina
        mov bl, 15  ; seta a cor do caractere, nesse caso, branco
        int 10h
        
        inc dl
        
        jne .loadchar

    .break:
        ret

testCaracteres:
    mov ah, 02h ; setar o cursor
    mov bh, 0   ; pagina
    mov dh, 5   ; valor y
    mov dl, 20  ; valor x
    int 10h
    mov si, teste
    .looping:
        lodsb
        mov cl, al

        cmp al, 0
        je .break
        
        call teclado

        cmp al, 8
        je .lod

        cmp al, cl
        je .charCerto
        
        cmp al, cl
        jne .charErrado
        jmp .looping
    .lod:
        call pintaChar
        jmp .looping
    .break:
        ret
    
    .charCerto:
        mov ah, 02h ; setar o cursor
        int 10h
        
        mov cx, 1
        mov ah, 09h ; codigo para printar caractere apenas onde esta o cursor
        mov bh, 0   ; seta a pagina
        mov bl, 2  ; seta a cor do caractere, nesse caso, verde
        int 10h
        
        inc dl

        jmp .looping
    
    .charErrado:
        mov ah, 02h ; setar o cursor
        int 10h
        
        mov al, cl

        mov cx, 1
        mov ah, 09h ; codigo para printar caractere apenas onde esta o cursor
        mov bh, 0   ; seta a pagina
        mov bl, 4  ; seta a cor do caractere, nesse caso, vermelho
        int 10h

        inc dl

        jmp .looping

fim:

jmp $
times 510 - ($ - $$) db 0
dw 0xaa55