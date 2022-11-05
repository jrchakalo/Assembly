;Autor: José Izaias da Silva Júnior
;Data: 12/07/2022
;Nome do projeto: Questão 2 - Lista de ASM

org 0x7c00            
jmp 0x0000: main 

func:
    ;seta a tela para o modo de video
    setVid:
        mov ah, 00h
        mov al, 01h
        int 10h
    ret

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

    ; printa uma string
    printstring:             
        .loop:
            lodsb           ; bota character em al 
            cmp al, 0       ; ve se a string acabou
            je .endloop     ; se acabou, retorna
            call putchar    ; se não, printa
            jmp .loop       ; repete o loop
        .endloop:
            ret

    ; inverte uma string
    reversestring:              
        mov di, si          ; coloca o endereço de si em di
        xor cx, cx          ; zera o contador

        ; carrega a palavra na pilha
        .loop1:             
            lodsb           ; carrega um caracter em al da memória
            cmp al, 0       ; vê se al vale 0
            je .endloop1    ; se for, a palavra acabou e finaliza o loop1
            inc cl          ; se não for, incrementa o contador
            push ax         ; da um push em ax na pilha
            jmp .loop1      ; repete o loop
        .endloop1:

        ; descarrega a palavra da pilha (invertida)
        .loop2:
            cmp cl, 0       ; ve se o contador vale 0
            je .endloop2    ; se valer, a palavra acabou, encerra a funcão
            dec cl          ; se não, decrementa o contador               
            pop ax          ; da um pop em ax da pilha
            stosb           ; guarda na memória
            jmp .loop2      ; repete o loop
        .endloop2:
            ret

; macro para ler string
%macro lestring 0
    pusha


    call getstring 


    popa
%endmacro

;macro para inverter a string
%macro invertestring 0
    pusha

    call reversestring

    popa
%endmacro

;macro para printar a string
%macro printastring 0
    pusha

    call printstring

    popa
%endmacro

main:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov cx, ax
    mov dx, ax

    ;seta o video
    call setVid

    ;executa os macros
    lestring

    invertestring

    printastring

times 510 - ($ - $$) db 0
dw 0xaa55