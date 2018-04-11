org 0x7e00
jmp 0x0000:start

;Textos menu
titulo      db 'Who Types The Fastest', 0
jogar       db 'Play (1)', 0
instrucoes  db 'Instruction (2)', 0
creditos    db 'Credits (3)', 0

;instrucoes
instrucao1 db 'Are you the fastest typer alive?', 0
instrucao2 db 'Type as many words as you can in 60 seconds', 0
instrucao3 db 'For each wrong letter you lose points', 0
instrucao4 db 'When the time runs out you will have your score', 0
instrucao5 db 'Press Esc to return', 0

;creditos
creditos1 db 'Arthur Henrique <ahtlc>', 0
creditos2 db 'Gabriel Fonseca <gfsca>', 0
creditos3 db 'Gabriel Toscano <gtbo>', 0
creditos4 db 'Press Esc to return', 0

;parte do jogo
teste db 'o rato roeu a roupa do rei de roma', 0

;funções do jogo

teclado:        ; funcao para ler o input do teclado
    lodsb   ; carregando o que tá sendo apontado em si para al
    cmp al, 0
    je Menu

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

;fim das funçoes do jogo
;Funçao para printar strings
printString:
		lodsb
		mov ah, 0xe
		mov bh, 0
		mov bl, 0xf
		int 10h

		cmp al, 0
		jne printString
        ret

;Inicio do programa
start:
    ;Zerando os registradores
    mov ax, 0
    mov ds, ax

    ;Chamando a função Menu
    call Menu

    jmp done

Menu:

    ;Carregando o video
    mov ah, 0
    mov al,12h
    int 10h

    ;Mudando a cor do background para azul escuro
    mov ah, 0bh
    mov bh, 0
    mov bl, 1
    int 10h 

    ;Colocando o Titulo
	mov ah, 02h  ;Setando o cursor
	mov bh, 0    ;Pagina 0
	mov dh, 3    ;Linha
	mov dl, 29   ;Coluna
	int 10h
    mov si, titulo
    call printString

    ;Colocando a string jogar
    mov ah, 02h  ;Setando o cursor
	mov bh, 0    ;Pagina 0
	mov dh, 15   ;Linha
	mov dl, 38   ;Coluna
	int 10h
    mov si, jogar
    call printString
    
    ;Colocando a string intrucoes
    mov ah, 02h  ;Setando o cursor
	mov bh, 0    ;Pagina 0
	mov dh, 20   ;Linha
	mov dl, 34   ;Coluna
	int 10h
    mov si, instrucoes
    call printString
    
    ;Colocando a string creditos
    mov ah, 02h  ;Setando o cursor
	mov bh, 0    ;Pagina 0
	mov dh, 25   ;Linha
	mov dl, 36   ;Coluna
	int 10h
    mov si, creditos
    call printString
    
    ;Selecionar a opcao do usuario
    selecao:
        ;Receber a opção
        mov ah, 0
        int 16h
        
        ;Comparando com '1'
        cmp al, 49
        je play
        
        ;Comparando com '2'
        cmp al, 50
        je instrucao
        
        ;Comparando com '3'
        cmp al, 51
        je credito
        
        ;Caso não seja nem '1' ou '2' ou '3' ele vai receber a string dnv
        jne selecao
;Arthur       
play:

    mov ah, 0bh ; chamada pra limpar a tela 
    mov bh, 0
    mov bl, 1
    int 10h 
    
    mov ah, 02h ; setar o cursor
    mov bh, 0   ; pagina
    mov dh, 5   ; valor y
    mov dl, 20  ; valor x
    int 10h

    mov si, teste 
        
    jmp teclado

;Caso seja selecionado "Instruction (2)"
instrucao:
    ;Carregando o video para limpar a tela
    mov ah, 0
    mov al,12h
    int 10h

    ;Mudando a cor do background para azul escuro
    mov ah, 0bh
    mov bh, 0
    mov bl, 1
    int 10h 

    ;Colocando o titulo
	mov ah, 02h  ;Setando o cursor
	mov bh, 0    ;Pagina 0
	mov dh, 3    ;Linha
	mov dl, 29   ;Coluna
	int 10h
    mov si, instrucoes
    call printString

    ;Colocando a string instrucao1
    mov ah, 02h  ;Setando o cursor
	mov bh, 0    ;Pagina 0
	mov dh, 7    ;Linha
	mov dl, 10   ;Coluna
	int 10h
    mov si, instrucao1
    call printString

    ;Colocando a string instrucao2
    mov ah, 02h  ;Setando o cursor
	mov bh, 0    ;Pagina 0
	mov dh, 9    ;Linha
	mov dl, 10   ;Coluna
	int 10h
    mov si, instrucao2
    call printString

    ;Colocando a string instrucao3
    mov ah, 02h  ;Setando o cursor
	mov bh, 0    ;Pagina 0
	mov dh, 11   ;Linha
	mov dl, 10   ;Coluna
	int 10h
    mov si, instrucao3
    call printString

    ;Colocando a string instrucao4
    mov ah, 02h  ;Setando o cursor
	mov bh, 0    ;Pagina 0
	mov dh, 13   ;Linha
	mov dl, 10   ;Coluna
	int 10h
    mov si, instrucao4
    call printString

    ;Colocando a string instrucao5
    mov ah, 02h  ;Setando o cursor
	mov bh, 0    ;Pagina 0
	mov dh, 20   ;Linha
	mov dl, 10   ;Coluna
	int 10h
    mov si, instrucao5
    call printString

ESCinstrucao:    
    ;Para receber o caractere
    mov ah, 0
    int 16h

    ;Apos receber 'Esc' volta pro menu
    cmp al, 27
	je Menu
	jne ESCinstrucao

;Caso seja selecionado "Credits (3)"
credito:
    ;Carregando o video para limpar a tela
    mov ah, 0
    mov al,12h
    int 10h

    ;Mudando a cor do background para azul escuro
    mov ah, 0bh
    mov bh, 0
    mov bl, 1
    int 10h 

    ;Colocando o titulo
	mov ah, 02h  ;Setando o cursor
	mov bh, 0    ;Pagina 0
	mov dh, 3    ;Linha
	mov dl, 29   ;Coluna
	int 10h
    mov si, creditos
    call printString

    ;Colocando a string creditos1
    mov ah, 02h  ;Setando o cursor
	mov bh, 0    ;Pagina 0
	mov dh, 7    ;Linha
	mov dl, 10   ;Coluna
	int 10h
    mov si, creditos1
    call printString

    ;Colocando a string creditos2
    mov ah, 02h  ;Setando o cursor
	mov bh, 0    ;Pagina 0
	mov dh, 9    ;Linha
	mov dl, 10   ;Coluna
	int 10h
    mov si, creditos2
    call printString

    ;Colocando a string creditos3
    mov ah, 02h  ;Setando o cursor
	mov bh, 0    ;Pagina 0
	mov dh, 11   ;Linha
	mov dl, 10   ;Coluna
	int 10h
    mov si, creditos3
    call printString

	;Colocando a string creditos4
    mov ah, 02h  ;Setando o cursor
	mov bh, 0    ;Pagina 0
	mov dh, 20   ;Linha
	mov dl, 10   ;Coluna
	int 10h
    mov si, creditos4
    call printString

ESCcreditos:
	;Para receber o caractere
    mov ah, 0
    int 16h

    ;Apos receber 'Esc' volta pro menu
    cmp al, 27
	je Menu
	jne ESCcreditos

done:
    jmp $