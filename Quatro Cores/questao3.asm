;Autor: José Izaias da Silva Júnior
;Data: 13/07/2022
;Nome do projeto: Questão 3 - Lista de ASM

org 0x7c00            
jmp 0x0000: main 

data:
    ;strings para as cores em minusculo e maiusculo
    am db "amarelo", 0
    az db "azul", 0
    vd db "verde", 0
    vm db "vermelho", 0
    AM db "AMARELO", 0
    AZ db "AZUL", 0
    VD db "VERDE", 0
    VM db "VERMELHO", 0
    na db "NAO EXISTE", 0

func:
    ;seta a tela para o modo de video
    setVid:
        mov ah, 00h
        mov al, 13h
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
        mov bl, 0xf
        int 10h
    ret 

    ; printa um caractere em uma cor especifica
    ; amarelo
    putcharam:
        mov ah, 0x0e
        mov bl, 0xe
        int 10h
    ret 

    ; azul
    putcharaz:
        mov ah, 0x0e
        mov bl, 0x1
        int 10h
    ret

    ; verde
    putcharvd:
        mov ah, 0x0e
        mov bl, 0x2
        int 10h
    ret

    ; vermelho
    putcharvm:
        mov ah, 0x0e
        mov bl, 0x4
        int 10h
    ret

    ; magenta
    putcharmg:
        mov ah, 0x0e
        mov bl, 0x5
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


    ; printa uma string em uma cor especifica
    ; amarelo
    printamarelo: 
        mov si, AM          ; posiciona si em AMARELO       
        .loop:
            lodsb           ; bota character em al 
            cmp al, 0       ; ve se a string acabou
            je .endloop     ; se acabou, retorna
            call putcharam  ; se nao, printa amarelo
            jmp .loop       ; repete o loop
        .endloop:
            ret

    ; azul
    printazul: 
        mov si, AZ          ; posiciona si em AZUL  
        .loop:
            lodsb           ; bota character em al 
            cmp al, 0       ; ve se a string acabou
            je .endloop     ; se acabou, retorna
            call putcharaz  ; se nao, printa azul
            jmp .loop       ; repete o loop
        .endloop:
            ret

    ; verde
    printverde: 
        mov si, VD          ; posiciona si em VERDE 
        .loop:
            lodsb           ; bota character em al 
            cmp al, 0       ; ve se a string acabou
            je .endloop     ; se acabou, retorna
            call putcharvd  ; se nao, printa verde
            jmp .loop       ; repete o loop
        .endloop:
            ret

    ; vermelho
    printvermelho:
        mov si, VM          ; posiciona si em VERMELHO  
        .loop:
            lodsb           ; bota character em al 
            cmp al, 0       ; ve se a string acabou
            je .endloop     ; se acabou, retorna
            call putcharvm  ; se nao, printa vermelho
            jmp .loop       ; repete o loop
        .endloop:
            ret

    ; magenta
    printnexi:              ; posiciona si em NAO EXISTE 
        mov si, na             
        .loop:
            lodsb           ; bota character em al 
            cmp al, 0       ; ve se a string acabou
            je .endloop     ; se acabou, retorna
            call putcharmg  ; se nao, printa magenta
            jmp .loop       ; repete o loop
        .endloop:
            ret

    ;compara a string digitada com a de cada cor
    ; amarelo
    compam:
        mov di, am                  ; põe di em 'amarelo'
        .loop:
            lodsb                   ; puxa um caractere para al
            cmp al, byte[di]        ; compara al com di
            jne .fim1               ; se nao for igual, retorna
            cmp al, 0               ; ve se a string acabou
            je .printam             ; se acabou, printa de amarelo
            inc di                  ; incrementa di
            jmp .loop               ; volta pro loop


        .printam:
            call printamarelo       ; printa em amarelo
            jmp .fim2               ; finaliza o programa

        .fim1:
            ret

        .fim2:
            jmp $

    ; azul
    compaz:
        xor dx, dx
        mov di, az
        .loop:
            lodsb
            cmp al, byte[di]
            jne .fim1
            cmp al, 0
            je .printaz
            inc di
            jmp .loop  
        .printaz:
            call printazul
            mov dx, 9
            jmp .fim2
        .fim1:
            ret

        .fim2:
            jmp $

    ; verde
    compvd:
        mov di, vd
        .loop:
            lodsb
            cmp al, byte[di]
            jne .fim1
            cmp al, 0
            je .printvd
            inc di
            jmp .loop  
        .printvd:
            call printverde
            jmp .fim2
        .fim1:
            ret

        .fim2:
            jmp $

    ; vermelho
    compvm:
        mov di, vm
        .loop:
            lodsb
            cmp al, byte[di]
            jne .fim1
            cmp al, 0
            je .printvm
            inc di
            jmp .loop  
        .printvm:
            call printvermelho
            jmp .fim2
        .fim1:
            ret

        .fim2:
            jmp $

    ; limpa as coisas digitadas e mostradas anteriormente
    limpatela:
        ; coloca o cursor no topo da tela                   
        mov dx, 0 
        mov bh, 0      
        mov ah, 0x2
        int 0x10

        ; printa 2 caracteres brancos pra limpar
        mov cx, 2 
        mov bh, 0
        mov al, 0x20
        mov ah, 0x9
        int 0x10
        
        ; reseta o cursor pro topo da tela
        mov dx, 0 
        mov bh, 0      
        mov ah, 0x2
        int 0x10
        ret
        

; macro para as comparações, para nao alterar os valores dos registradores permanentemente
; macro amarelo
%macro compamarelo 0
     pusha

    call compam

    popa
%endmacro

; macro azul
 %macro compazul 0
    pusha

    call compaz

    popa
%endmacro

; macro verde
%macro compverde 0
    pusha

    call compvd

    popa
%endmacro

; macro vermelho
%macro compvermelho 0
    pusha

    call compvm

    popa
%endmacro

; macro para executar todas as comparações
%macro comparar 0
    pusha

    compamarelo

    compazul

    compverde

    compvermelho

    call printnexi

    popa
%endmacro


main:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov cx, ax
    mov dx, ax

    ; seta o video
    call setVid

    ; lê a string
    call getstring

    ; limpa a tela
    call limpatela

    ; compara e imprime
    comparar

times 510 - ($ - $$) db 0
dw 0xaa55