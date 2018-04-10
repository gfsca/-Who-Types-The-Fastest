org 0x7c00
jmp 0x0000:start

teste db 'o rato roeu a roupa do rei de roma', 0

teclado:        ; funcao para ler o input do teclado
    mov ah, 0   ;prepara o ah para a chamada do teclado
    int 16h     ;interrupcao para ler o caractere e armazena-lo em al
    cmp al, 8
    je backspace
    
    ret

seta_cursor:
    mov ah, 02h ; setar o cursor
    mov bh, 0   ; pagina
    mov dh, 5   ; valor y
    inc dl
    int 10h
    ret

printa_char:
    mov cx, 1
    mov ah, 09h ; codigo para printar caractere apenas onde esta o cursor
    mov bh, 0   ; seta a pagina
    mov bl, 15  ; seta a cor do caractere, nesse caso, branco
    int 10h
    ret

backspace:
    dec dl
    mov ah, 02h ; setar o cursor
    mov bh, 0   ; pagina
    mov dh, 5   ; valor y
    int 10h

    mov al, ' '

    mov cx, 1
    mov ah, 09h ; codigo para printar caractere apenas onde esta o cursor
    mov bh, 0   ; seta a pagina
    mov bl, 15  ; seta a cor do caractere, nesse caso, branco
    int 10h

    jmp loop_to


start:
    xor ax, ax
    mov ds, ax
    mov es, ax

    mov ah, 0   ; escolhe o modo do video
    mov al, 12h ; modo VGA
    int 10h     ; interrupcao de tela

    mov ah, 0bh  ; chamada mudar a cor do background
    mov bh, 0    ; seta a pagina do video, nesse caso como so existe uma, eh 0
    mov bl, 1    ; cor designada ao background
    int 10h

    mov ah, 02h ; setar o cursor
    mov bh, 0   ; pagina
    mov dh, 5   ; valor y
    mov dl, 20  ; valor x
    int 10h

    loop_to:        
        call teclado
        call printa_char
        call seta_cursor

    jmp loop_to


    done:
    jmp $
    times 510 - ($ - $$) db 0
    dw 0xaa55