;Autor: José Izaias da Silva Júnior
;Data: 12/07/2022
;Nome do projeto: Questão 9 - Lista de ASM

org 0x7c00            
jmp 0x0000: main  

data:
    ;string da bandeira
    band db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 9, 9, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 9, 7, 9, 9, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 9, 7, 9, 9, 9, 9, 0, 0, 0, 0, 9, 9, 0, 0, 0, 0, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 0, 0, 0, 0, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 0, 0, 0, 0, 9, 9, 9, 9, 9, 9, 15, 15, 9, 9, 9, 9, 0, 0, 0, 0, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 0, 0, 0, 0, 9, 9, 9, 9, 15, 15, 15, 9, 9, 9, 9, 9, 0, 0, 0, 0, 9, 9, 9, 9, 9, 9, 15, 15, 9, 9, 9, 9, 0, 0, 0, 0, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 0, 0, 0, 0, 0, 9, 9, 9, 9, 9, 9, 9, 9, 9, 0, 0, 0, 0, 0, 0, 0, 9, 9, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 9, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 9, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 9, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
func:
    ;modo de video
    setVid:
        mov ah, 00h
        mov al, 13h
        int 10h
    ret

    ;func para printar imagem
    printImg:
        ;loop da linha
        linha:
            cmp dx, 16             ; verifica se chegou na linha final
            je fimlinha            ; se chegou, vai para o final do loop da linha 
            mov cx, 0              ; se não, vai para o loop da coluna

            ;loop da coluna
            coluna:
                cmp cx, 16         ; verifica se chegou na coluna final
                je fimcoluna       ; se chegou, vai para o final do loop da coluna
                lodsb              ; carrega a cor em al
                mov ah, 0ch        ; seta o ah para escrever um pixel
                int 10h            ; printa
                inc cx             ; incrementa cx
                jmp coluna         ; volta pro loop da coluna
            fimcoluna:
                inc dx             ; incrementa dx
                jmp linha          ; volta pro loop da linha

        ;finaliza a impressao       
        fimlinha:
            ret
    
main:
    ;zera os registradores
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov cx, ax
    mov dx, ax

    ;seta o modo de video
    call setVid

    ;posiciona si na string da bandeira
    mov si, band

    ;printa a imagem
    call printImg

times 510 - ($ - $$) db 0
dw 0xaa55