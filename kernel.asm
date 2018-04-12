org 0x7e00
jmp 0x0000:start

;Textos menu
titulo      db 'Who Types The Fastest', 0
jogar       db 'Play (1)', 0
instrucoes  db 'Instruction (2)', 0
creditos    db 'Credits (3)', 0

;instrucoes
instrucao1 db 'Are you the fastest typer alive?', 0
instrucao2 db 'Type as many words as you can in 30 seconds', 0
instrucao3 db 'For each wrong letter you lose points', 0
instrucao4 db 'When the time runs out you will have your score', 0
instrucao5 db 'Press Esc to return', 0

;creditos
creditos1 db 'Arthur Henrique <ahtlc>', 0
creditos2 db 'Gabriel Fonseca <gfsca>', 0
creditos3 db 'Gabriel Toscano <gtbo>', 0
creditos4 db 'Press Esc to return', 0

;parte do jogo
texto1 db 'Seu sorriso eh tao resplandecente Que deixou meu coracao alegre Me de a mao pra fugir desta terrivel escuridao Desde o dia em que eu te reencontrei Me lembrei daquele lindo lugar Que na minha infancia era especial pra mim.', 0
points dw 0

;score
score1 db '  Your score  ', 0
score3 db 'WOW, you really are fast', 0
score2 db 'You are as fast as a slug, try again!', 0
score4 db 'You are an average speed typer. I think you can do it better', 0
score5 db 'WHAT?! How can you type that fast? Its like, humanly impossible', 0
score6 db 'Press Esc to return', 0

;funções do jogo

controle_direita_text:
    mov ah, 02h ; setar o cursor
    mov bh, 0   ; pagina
    mov dl, 20
    inc dh
    int 10h
    jmp ret_crt_dir

seta_cursor_text:
    cmp dl, 69
    je controle_direita_text
    ret_crt_dir:
    mov ah, 02h ; setar o cursor
    mov bh, 0   ; pagina
    inc dl
    int 10h
    jmp ret_seta_cursor_text


print_texto:
    lodsb
    cmp al, 0
    je end_text
    mov ah, 0xe
    mov bh, 0
    mov bl, 0xf
    int 10h
    jmp seta_cursor_text
    ret_seta_cursor_text:
    jmp print_texto
    end_text:
        ret

printString:
    lodsb
    mov ah, 0xe
    mov bh, 0
    mov bl, 0xf
    int 10h

    cmp al, 0
    jne printString
    ret

print_score:
   
    push 12 ;pra saber quando parar de dar pop
    mov cl, 10 ; setar 10 como divisor

    mov ah, 02h ; setar o cursor
    mov bh, 0   ; pagina
    mov dl, 38
    mov dh, 5
    int 10h


    mov ax, word [points]
    push_stack:
    div cl ; al = quociente ah = resto
    add ah, 48 ; transforma em caracter
    push ax ; manda pra pilha
    xor ah,ah ; limpa ah
    cmp al, 0 ; se for zero, cabou
    je pop_stack
    jmp push_stack

    pop_stack:
    pop ax
    cmp ax, 12
    je flag_volta
	mov al, ah

    mov ah, 0eh ; setar o cursor
    mov bh, 0   ; pagina
    int 10h

    jmp pop_stack


teclado:        ; funcao para ler o input do teclado na pilha
    push dx     ; salva o que tem em dh e dl

    mov ah, 02h ; escolhe a funcao de ler o tempo do sistema
    int 1aH     ; interrupcao que lida com o tempo do sistema

    cmp dh, 30
    jge score
    
    pop dx      ; retira da pilha os 2 bytes e salva-os em dx

    lodsb   ; carregando o que tá sendo apontado em si para al
    cmp al, 0
    je score

    mov cl , al ;guardando, pra não sobrescrever o que foi puxado da memória

    mov ah, 0   ; prepara o ah para a chamada do teclado
    int 16h     ; interrupcao para ler o caractere e armazena-lo em al
    
    cmp al, 8
    je backspace

    cmp al, cl ; compara o caracter texto e o caracter inserido

    je caracter_verde 
    jne caracter_vermelho
    
seta_cursor:
    cmp dl, 69
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
        inc word [points]
        jmp teclado

    caracter_vermelho:
        mov bl, 4  ; seta a cor do caractere, nesse caso, vermelho
        jmp seta_cursor
        aqui_vm:
        jmp printa_char
        retorno_pChar2:
        cmp word [points], 0
        je teclado
        dec word [points]
        jmp teclado

;fim das funçoes do jogo
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
	mov dl, 36   ;Coluna
	int 10h
    mov si, jogar
    call printString
    
    ;Colocando a string intrucoes
    mov ah, 02h  ;Setando o cursor
	mov bh, 0    ;Pagina 0
	mov dh, 20   ;Linha
	mov dl, 32   ;Coluna
	int 10h
    mov si, instrucoes
    call printString
    
    ;Colocando a string creditos
    mov ah, 02h  ;Setando o cursor
	mov bh, 0    ;Pagina 0
	mov dh, 25   ;Linha
	mov dl, 34   ;Coluna
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
    mov si, points
    mov [si], byte 0

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
    mov dh, 3   ; valor y
    mov dl, 20  ; valor x
    int 10h

    mov si, texto1
    call print_texto


    mov ah, 02h ; setar o cursor
    mov bh, 0   ; pagina
    mov dh, 13   ; valor y
    mov dl, 19  ; valor x
    int 10h

    mov si, texto1

        
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

score:
   ;Carregando o video para limpar a tela
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
    mov dl, 33   ;Coluna
    int 10h
    mov si, score1
    call printString

    call print_score

    flag_volta:
        cmp word [points], 80
        jle arthur
        cmp word [points], 120
        jle average_score
        cmp word [points], 150
        jle fonseca
        jg ninja_typer

ninja_typer:
    ;Colocando o score
    mov ah, 02h  ;Setando o cursor
    mov bh, 0    ;Pagina 0
    mov dh, 12    ;Linha
    mov dl, 15   ;Coluna
    int 10h
    mov si, score5
    call printString
jmp ESCscore

average_score:
    ;Colocando o score
    mov ah, 02h  ;Setando o cursor
    mov bh, 0    ;Pagina 0
    mov dh, 12    ;Linha
    mov dl, 15   ;Coluna
    int 10h
    mov si, score4
    call printString
jmp ESCscore



arthur:
    ;Colocando o score
    mov ah, 02h  ;Setando o cursor
    mov bh, 0    ;Pagina 0
    mov dh, 12    ;Linha
    mov dl, 15   ;Coluna
    int 10h
    mov si, score2
    call printString
jmp ESCscore

fonseca:
    ;Colocando o score
    mov ah, 02h  ;Setando o cursor
    mov bh, 0    ;Pagina 0
    mov dh, 12    ;Linha
    mov dl, 15   ;Coluna
    int 10h
    mov si, score3
    call printString

ESCscore:    
    ;Colocando a string score6
    mov ah, 02h  ;Setando o cursor
	mov bh, 0    ;Pagina 0
	mov dh, 20   ;Linha
	mov dl, 10   ;Coluna
	int 10h
    mov si, score6
    call printString

    ;Para receber o caractere
    mov ah, 0
    int 16h

    ;Apos receber 'Esc' volta pro menu
    cmp al, 27
    je Menu
    jne ESCscore


done:
    jmp $