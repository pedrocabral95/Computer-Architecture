;##############################################
;#    Instituto Superior Técnico - Taguspark  #
;#                   LEIC-T                   #
;#    Introdução Arquitetura de Computadores  #
;#               2018/2019                    #
;#        Projeto Campo de Asteróides         #
;#              Versão Intermédia             #
;#               Grupo 34                     #
;#      João Sousa        90736               #
;#      Luís Silva        90747               #
;#      Pedro Cabral      90767               #
;#                                            #
;#                                            #
;#   ######################################   #
;#  #                                      #  #
;# #              ##########                # #
;##                                          ##
;##############################################
PLACE 8000H
ecra_inicial:		
		STRING 00H, 04H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 19H, 80H, 00H
		STRING 00H, 19H, 80H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 40H, 28H, 00H
		STRING 00H, 0E0H, 10H , 00H
		STRING 00H, 40H, 28H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 03H, 00H, 02H, 40H
		STRING 07H, 80H, 01H, 80H
		STRING 07H, 80H, 01H, 80H
		STRING 03H, 00H, 02H, 40H
		STRING 00H, 00H, 00H, 00H
		STRING 38H, 02H, 80H, 22H
		STRING 7CH, 05H, 40H, 14H
		STRING 7CH, 02H, 80H, 08H
		STRING 7CH, 05H, 40H, 14H
		STRING 38H, 02H, 80H, 22H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 01H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 01H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 01H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 0FH, 0FFH, 0FFH, 0F0H
		STRING 10H, 00H, 00H, 08H
		STRING 20H, 00H, 00H, 04H
		STRING 40H, 03H, 0C0H, 02H
		STRING 80H, 00H, 00H, 01H
		
;**********************************************
;					Teclado
; *********************************************
; * Constantes
; *********************************************
DISPLAYS   EQU 0A000H  ; endereço dos displays de 7 segmentos (periférico POUT-1)
TEC_LIN    EQU 0C000H  ; endereço das linhas do teclado (periférico POUT-2)
TEC_COL    EQU 0E000H  ; endereço das colunas do teclado (periférico PIN)
LINHA      EQU 8       ; começamos por testar linha 8 (4ª linha, 1000b)
CALC       EQU 4       ; Constante auxiliar para descobrir-mos a tecla premida 
COL        EQU 8          ;atraves do calculo, 4 * linha + coluna
TRESNUM    EQU 3
QUATRONUM  EQU 4
SETENUM    EQU 7
OITONUM    EQU 8
VINTNOVE   EQU 29
CATORZE    EQU 14
TRINTUM    EQU 31
VINTQUATRO EQU 24   
A 		   EQU 0AH     ; Elemento de comparação a usar em hex_to_dec
C          EQU 0CH     ; TECLA C  ; comeca jogo
D          EQU 0DH     ; TECLA D  ; pausa o jogo
E          EQU 0EH     ; TECLA E  ; termina o jogo
ZERO       EQU 00H     ; TECLA 0  ; vira esquerda
UM         EQU 01H     ; TECLA 1  ; dispara1
DOIS       EQU 02H     ; TECLA 2  ; dispara2
TRES       EQU 03H     ; TECLA 3  ; Vira direita
QUATRO     EQU 04H	   ; TECLA 4  ; Tecla Incremento 3 dec
PONTO      EQU 03H
PIXEL_LIMPO EQU 00H
PONTOMAX   EQU  063H
NENHUMA_TECLA   EQU 00FFH
ECRA_LIM	EQU 8080H
ECRA        EQU 8000H
NUMGRUPO    EQU 034H

INICIO EQU 00H

; Pixel screen
PIXEL_SCREEN            EQU 08000H
BYTES_POR_LINHA         EQU 4
BYTES_PIXEL_SCREEN      EQU 128

PLACE       2000H

Mascaras:
	STRING 80H, 40H, 20H, 10H, 08H, 04H, 02H, 01H  

pilha:      TABLE 100H      ; Espaco reservado para a pilha
SP_inicial:                 ; Endereço da inicialização do stack pointer (SP)
var_ultima_tecla_pressa:    ; Guarda  a ultima tecla pressionada
    STRING 00H
pintar_apagar:              ; Variavel para apagar/pintar
    STRING 01H

;++++++++++++++++++++++
;+       Volantes     +
;++++++++++++++++++++++
volante:
    STRING TRESNUM,QUATRONUM   ; VOlante em frente
    STRING 0,0,0,0
    STRING 1,1,1,1
    STRING 0,0,0,0

volante_esquerda:
    STRING TRESNUM,QUATRONUM   ; volante para a esquerda
    STRING 0,0,0,1
    STRING 0,1,1,0
    STRING 1,0,0,0

volante_direita:
    STRING TRESNUM,QUATRONUM   ; volante para a direita
    STRING 1,0,0,0
    STRING 0,1,1,0
    STRING 0,0,0,1

var_pontuacao:
    STRING 00H
tecla_c_premida:
    STRING 00H
; ************
; *  Código  *
; ************
PLACE      0

    MOV SP, SP_inicial 
                        ; Antes do jogo começar
    MOV R1, NUMGRUPO        ;Numero do Grupo 
    MOV  R4, DISPLAYS   ; endereço do periférico dos displays
    MOVB [R4], R1       ; escreve nos displays o numero do grupo


;Começo do jogo, ecra limpa e fica a nave pronta!

ciclo_jogo:             ; Ciclo jogo
    

    CALL teclado
    JMP ciclo_jogo

;*********************************************
; Rotina do Teclado:                         *
;       Nesta fase só existe uma rotina      * 
;        para chamar o teclado               * 
;        e processar a tecla.                *  
;                                            *
;*********************************************
teclado:		

    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R9
    PUSH R10

    ; inicializações
          

    MOV  R2, TEC_LIN   ; endereço do periférico das linhas
    MOV  R3, TEC_COL   ; endereço do periférico das colunas
    MOV  R5, CALC      ; Registamos a contagem para calculo da tecla
    
    
varrimento:
    MOV  R3, TEC_COL   ; endereço do periférico das colunas
    MOV  R4, DISPLAYS  ; endereço do periférico dos displays
    MOV  R1, LINHA     ; testar a linha 
    MOV  R7, COL       ; variavel para comparar colunas
    MOV  R6, TRESNUM         ; indica numero de shr feitos, esta na linha 3 (0,1,2,3)
    MOV  R5, CALC      ; Guarda contagem para calculo da tecla
    MOV  R8, TRESNUM         ; indica a coluna em que esta (0,1,2,3)

espera_tecla:          ; neste ciclo espera-se até uma tecla ser premida
    MOVB [R2], R1      ; escrever no periférico de saída (linhas)
    MOVB R0, [R3]      ; ler do periférico de entrada (colunas)
    CMP  R0, 0         ; há tecla premida?                
    JNZ  comparador_de_coluna 
    SUB  R6, 1
    SHR  R1, 1
    JZ   nenhuma_tecla_lida
    JMP  espera_tecla  ; se nenhuma tecla premida, repete

nenhuma_tecla_lida:
    MOV R5, NENHUMA_TECLA     ; nao há tecla premida, indica à nave para voltar à posicao normal
    JMP validar_tecla

comparador_de_coluna:

    CMP  R0,R7          ; Compara valor lido com o controlador da coluna
    JNE  muda_de_coluna			; se nao for igual, jump para subtrair no contador
    MOV  R0,R8			; se for igual assume o valor da coluna real
    JMP tecla_prem

muda_de_coluna:
    SHR  R7, 1          ; muda de coluna
    SUB  R8, 1          ; subtrai uma coluna ao controlador de colunas
    CMP  R7, 0          ; para nao ser negativo, coluna negativa
    JZ   varrimento     ; se nao houver mais colunas volta para varrimento
    JNZ  comparador_de_coluna

tecla_prem:				;faz o calculo para descobrir tecla premida
    
    MUL  R5, R6		
    ADD  R5, R0

validar_tecla:
    MOV R6, var_ultima_tecla_pressa             
    MOVB R0, [R6]                       ; le ultima tecla premida
    CMP R0, R5                          ; compara a ultima tecla premida com a atual
    JZ varrimento
    MOVB [R6], R5                       ; se for diferente guarda na memoria
    JMP teclas_opcao_0

;*************************************************
;                                                *
;           Processamento da tecla               *
;                                                *
;*************************************************

;***************************
;   Tecla 0 :              *
;          Vira à esquerda *
;          Pinta volante   *
;          para a esquerda *
;***************************
teclas_opcao_0:

    MOV R9,ZERO
    CMP R5, R9
    JNE teclas_opcao_nenhuma

    MOV R0, tecla_c_premida ; ciclo em que verificamos se a tecla c ja foi premida ( Começo do jogo)
    MOVB R1, [R0]
    CMP R1, 0
    JZ teclas_opcao_C

    CALL limpa_ecra_todo
    CALL rotina_desenha_nave_geral
    MOV R3, VINTNOVE
    MOV R4, CATORZE
    MOV R9, volante_esquerda
    CALL pintar_objecto

;**************************************
;   Pseudo Tecla:                     *
;  Se nao tiver premida nenhuma tecla *
;    pinta o volante em frente        *
;**************************************

teclas_opcao_nenhuma:               ; 

    MOV R9,NENHUMA_TECLA
    CMP R5, R9
    JNE teclas_opcao_1

    MOV R0, tecla_c_premida ; ciclo em que verificamos se a tecla c ja foi premida ( Começo do jogo)
    MOVB R1, [R0]
    CMP R1, 0
    JZ teclas_opcao_C
    
    CALL limpa_ecra_todo
    CALL rotina_desenha_nave_geral
     MOV R3, VINTNOVE
    MOV R4, CATORZE
    MOV R9, volante
    CALL pintar_objecto


;************************************
;   Teclas 1 e 2                    *
;        Disparam o missil          *
;           Nao activas             *
;************************************
teclas_opcao_1:

    MOV R9,UM
    CMP R5, R9
    JNE teclas_opcao_2

   
    
teclas_opcao_2:

    MOV R9, DOIS
    CMP R5, R9
    JNE teclas_opcao_3
;***************************
;   Tecla 3 :              *
;           Vira à direita *
;          Pinta volante   *
;          para a direita  *
;***************************
teclas_opcao_3:

    MOV R9, TRES
    CMP R5, R9
    JNE teclas_opcao_C

    MOV R0, tecla_c_premida ; ciclo em que verificamos se a tecla c ja foi premida ( Começo do jogo)
    MOVB R1, [R0]
    CMP R1, 0
    JZ teclas_opcao_C
    
    CALL limpa_ecra_todo
    CALL rotina_desenha_nave_geral
    MOV R3, VINTNOVE
    MOV R4, CATORZE
    MOV R9, volante_direita
    CALL pintar_objecto


;****************************************
;   Tecla C :                           *
;           Começa o jogo               *
;           Escreve a pontuacao inicial *
;           Desenha a nave com o volante*
;           em frente                   *
;****************************************  
teclas_opcao_C:

    MOV R9, C
    CMP R5, R9
    JNE teclas_opcao_D
    CALL limpa_ecra_todo
    CALL rotina_desenha_nave_geral
    
    MOV R9, tecla_c_premida   ; Confirmamos que a tecla C foi premida
    ADD R10, 1                 ;  
    MOVB [R9], R10

    ;reset!!!
    MOV R9, PIXEL_LIMPO       ; Reutilizamos a COnstante PIXEL_LIMPO para reiniciar a contagem
    MOV R4, DISPLAYS
    MOVB [R4], R9
    MOV R4, var_pontuacao
    MOVB [R4], R9
 
;************************************
;   Tecla E                         *
;        Termina o jogo             *
;           Nao activa              *
;************************************   
teclas_opcao_E:

    MOV R9, E
    CMP R5, R9
    JNE teclas_opcao_4

;************************************
;   Tecla D                         *
;        Pausa/continua o jogo      *
;           Nao activa              *
;************************************     
teclas_opcao_D:

    MOV R9, D
    CMP R5, R9
    JNE teclas_opcao_E

;************************************
;   Tecla 4                         *
;        Incrementa pontuaçao       *
;           Escreve em decimal      *
;************************************
teclas_opcao_4:
	
    MOV R9, QUATRO
    CMP R5, R9
    JNE varrimento
   
    CALL hex_to_dec

;************************************
;   Ha_tecla                        *
;    neste ciclo espera-se até      *
;     NENHUMA tecla estar premida   *
;************************************
ha_tecla:              ; neste ciclo espera-se até NENHUMA tecla estar premida
    MOVB [R2], R1      ; escrever no periférico de saída (linhas)
    MOVB R0, [R3]      ; ler do periférico de entrada (colunas)
    CMP  R0, 0         ; há tecla premida?
    JNZ  ha_tecla      ; se ainda houver uma tecla premida, espera até não haver
    JMP  varrimento        ; repete ciclo


    POP R10
    POP R9
    POP R8
    POP R7 
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    POP R0
    RET
;************************************
; Rotina limpa_ecra_todo            *
;    Limpa o ecra todo              *
;                                   *
;************************************
limpa_ecra_todo:
	PUSH R1
	PUSH R2
	PUSH R3
	MOV R1, PIXEL_SCREEN
	MOV R2, ECRA_LIM

limpa:
	MOV R3, PIXEL_LIMPO
	MOVB [R1], R3
	ADD R1,1
	CMP R1, R2
	JNE limpa
	POP R3
	POP R2
	POP R1
    RET



;************************************
;  Rotina apaga_pixel               *
;   Esta rotina Apaga pixeis        *
;************************************


apaga_Pixel:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R10
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R9
    
    MOV  R0, ECRA
    MOV  R2, QUATRONUM
    MOV  R5, R3
    MOV  R6, R4

; R3 Linha do Pixel 
; R4 Coluna do Pixel 
; R5 Linha onde vamos apagar
; R6 Coluna (byte) a apagar (divisão inteira) - IMPORTANTE - Guardar para os próximos ciclos
; R7 Bit a apagar(resto)
; R8 Mascaras
; R9 Bit a apagar

    ;Linha a apagar      ;
    MUL  R5, R2        ; Multiplicar a variável R3 por 4
    ADD  R5, R0        ; Soma dá linha onde vamos apgar

    ;Byte a apagar:     
    SHR  R6, TRESNUM  ; Divisão inteira de 8 (x//8) da variável R4
    ADD  R6, R5        ; Soma dá byte onde vamos apagar

    ;Mascara:
    MOV  R7, R4        ; Coluna onde queremos apagar 
    MOV  R10, OITONUM        ; R10 é 8
    MOD  R7, R10       ; Resto de R7 com R10. O resultado é a localização do bit
    MOV  R8, Mascaras  ; Máscaras em R8
    ADD  R8, R7        ; Adiciona o bit que queremos apgar às máscaras, para saber qual a que se usa

    ;Bit a apagar:
    MOVB R9, [R8]      ; A máscara que se vai usar fica em R9
    MOVB R1, [R6]      ; Enderenço (byte) em que vou escrever em R1
    NOT R1             ; Adiciona o bit ao que estava anteriormente no byte
    AND R9, R1
    MOVB [R6], R9      ; Apagamos o  pixel 

    POP  R9
    POP  R8
    POP  R7
    POP  R6
    POP  R5
    POP  R10
    POP  R2
    POP  R1
    POP  R0
    RET

;************************************
;  Rotina pinta_pixel               *
;   Esta rotina pinta pixeis        *
;************************************

pinta_Pixel:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R9


        
    MOV  R0, ECRA
    MOV  R2, QUATRONUM
    MOV  R5, R3
    MOV  R6, R4

; R3 Linha do Pixel a  escrever
; R4 Coluna do Pixel a escrever
; R5 Linha onde vou escrever
; R6 Coluna (byte) a escrever (divisão inteira) - IMPORTANTE - Guardar para os próximos ciclos
; R7 Bit a escrever (resto)
; R8 Mascaras
; R9 Bit que vamos pintar

    ;Linha a escrever:     ;
    MUL  R5, R2        ; Multiplicar a variável R3 por 4
    ADD  R5, R0        ; Soma dá linha onde vamos escrever

    ;Byte a escrever:      ;
    SHR  R6, TRESNUM         ; Divisão inteira de 8 (x//8) da variável R4
    ADD  R6, R5        ; Soma dá byte onde vamos escrever

    ;Mascara:
    MOV  R7, R4        ; Coluna onde queremos escrever 
    MOV  R10, OITONUM        ; R10 é 8
    MOD  R7, R10       ; Resto de R7 com R10. O resultado é a localização do bit
    MOV  R8, Mascaras  ; Máscaras em R8
    ADD  R8, R7        ; Adiciona o bit que queremos escrever às máscaras, para saber qual a que se usa

    ;Bit a escrever:
    MOVB R9, [R8]      ; A máscara que se vai usar fica em R9
    MOVB R1, [R6]      ; Enderenço (byte) em que vamos escrever em R1
    OR   R9, R1        ; Adiciona o bit ao que estava anteriormente no byte
    MOVB [R6], R9      ; ecrevemos o pixel

    POP  R9
    POP  R8
    POP  R7
    POP  R6
    POP  R5
    POP  R2
    POP  R1
    POP  R0
    RET


;************************************
;  Rotina desenha_nave_geral        *
;   Esta rotina desenha a nave      *
;      sem o volante                *
;************************************

rotina_desenha_nave_geral:
    
    PUSH R3
    PUSH R4
    PUSH R11

        
        desenha_esq:
        MOV R3, TRINTUM         ;começamos na linha 31 
        MOV R4, 0           ;começamos na coluna 0
        MOV R11, QUATRONUM          ;contador

        ciclo_esq:
        CMP R11, 0
        JEQ desenha_frente
        CALL pinta_Pixel
        SUB R3,1
        ADD R4,1
        SUB R11, 1          ;decrementamos contador
        JMP ciclo_esq

        desenha_frente: 
        MOV  R11, VINTQUATRO     ;contador

        ciclo_frente:
        CMP  R11, 0         ;comparamos com o numero de bits a pintar na linha 1 da nave 
        JEQ desenha_dir
        CALL pinta_Pixel
        SUB R11, 1          ;decrementamos contador
        ADD R4,1
        JMP ciclo_frente

        desenha_dir:
        MOV R11, QUATRONUM
        ADD R3,1
        ciclo_dir:
        CMP R11,0
        JEQ rotina_nave_fim
        CALL pinta_Pixel
        ADD R3,1
        ADD R4,1
        SUB R11,1
        JMP ciclo_dir


rotina_nave_fim:
    POP R11
    POP  R4
    POP  R3
    RET


;************************************
;  Rotina  hex_to_dec               *
;   Esta rotina converte de         *
;    hexadecimal para decimal       *
;    e escreve no contador          *
;************************************

hex_to_dec:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    MOV R0, tecla_c_premida ; ciclo em que verificamos se a tecla c ja foi premida ( Começo do jogo)
    MOVB R1, [R0]
    CMP R1, 0
    JZ termina_dec
    
    MOV R0, var_pontuacao
    MOVB R1, [R0]
    MOV R6, PONTOMAX
    CMP R1, R6              ; Comparamos se ja chegou à pontuação maxima (99)
    JZ termina_dec


    ADD R1, PONTO
    MOVB [R0], R1
    MOV R6, R1             ; duplicamos a pontuacao para podermos dividir e obter o resto
    MOV R3, A              
    MOV R4, R1             ;
    MOD R6, R3             ; Obtemos o resto da divisao por A (10 em decimal)
    DIV R4, R3             ; Dividimos por A (10 em decimal)
    SHL R4, QUATRONUM
    OR  R4, R6             ; obtemos o valor final em decimal
    MOV R2, DISPLAYS       ;  
    MOVB [R2], R4           ; escrevemos no contador
termina_dec:
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    POP R0
    RET

;******************************************
;  Rotina  pintar_objecto                 *
;   Esta rotina pinta um objeto dado      *
;   usando o R9, em que R3 é o            *
;   numero de linhas e o R4 é o numero    * 
;   de colunas do objeto                  *
;******************************************

pintar_objecto:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6

    MOVB R0, [R9]   ;Numero de linhas do objecto 
    ADD R9, 1       
    MOVB R1, [R9]   ;Numero de colunas do objecto
    MOV R6, R4      ; guardamos numero de coluna

    ciclo_linhas:
    MOV R2, R1   ; Repomos ciclo de Colunas

    ciclo_colunas:
    ADD R9, 1           ;avançamos na mascara
    MOVB R5, [R9]       ; lemos o pixel (1 pinta 0 nao pinta)
    CMP R5, 1           
    JNZ nao_pinta
    CALL pinta_apaga_pixel
    nao_pinta:
    ADD R4, 1           ; avançamos na coluna caso nao seja para pintar
    SUB R2, 1           ; subtraimos as colunas a pintar
    JNZ ciclo_colunas   
    ADD R3, 1           ;avançamos na linha
    MOV R4, R6          ;repomos o numero da coluna para podermos pintar proxima linha
    SUB R0, 1           ;subtraimos linha ao total a pintar
    JNZ ciclo_linhas

    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    POP R0
    RET
;****************************
; Rotina pinta_apaga_pixel  *
;   Esta rotina auxilia a   *
;   rotina pintar_objecto   *
;   determinando se é para  *
;   apagar o pixel (0) ou   *
;   para pintar (1)         *
;****************************

pinta_apaga_pixel:
    PUSH R0
    PUSH R1

    MOV R0, pintar_apagar
    MOVB R1, [R0]
    CMP R1, 0               ; Se for 1 pintamos, se for 0 apagamos o pixel
    JNZ pintar
    CALL apaga_Pixel
    JMP fim_pinta_apaga
pintar:
    CALL pinta_Pixel

fim_pinta_apaga:
    POP  R1
    POP  R0
    RET


