;Autor: José Izaias da Silva Júnior
;Data: 16/07/2022
;Nome do projeto: Questão 4 - Lista de ASM

org 0x7c00            
jmp 0x0000: main

data:
    string times 15 db 0    ; reserva memória para duas strings
    num times 15 db 0  

func:
    ; lê um caractere e retorna
    getchar:
        mov ah, 0x00
        int 16h
    ret

    ; printa o caractere recebido
    putchar:
        mov ah, 0x0e
        int 10h
    ret 

    ; deleta um caractere
    delchar:
        mov al, 0x08          ; coloca o backspace em al
        call putchar          ; printa o backspace
        mov al, ' '           ; coloca um caractere em branco em al
        call putchar          ; printa o caractere em branco
        mov al, 0x08          ; coloca o backspace em al
        call putchar          ; printa o backspace
    ret

    ; quebra uma linha
    endl:
        mov al, 0x0a          ; coloca o caractere de final de linha em al
        call putchar          ; imprime o final de linha
        mov al, 0x0d          ; coloca o cursor na próxima linha
        call putchar          ; imprime
    ret

    ; lê uma string
    getstring:
        xor cx, cx                      ; iguala o contador do tamanho da string a 0     

        loop:
            call getchar                ; lê o caractere
            cmp al, 0x08      
            je apagar                   ; se o caractere for o backspace pula pra funcão de apagar
            cmp al, 0x0d      
            je enter                    ; se o caractere for o enter pula pra conclusão
            cmp cl, 20                  ; seta o tamanho máximo da palavra
            je loop                     
                
            stosb                       ; guarda o caractere
            inc cl                      ; incrementa o contador
            call putchar                ; printa na tela o caractere que você digitou
                
            jmp loop

            ; para quando apertar o backspace
            apagar:
                cmp cl, 0       ; verifica se a palavra esta limpa
                je loop         ; se tiver volta para o loop da escrita
                dec di          ; decrementa di e o contrador
                dec cl
                mov byte[di], 0 ; coloca 0 no valor do byte de di
                call delchar    ; chama o apaga caracter
                jmp loop        ; volta para o loop da escrita
        
        ; para quando apertar o enter
        enter:
            mov al, 0           ; seta al como 0
            stosb               ; guarda na memória
            call endl           ; chama o quebra linha
            ret

    ; printa o caractere na posição do número selecionado
    printchar:
        mov cx, 9               ; iguala cx a 9

        .loop:
            lodsb               ; carrega os caracteres da string em al
            cmp al, 0           ; vê se al chegou no final da string
            je .endloop
            cmp cx, bx          ; compara para ver se o contador chegou na posição desejada
            je .achou           ; se sim vai para achou

            inc cx              ; se não, incrementa o contador
            jmp .loop           ; e continua o loop
        .achou:
            call putchar        ; printa o caractere da posição desejada
            ret
        .endloop:
            ret

    ; transforma uma string em inteiro
    stoi:
        xor cx, cx              ; zera o ax e o cx
        xor ax, ax

        .loop1:
            push ax             ; da um push em ax
            lodsb               ; carrega o caractere da memoria
            mov cl, al          ; salva o caractere em cl
            pop ax              ; da um pop em ax
            cmp cl, 0           ; vê se chegou no fim da string
            je .endloop1
            sub cl, 48          ; tira o '0' da palavra salva em cl
            mov bx, 2          ; coloca 2 em bx
            mul bx              ; multiplica ax por bx
            add ax, cx          ; soma o resultado com cx
            jmp .loop1
        .endloop1:
            ret

;macro para ler a string do número e converter para inteiro
%macro lernum 0

    mov di, num                 ; posiciona di na string num
    call getstring              ; lê a string

    mov si, num                 ; posiciona si na string lida
    call stoi                   ; transforma em inteiro
    mov bx, ax                  ; salva o valor em bx

%endmacro



main:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov bx, ax
    mov cx, ax
    mov dx, ax

    mov di, string              ; posiciona di na string e lê ela
    call getstring

    lernum                      ; macro para ler o número

    mov si, string              ; coloca si na string digitada
    call printchar              ; printa o caractere da posição desejada


times 510 - ($ - $$) db 0
dw 0xaa55