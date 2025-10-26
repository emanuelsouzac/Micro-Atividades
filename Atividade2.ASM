;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                ATIVIDADE 2 - EMANUEL SOUZA COSTA                *
;*                           20190031695                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICAÇÕES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                       JULHO DE 2025                             *
;*                 BASEADO NO EXEMPLO DO LIVRO                     *
;*           Desbravando o PIC. David José de Souza               *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINIÇÕES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADRÃO MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINAÇÃO DE MEMÓRIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINIÇÃO DE COMANDOS DE USUÁRIO PARA ALTERAÇÃO DA PÁGINA DE MEMÓRIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEMÓRIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAMÓRIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARIÁVEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DOS NOMES E ENDEREÇOS DE TODAS AS VARIÁVEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDEREÇO INICIAL DA MEMÓRIA DE
					;USUÁRIO
		W_TEMP		;REGISTRADORES TEMPORÁRIOS PARA USO
		STATUS_TEMP	;JUNTO ÀS INTERRUPÇÕES
		
		;COLOQUE AQUI SUAS NOVAS VARIÁVEIS
		X1
		Y1
		Z1
		;NÃO ESQUEÇA COMENTÁRIOS ESCLARECEDORES

	ENDC			;FIM DO BLOCO DE DEFINIÇÃO DE VARIÁVEIS

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SAÍDAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO SAÍDA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDEREÇO INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    INÍCIO DA INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDEREÇO DE DESVIO DAS INTERRUPÇÕES. A PRIMEIRA TAREFA É SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERAÇÃO FUTURA

	ORG	0x04			;ENDEREÇO INICIAL DA INTERRUPÇÃO
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SERÃO ESCRITAS AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUPÇÕES

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SAÍDA DA INTERRUPÇÃO                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUPÇÃO

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRIÇÃO DE FUNCIONAMENTO
; E UM NOME COERENTE ÀS SUAS FUNÇÕES.

EQUILATERO_OU_ISOSCELES
	MOVFW	Z1
	SUBWF	X1,W	; W = X1 - Z1
	BTFSS	STATUS,Z    ;SE X1 = Z1, Z = 1, ENTAO PULA E VAI PARA EQUILATERO, SENAO VAI PARA ISOSCELES
	GOTO	ISOSCELES
	GOTO	EQUILATERO
	
ISOSCELES
	MOVLW	.2
	GOTO	FIM

EQUILATERO
	MOVLW	.3
	GOTO	FIM
	
NAO_E_TRIANGULO
	MOVLW	.4
	GOTO	FIM
	
FIM
	GOTO FIM

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000000' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SAÍDAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000100'
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN

	; DEFININDO O VALOR DAS VARI�VEIS X1, Y1 E Z1
	MOVLW	.8
	MOVWF	X1
	MOVLW	.8
	MOVWF	Y1
	MOVLW	.7
	MOVWF	Z1
	
	; PRIMEIRO, SERA FEITO O TESTE DA REGRA DA DESIGUALDADE TRIANGULAR
	
	; TESTE 1: X1 < Y1 + Z1
	MOVFW	Z1
	ADDWF	Y1,W	; W = Y1+Z1
	SUBWF	X1,W	; W = X1 - (Y1+Z1)
	BTFSC	STATUS,C    ; SE X1 < (Y1+Z1), C = 0, LOGO PULA A PROXIMA INSTRUCAO
	GOTO	NAO_E_TRIANGULO
	
	; TESTE 2: Y1 < X1 + Z1
	MOVFW	Z1
	ADDWF	X1,W	; W = X1+Z1
	SUBWF	Y1,W	; W = Y1 - (X1+Z1)
	BTFSC	STATUS,C    ; SE Y1 < (X1+Z1), C = 0, LOGO PULA A PROXIMA INSTRUCAO
	GOTO	NAO_E_TRIANGULO
	
	; TESTE 3: Z1 < X1 + Y1
	MOVFW	Y1
	ADDWF	X1,W	; W = X1+Y1
	SUBWF	Z1,W	; W = Z1 - (X1+Y1)
	BTFSC	STATUS,C    ; SE Z1 < (X1+Y1), C = 0, LOGO PULA A PROXIMA INSTRUCAO
	GOTO	NAO_E_TRIANGULO
	
	; SE PASSOU PELOS TESTES, SIGNIFICA QUE E UM TRIANGULO
	; RESTA AGORA DEFINIR O TIPO DE TRIANGULO
	
	; SE X1 = Y1, HAVERAO DUAS POSSIBILIDADES:
	; EQUILATERO SE TAMBEM X1 = Z1, SEN�O � IS�SCELES
	MOVFW	Y1
	SUBWF	X1,W	; W = X1 - Y1
	BTFSC	STATUS,Z    ; SE X1 = Y1, Z = 1 E VAI PARA EQUILATERO_OU_ISOSCELES, SENAO PULA
	GOTO	EQUILATERO_OU_ISOSCELES
	
	; SE X1 != Y1, AINDA PODE SER ISOSCELES SE: X1 = Z1 OU Y1 = Z1
	MOVFW	Z1
	SUBWF	X1,W	; W = X1 - Z1
	BTFSC	STATUS,Z    ; SE X1 = Z1, Z = 1 E VAI PARA ISOSCELES, SENAO PULA
	GOTO	ISOSCELES
	
	MOVFW	Z1
	SUBWF	Y1,W	; W = Y1 - Z1
	BTFSC	STATUS,Z    ; SE Y1 = Z1, Z = 1 E VAI PARA ISOSCELES, SENAO PULA
	GOTO	ISOSCELES
	
	; SE NAO � EQUILATERO NEM ISOSCELES, � ESCALENO
	MOVLW	.1
	GOTO	FIM	

	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
