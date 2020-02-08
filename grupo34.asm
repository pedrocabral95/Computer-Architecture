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
COL        EQU 8       ; atraves do calculo, 4 * linha + coluna
;***************************
;Constantes para calculos  *
;
;***************************
TRESNUM    EQU 3
QUATRONUM  EQU 4
CINCONUM   EQU 5
SEISNUM	   EQU 6
SETENUM    EQU 7
OITONUM    EQU 8
CATORZE    EQU 14
QUINZENUM  EQU 15
VINTQUATRO EQU 24
VINTNOVE   EQU 29
TRINTUM    EQU 31
PRIMO      EQU 13
;******************************
; 	Dados de asteroide 
;***************************
MASK_BIT_6 EQU 20 			; criado ou nao
MASK_BIT_3 EQU 4 			; tipo 
MASK_BIT_2 EQU 3			; direção

;*********************************************
;Elemento de comparação a usar em hex_to_dec
;*********************************************

A 		   EQU 0AH     ; Elemento de comparação a usar em hex_to_dec

;*********************************
; Controlos do jogo 
;
C          EQU 0CH     ; TECLA C  ; comeca jogo
D          EQU 0DH     ; TECLA D  ; pausa o jogo
E          EQU 0EH     ; TECLA E  ; termina o jogo
ZERO       EQU 00H     ; TECLA 0  ; vira esquerda
UM         EQU 01H     ; TECLA 1  ; dispara1
DOIS       EQU 02H     ; TECLA 2  ; dispara2
TRES       EQU 03H     ; TECLA 3  ; Vira direita
QUATRO     EQU 04H	   ; TECLA 4  ; Tecla Incremento 3 dec

;Atribuiçao de pontos
PONTO      EQU 03H

PONTOMAX   EQU  063H
NENHUMA_TECLA   EQU 00FFH
ECRA_LIM	EQU 8080H
ECRA        EQU 8000H
NUMGRUPO    EQU 034H



;Constantes relativos ao Pixel screen
PIXEL_SCREEN            EQU 08000H
BYTES_POR_LINHA         EQU 4
BYTES_PIXEL_SCREEN      EQU 128
PIXEL_LIMPO EQU 00H
PLACE       2000H

Mascaras:
	STRING 80H, 40H, 20H, 10H, 08H, 04H, 02H, 01H  

pilha:      TABLE 100H      ; Espaco reservado para a pilha

SP_inicial:                 ; Endereço da inicialização do stack pointer (SP)

var_ultima_tecla_pressa:    ; Guarda  a ultima tecla pressionada
    STRING 00H

pintar_apagar:              ; Variavel para apagar/pintar
    STRING 01H

imagem_asteroide: ; forma do asteroide (Multiplicar por 2 pq é WORD )
	WORD asteroide_1
	WORD asteroide_2
	WORD asteroide_3
	WORD asteroide_4
	WORD asteroide_5

imagem_minerio:   ;forma do minerio (Multiplicar por 2 pq é WORD )
	WORD asteroide_1
	WORD asteroide_2
	WORD minerio_1
	WORD minerio_2
	WORD minerio_3





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

asteroide_1:
	STRING UM,UM
	STRING 1
	STRING 1

asteroide_2:
	STRING DOIS,DOIS
	STRING 1,1
	STRING 1,1

asteroide_3:
	STRING TRESNUM,TRESNUM
	STRING 0,1,0
	STRING 1,1,1
	STRING 0,1,0

asteroide_4:
	STRING QUATRONUM, QUATRONUM
	STRING 0,1,1,0
	STRING 1,1,1,1
	STRING 1,1,1,1
	STRING 0,1,1,0

asteroide_5:
	STRING CINCONUM, CINCONUM
	STRING 0,1,1,1,0
	STRING 1,1,1,1,1
	STRING 1,1,1,1,1
	STRING 1,1,1,1,1
	STRING 0,1,1,1,0

minerio_1:
	STRING TRESNUM,TRESNUM
	STRING 1,0,1
	STRING 0,1,0
	STRING 1,0,1

minerio_2:
	STRING QUATRONUM, QUATRONUM
	STRING 1,0,0,1
	STRING 0,1,1,0
	STRING 0,1,1,0
	STRING 1,0,0,1

minerio_3:
	STRING CINCONUM, CINCONUM
	STRING 1,0,0,0,1
	STRING 0,1,0,1,0
	STRING 0,0,1,0,0
	STRING 0,1,0,1,0
	STRING 1,0,0,0,1

atingido:
	STRING CINCONUM,CINCONUM
	STRING 0,1,0,1,0
	STRING 1,0,1,0,1
	STRING 0,1,0,1,0
	STRING 1,0,1,0,1
	STRING 0,1,0,1,0

missil:
	STRING UM,UM
	STRING 1

fim_jogo_jpeg:
	STRING 15,27
	STRING 1,1,1,1,1,1,0,0,0,0,1,1,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1
	STRING 1,1,1,1,1,1,0,0,0,0,1,1,0,0,0,0,0,1,1,1,0,0,0,0,1,1,1
	STRING 1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,1,1,1,1,0,0,1,1,1,1
	STRING 1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,1,1,0,1,1,1,1,0,1,1
	STRING 1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,1,1,0,0,1,1,0,0,1,1
	STRING 1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1
	STRING 1,1,1,1,1,1,0,0,0,0,1,1,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1
	STRING 1,1,1,1,1,1,0,0,0,0,1,1,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1
	STRING 1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1
	STRING 1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1
	STRING 1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1
	STRING 1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1
	STRING 1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1
	STRING 1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1

var_pontuacao:
    STRING 00H

;Indicador de inicio de jogo    
tecla_c_premida:
    STRING 00H

;Indicador de pausa/retoma de jogo
tecla_e_premida:
    STRING 00H
;Indicador de fim de jogo 
tecla_d_premida:
    STRING 00H
primo:
	STRING 00H

tab_asteroide_1:
	STRING 0	  ; 1 - criado , 0 - nao criado
	STRING 0, 14  ; posicao y,x
	STRING 0 	  ; tipo 0 - Mau(asteroide) - 1 (minerio)
	STRING 0      ; varia entre -1, 0 , 1
	STRING 0      ; forma 0(embriao) ate 5 (velho)

tab_asteroide_2:
	STRING 0	  ; 1 - criado , 0 - nao criado
	STRING 0, 14  ; posicao y,x
	STRING 0 	  ; tipo 0 - Mau(asteroide) - 1 (minerio)
	STRING 0      ; varia entre -1, 0 , 1
	STRING 0      ; forma 0(embriao) ate 5 (velho)

missil_1:
	STRING 0,24     ;  ativo, ALTURA




;***************************************
;		DADOS para obter colisao       *
;***************************************




	; Tabela de interrupções
tab:    WORD rot_int_0      ; rotina de atendimento da interrupção 0
		WORD rot_int_1  	; rotina de atendimento da interrupção 0
		
int:	STRING 1

missil_int: STRING 1

; ************
; *  Código  *
; ************

PLACE      0

    MOV SP, SP_inicial 
   	MOV BTE, tab
   
    EI0                      ; permite interrupções 0
    EI1
    EI                       ; permite interrupções (geral)

    ;Antes do jogo começar
    MOV R1, NUMGRUPO    ; Numero do Grupo 
    MOV  R4, DISPLAYS   ; endereço do periférico dos displays
    MOVB [R4], R1       ; escreve nos displays o numero do grupo

;Começo do jogo, ecra limpa e fica a nave pronta!
	
ciclo_jogo:             ; Ciclo jogo
 
    CALL teclado 		; Return tecla pressa
    CALL soma_primo     ; Return posição aleatoria
    CALL ciclo_compara	; return operação a fazer
    CALL verifica_int   ; trata das interrupções dos asteroide
    CALL verifica_miss  ; trata das interrupções do missil
    
 	JMP ciclo_jogo

fim:  JMP fim
;;********************************************
;; Rotina do Teclado:                        *
;;       Return ultima  tecla pressa         * 
;        Regista em memória a ultima         * 
;             tecla pressionada				 *  
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
    PUSH R8
    PUSH R9
    PUSH R10

    ; inicializações
          

    MOV  R2, TEC_LIN   ; endereço do periférico das linhas
  
    
	varrimento:
	    MOV  R3, TEC_COL   ; endereço do periférico das colunas
	    MOV  R1, LINHA     ; testar a linha 
	    MOV  R4, COL       ; variavel para comparar colunas
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



	comparador_de_coluna:

	    CMP  R0,R4         ; Compara valor lido com o controlador da coluna
	    JNE  muda_de_coluna			; se nao for igual, jump para subtrair no contador
	    MOV  R0,R8			; se for igual assume o valor da coluna real

	    ;faz o calculo para descobrir tecla premida
	    MUL  R5, R6     
	    ADD  R5, R0
	    JMP validar_tecla

	muda_de_coluna:
	    SHR  R4, 1          ; muda de coluna
	    SUB  R8, 1          ; subtrai uma coluna ao controlador de colunas
	    CMP  R4, 0          ; para nao ser negativo, coluna negativa
	    JZ   varrimento     ; se nao houver mais colunas volta para varrimento
	    JNZ  comparador_de_coluna

	nenhuma_tecla_lida:
		MOV R5, NENHUMA_TECLA     ; nao há tecla premida, indica à nave para voltar à posicao normal	
	validar_tecla:
	    MOV R6, var_ultima_tecla_pressa             
	    MOVB [R6], R5                       ; se for diferente guarda na memoria
	fim_teclado:

	 	POP R10
	    POP R9
	    POP R8
	    POP R6
	    POP R5
	    POP R4
	    POP R3
	    POP R2
	    POP R1
	    POP R0
	    RET
 
;********************************************************
;                                                		*
;      Processamento da tecla: 				 	 		*
; 		Nesta rotina é processada a ultima tecla premida*
;       , se nada premido, assume nenhuma_tecla_lida    *
;														*
;********************************************************
ciclo_compara:
	PUSH R4
	PUSH R5
	PUSH R8
	PUSH R9
	PUSH R10

	MOV R4, var_ultima_tecla_pressa
	MOVB R5, [R4]

	;Inicio jogo
    MOV R8, C
    CMP R5, R8
    JNZ outras  
        
        ; Confirmamos que a tecla C foi premida
        MOV R9, tecla_c_premida
        MOV R10, 1                 
        MOVB [R9], R10

    JMP  c_tecla_C
    JMP fim_compara

    outras:

        MOV R9, tecla_c_premida ; ciclo em que verificamos se a tecla c ja foi premida (Começo do jogo)
        MOVB R10, [R9]
        CMP R10, 0
        JZ fim_compara




    ; O jogo esta pausado?
    MOV R9, tecla_d_premida 
    MOVB R10, [R9]
    CMP R10, 1				; Se tiver pausado a variavel tecla_d_premida tem  de conter o valor 1
    JZ c_tecla_D 				; tem de ir para a tecla_d para continuar o jogo



    jogo_accao:
    	
    	MOV R8, 0
    	CMP R5, R8
    	JZ c_tecla_0

        MOV R8, UM
        CMP R5, R8
        JZ  c_tecla_1
       
        MOV R8, DOIS
        CMP R5, R8
        JZ  c_tecla_2
      
        MOV R8, TRES
        CMP R5, R8
        JZ  c_tecla_3
        
        MOV R8, E
        CMP R5, R8
        JZ  c_tecla_E

        MOV R8, D
        CMP R5, R8
        JZ  c_tecla_D
       
        MOV R8, NENHUMA_TECLA
        CMP R5, R8
        JZ  c_tecla_nenhuma
        JMP fim_compara

	c_tecla_0:

		CALL tecla_0
		JMP fim_compara

	c_tecla_1:
		CALL tecla_1
		JMP fim_compara

	c_tecla_2:
		CALL tecla_2
		JMP fim_compara

	c_tecla_3:
		CALL tecla_3
		JMP fim_compara
	c_tecla_C:
		CALL tecla_C
		JMP fim_compara

	c_tecla_E:
		CALL tecla_E
		JMP fim_compara
    c_tecla_D:
    	CALL tecla_D
    	JMP fim_compara
	c_tecla_nenhuma:
		CALL tecla_opcao_nenhuma
		JMP fim_compara

	fim_compara:
        POP R10
        POP R9
		POP R8
		POP R5
		POP R4
		RET
	
 
;***************************
;   Rotina Tecla 0 :       *
;          Vira à esquerda *
;          Pinta volante   *
;          para a esquerda *
;***************************
tecla_0:
    PUSH R3
    PUSH R4
    PUSH R9

    ; APAGAR o volante anterior!
    CALL limpa_volante 		
    MOV R3, VINTNOVE
    MOV R4, CATORZE
	MOV R9, volante_esquerda
    CALL pintar_objecto
	
    POP R9
    POP R4
    POP R3
    RET

;************************************
;   Teclas 1 e 2                    *
;        Disparam o missil          *
;           Ativa interrupção       *
;************************************
tecla_1:
	PUSH R0
    PUSH R1
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R9
    
    MOV R3, 24
    MOV R4, QUINZENUM

    MOV R0, missil_1
    MOVB R1, [R0]
    CMP R1, 1
    JZ fim_1
    MOV R9, missil
    CALL pintar_objecto
    MOV R1, 1
    MOVB [R0], R1
	CALL hex_to_dec     ; incrementa os displays (Nao concluido!)
	fim_1:
	    POP R9
	    POP R6
	    POP R5
	    POP R4
	    POP R3
	    POP R1
	    POP R0
	    RET
	   
    
tecla_2:
	CALL tecla_1
    RET
;***************************
;   Tecla 3 :              *
;           Vira à direita *
;          Pinta volante   *
;          para a direita  *
;***************************
tecla_3:
    PUSH R3
    PUSH R4
    PUSH R9
   

   	CALL limpa_volante		; APAGAR o volante!
    MOV R3, VINTNOVE
    MOV R4, CATORZE
    MOV R9, volante_direita
    CALL pintar_objecto
	
	
	POP R9
	POP R4
	POP R3
	RET


;****************************************
;   Tecla C :                           *
;           Começa o jogo               *
;           Escreve a pontuacao inicial *
;           Desenha a nave com o volante*
;           em frente 					*
;			Limpa Ecra                  *
;****************************************  
tecla_C:

    PUSH R3
    PUSH R4
    PUSH R9


	
	CALL limpa_ecra_todo
    CALL rotina_desenha_nave_geral
    MOV R3, VINTNOVE
    MOV R4, CATORZE
    MOV R9, volante
    CALL pintar_objecto
    CALL reset

   
	POP R9
	POP R4
	POP R3
	RET
;************************************
;   Tecla E                         *
;        Termina o jogo             *
;          				            *
;************************************   
tecla_E:
    CALL fim_de_jogo
    MOV  R9, tecla_e_premida
	MOV  R10, 1
    MOVB [R9], R10 				; Confirmamos que a tecla e foi premida (Acaba o jogo)
    MOV  R9, tecla_c_premida
    MOV  R10, 0
    MOVB [R9], R10				; Atribuimos 0 à variavel que tem a informação da tecla c, tem de pressionar C para começar novo jogo
    	
    JMP fim
	RET
;************************************
;   Tecla D                         *
;        Pausa/continua o jogo      *
;                        *
;************************************     
tecla_D:
	
	PUSH R0
    PUSH R1
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R9
    ;					tecla antes de entrar aqui!
    ; compara valores ( tecla_d_premida == 1) --> vamos continuar jogo --> tecla_d_premida = 0
    ; 				  ( tecla_d_premida == 0) --> vamos pausar o jogo --> tecla_d_premida = 1


    MOV R0, tecla_d_premida
    MOVB R1 , [R0]
    CMP R1, 0
    JNZ continuar_jogo
    pausar_jogo:
    	DI
    	MOV  R1, 1
    	MOVB [R0], R1
    	JMP fim_D

    continuar_jogo:
    	EI
    	MOV R1, 0
    	MOVB [R0] , R1
    	JMP fim_D


	fim_D:
	    POP R9
	    POP R6
	    POP R5
	    POP R4
	    POP R3
	    POP R1
	    POP R0
	    RET

;**************************************
;   Pseudo Tecla:                     *
;  Se nao tiver premida nenhuma tecla *
;    pinta o volante em frente        *
;**************************************
tecla_opcao_nenhuma:               ; 
	PUSH R3
    PUSH R4
    PUSH R9

    CALL limpa_volante
    MOV R3, VINTNOVE
    MOV R4, CATORZE
    MOV R9, volante
    CALL pintar_objecto

	POP R9
	POP R4
	POP R3
	RET

;************************************
; Rotina limpa_ecra_todo            *
;    Limpa o ecra todo              *
;                                   *
;************************************
limpa_ecra_todo:
	PUSH R1
	PUSH R2
	
	MOV R1, PIXEL_SCREEN
	MOV R2, ECRA_LIM
	CALL limpa
	
	POP R2
	POP R1
    RET

limpa:


	MOV R3, PIXEL_LIMPO
	MOVB [R1], R3
	ADD R1,1
	CMP R1, R2
	JNE limpa

    RET

limpa_volante:
	PUSH R1
	PUSH R2

	MOV R1,8075H
	MOV R2,8077H
	CALL limpa

	MOV R1,8079H
	MOV R2,807BH

	CALL limpa
	MOV R1,807DH
    MOV R2,807FH
    CALL limpa

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
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R9
    PUSH R10
    
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
    NOT R9             ; Adiciona o bit ao que estava anteriormente no byte
    AND R1, R9
    MOVB [R6], R1     ; Apagamos o  pixel 

    POP  R10
    POP  R9
    POP  R8
    POP  R7
    POP  R6
    POP  R5
    POP  R4
    POP  R3
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

;***************************************
;  Rotina reset 					   *
; Rotina vai colocar nos displays ZERO * 
;									   *
;***************************************
reset:
	PUSH R4
	PUSH R9

	MOV R9, PIXEL_LIMPO       ; Reutilizamos a COnstante PIXEL_LIMPO para reiniciar a contagem
    MOV R4, DISPLAYS
    MOVB [R4], R9
    MOV R4, var_pontuacao
    MOVB [R4], R9

    POP R9
    POP R4
    RET



;**********************************************
; Rotina define_pintar_apagar				  *
;		Recebe R9 como argumento, 1 pinta     *
;								  0 apaga     *
;**********************************************
define_pintar_apagar: 
	PUSH R0
	PUSH R9
	MOV R0, pintar_apagar
    MOVB [R0], R9

    POP R9
    POP R0
    RET

;**********************************************************
; Função geradora - gera atraves da soma de numeros primos*
;**********************************************************

soma_primo:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3

	MOV  R0, primo
	MOVB R1, [R0]     	
	MOV  R3, PRIMO				; somamos um nº primo à nossa variável
	ADD  R1, R3
	MOVB [R0], R1
	MOV  R3, R1
	MOV  R0, MASK_BIT_6			;
	AND  R1, R0 
					; verificamos o 6º bit para saber se ja foi criado
	JZ fim_soma_primo 			; Exemplo : MOV R1, 7  , AND R1,R0
								; 			(1)	1 1 1 1
								;			  	1 0 0 0
								;			-----------
								; 			  	1 0 0 0  
								;              1 - bit 4 é 1, logo queremos criar
	MOV R1, R3
	MOV R0, tab_asteroide_1
	MOVB R2, [R0]
	CMP R2, 0 					; se o asteroide está a 0,  
	JNZ ver_tab_2
	MOV R2, 1
	MOVB [R0] , R2
	CALL cria_tab_inicial
	JMP fim_soma_primo

	ver_tab_2:
		MOV R0, tab_asteroide_2
		MOVB R2, [R0]
		CMP R2, 0
		JNZ fim_soma_primo
		MOV R2, 1
		MOVB [R0] , R2
		CALL cria_tab_inicial

	fim_soma_primo:
		POP R3
		POP R2
		POP R1
		POP R0
		RET


 ;********************************
;Rotina para pintar fim de jogo *
;								*
;********************************

fim_de_jogo:
	
	PUSH R3
	PUSH R4
	PUSH R9


	CALL limpa_ecra_todo
	MOV  R3, CINCONUM
	MOV  R4, TRESNUM
	MOV  R9, fim_jogo_jpeg
	CALL pintar_objecto

	POP  R9
	POP  R4
	POP  R3
	RET


;*****************************************************************
;	Rotina cria_tab_inicial : Cria tabela inicial de um asteroide*
;	Recebe R0 --> tabela do objeto a criar   					 *
;	Recebe R1 --> tipo e direcao             					 *
;											 					 *
;*****************************************************************
cria_tab_inicial:
	PUSH R0
	PUSH R2

	PUSH R1
	MOV R2, MASK_BIT_3
	AND R1, R2         			; vemos o tipo de asteroide
	;JZ 	define_tipo				; 0 - mau  1 - bom
	SHR R1, 3
	ADD R0, 3 
	MOVB [R0], R1
	POP R1
	MOV R2, MASK_BIT_2
	AND R1,R2
	CMP R1, 0
	JZ define_direcao_centro
	CMP R1, 1
	JZ define_direcao_centro
	CMP R1, 2
	JZ define_direcao_esquerdo

	

	define_direcao_direita: ; -1 
		MOV R2, 1
		ADD R0, 1
		MOVB [R0], R2
		JMP fim_cria_tab_inicial
		
	define_direcao_esquerdo:
		MOV R2, -1 
		ADD R0, 1
		MOVB [R0], R2
		JMP fim_cria_tab_inicial
	define_direcao_centro:
		MOV R2, 0 
		ADD R0, 1
		MOVB [R0], R2
		JMP fim_cria_tab_inicial

	fim_cria_tab_inicial:
	POP R2
	POP R0
	RET

;***********************************************************************
;	Rotina movimentar
;		Esta rotina vai movimentar os asteroides atraves da rotina movimenta_tabs
;		atraves da tabela de asteroide 1, le os dados e ve se esta ativo,
;		Se nao estiver ativo, muda para a tabela de asteroide 2	
;
;*************************************************************************

movimentar:
	PUSH R0
	PUSH R1
	

	MOV  R0, tab_asteroide_1
	MOVB R1, [R0]
	CMP  R1, 1
	JNZ verifica_tab_2_movimentar

	CALL movimenta_tabs

	verifica_tab_2_movimentar:
	MOV  R0, tab_asteroide_2
	MOVB R1, [R0]
	CMP  R1, 1 
	JNZ fim_movintar

	CALL movimenta_tabs

	fim_movintar:
	POP R1
	POP R0
	RET

;***********************************************************************
;	Rotina movimenta_tabs 
;		Esta rotina vai movimentar os asteroides recorrendo à rotina buscar_forma,
;       que retorna o tipo de asteroide a movimentar, depois vai ler as coordenadas da posicao
;      R3 ---> linha ---> y R4 --->  coluna ---> x , apagando a forma anterior e e somar 3 à nova posicao
;	   	ao asteroide, depois pinta  na nova posicao
;
;*************************************************************************
movimenta_tabs:
	
	PUSH  R1
	PUSH  R2
	PUSH  R3
	PUSH  R4
	PUSH  R5
	PUSH  R9

	CALL buscar_forma
	PUSH  R0
	ADD  R0, 1
	MOVB R3, [R0]   	 ;Linha ---- y
	ADD  R0, 1
	MOVB R4, [R0]		 ; Coluna  -- x

	MOV  R5, pintar_apagar
	MOV  R2, 0
	MOVB [R5] , R2

	CALL pintar_objecto
	ADD  R0, 2
	MOVB R2, [R0]
	MOV R6, 00FFH
	CMP R2, R6
	JNZ soma_normal
	SUB R4, -1
	JMP fim_soma_normal
	soma_normal:
		ADD  R4, R2         ; Adicionamos ao X a direcao do objecto
	fim_soma_normal:	
		ADD  R3, 1  		; Adicionamos ao y a direcao do objecto
		SUB  R0, 3
		MOVB [R0], R3
		ADD  R0, 1
		MOVB [R0], R4
		ADD  R0, 3
		MOVB R5, [R0]     ;
		CALL atualiza_forma
		POP  R0
		CALL buscar_forma

		MOV  R5, pintar_apagar
		MOV  R2, 1
		MOVB [R5] , R2
		CALL pintar_objecto
	; Recebe R0 --> na posicao da forma
	; Recebe R3 --> linha = y
	; Recebe R5 --> forma atual
		POP R9
		POP R5
		POP R4
		POP R3
		POP R2
		POP R1
		RET

;**************************
; Rotina verifica_int
;	Esta rotina verifica se a interrupção esta ligada,
;   Se ligada vai começar  a movimentar os asteroides
;
;***************************
verifica_int:
	PUSH R0 
	PUSH R1

	MOV  R0, int
	MOVB R1,[R0]	
	CMP  R1, 0
	JZ  fim_vef
	CALL movimentar
	MOV  R1, 0
	MOVB [R0], R1

	fim_vef:
	POP R1
	POP R0
	RET

;**************************
; Rotina verifica_miss
;	Esta rotina verifica se a interrupção esta ligada,
;   Se ligada vai começar  a movimentar o missil
;
;***************************
verifica_miss:
	PUSH R0 
	PUSH R1

	MOV  R0, missil_int
	MOVB R1,[R0]
	CMP  R1, 0
	JZ  fim_miss
	CALL movimentar_missil
	MOV  R1, 0
	MOVB [R0], R1

	fim_miss:
	POP R1
	POP R0
	RET


;***********************************************************************
;	Rotina movimentar_missil
;		Esta rotina vai movimentar o missil  le os dados e ve se esta ativo,
;		Se nao estiver ativo, nao movimenta o missil;
;*************************************************************************
movimentar_missil:
	PUSH R0
	PUSH R1
	PUSH R3
	PUSH R4
	PUSH R6
	PUSH R9

	
    MOV R4, QUINZENUM
    MOV R0, missil_1
    MOVB R1, [R0]

    CMP R1, 1  					; verfiicamos se o missil está ativo
    JNZ fim_movimentar_missil
    ;esta ativo, vamos incrementar a tabela para saber altura do missil
    ADD R0, 1     				; vamos para a STRING "altura"
    MOVB R3, [R0] 				; Recebemos o valor da altura atual
    CMP  R3, 0
    JZ reset_altura  			; Chegou ao topo do ecra

    MOV R5, pintar_apagar
    MOV R6, 0
    MOVB [R5], R6
    ADD R3,1
    MOV R9, missil 
    CALL pintar_objecto
    ADD R1, 1
    SUB R3, 1
    MOVB [R0], R3
    MOV R6, 1
    MOVB [R5], R6
    CALL pintar_objecto
    JMP fim_movimentar_missil
    	
    	reset_altura:
    		MOV R3, 24
    		MOVB [R0], R4
    		JMP fim_movimentar_missil


	fim_movimentar_missil:
	POP R9
	POP R6
	POP R4
	POP R3
	POP R1
	POP R0
	RET

;***********************************************************************
;	Rotina atualiza_forma
;		Esta rotina vai atualizar a forma dos asteroides,
;		assim que queremos pintar o proximo asteroide devemos apagar, 
;       pintar e atualizar a forma do asteroide
;*************************************************************************
atualiza_forma:

	PUSH R1
	PUSH R3
	PUSH R5

	CMP R5, 4
	JZ fim_atualiza_forma
	MOV R1, 3
	DIV R3, R1
	MOV R5, R3
	MOVB [R0], R5

	fim_atualiza_forma:
	POP R5
	POP R3
	POP R1
	RET


;***************************************************
;Rotina buscar_forma 
; 	Recebe R0 ---> tab de asteroides
; 	Retorna R9 ----> forma a pintar (etiqueta)
;   Esta rotina vai buscar a forma segundo a tabela de asteroides
;    returnando um asteroide bom ou um asteroide mau!
;***********************************************************

buscar_forma:
	PUSH  R0
	PUSH  R1
	PUSH  R2
	PUSH  R3
	PUSH  R4

	ADD  R0, 3 			; Vamos Obter o tipo de asteroide 0 - mau - 1 bom
	MOVB R1, [R0]
	CMP  R1, 0
	JZ define_mau
	MOV R2, imagem_minerio
	JMP define_forma

		define_mau:
			MOV R2, imagem_asteroide

	define_forma:		
		ADD  R0, 2
		MOVB R3, [R0]
		SHL R3, 1   		;multiplicamos por 2
		ADD R2, R3
		MOV R9, [R2]


	fim_buscar_forma:
	POP R4
	POP R3
	POP R2
	POP R1
	POP R0
	RET

;deteta_colisao:
;	PUSH R0
;    PUSH R1
;    PUSH R2
;    PUSH R3
;    PUSH R4
;    PUSH R5
;    PUSH R6
;    PUSH R7
;    PUSH R8
;    PUSH R9	
;
;    ; Só o asteroide (ultima fase) sabe se há colisao ou nao!
;    
;	posicao_da_nave:
;    MOV R0, dados_da_nave
;    MOVB R1, [R0]
;     
;    ;posicao do asteroide
;    posicao_asteroide:
;    MOV R3, tabela_asteroide    			
;    MOVB R4, [R3]
;	CMP R4, R1 			; Se a posicao da nave for igual à direcao do asteroide
;    JZ colisao 			;posicao_da_nave == direcao asteroide
;    
;
;    
;    proximo_byte:
;    MOV R2, 8070H
;    CMP R1, R2
;    JZ fim_deteta_colisao
;    MOVB R1, [R0]
;
;	
;	;;como esta em frente, é necessario saber se houve disparo
;    ;MOVB R1, [R02]
;   	;CMP R1, 1
;   	;JZ posicao_asteroide
;    ;se o asteróide estiver passado pela nave, nao ha colisão
;    
;   	colisao:
;		;Tipo de asteroide 
;    	MOV R4,[R2]
;    	CMP R4, 0			;Asteroide
;    	JZ game_over
;    	JNZ pontua
;    	game_over:
;
;    	pontua:
;    		CALL hex_to_dec
;    		JMP fim_deteta_colisao
;
;fim_deteta_colisao:
;	POP R9
;	POP R8
;	POP R7
;	POP R6
;	POP R5
;    POP R4
;    POP R3
;    POP R2
;    POP R1
;    POP R0
;    RET
;	;se o asteróide estiver sido rebentado, não há colisão
;; ******************************************************************************
;; * INTERRUPÇÕES                                                               *
;; ******************************************************************************

;interrupção para os asteroides
rot_int_0:
    PUSH R0
    PUSH R1

    MOV  R0, int
    MOV  R1, 1               ; assinala que houve uma interrupção
    MOVB  [R0], R1   

    POP  R1
    POP  R0
    RFE 
;interrupção para o missil
rot_int_1:
	
    PUSH R0
    PUSH R1

    
    MOV R0, missil_int
    MOV R1, 1 			; assinala que houve uma interrupção
    MOVB [R0], R1

    POP R1
    POP R0
    RFE
