;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                ATIVIDADE 7 - EMANUEL SOUZA COSTA                *
;*                           20190031695                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICAÇÕES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                     AGOSTO DE 2024                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       NOME DO PROJETO                           *
;*                           CLIENTE                               *
;*         DESENVOLVIDO PELA MOSAICO ENGENHARIA E CONSULTORIA      *
;*   VERSÃO: 1.0                           DATA: 17/06/03          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     DESCRIÇÃO DO ARQUIVO                        *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;*                                                                 *
;*                                                                 *
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
		DADO		;ARMAZENA O DADO PARA A EEPROM
		
		; CONTADOR UTILIZADO NA COPIA DA EEPROM PARA RAM E VICE-VERSA 
		CONT
		
		; CONTADORES UTILIZADOS NO INSERTION SORT
		CONT1
		CONT2
		
		; VARIAVEIS PARA GUARDAR O MAIOR VALOR ENCONTRADO, ASSIM COMO O ENDERECO
		MAIOR_VALOR
		ENDERECO_DO_MAIOR
		
		; VARIAVEL PARA GUARDAR VALOR DO PIVO NO MOMENTO DA TROCA
		VALOR_DO_PIVO
		
		; VARIAVEL UTILIZADA PARA INFORMAR SE FOI ENCONTRADO UM VALOR MAIOR
		AUX
		

	ENDC			;FIM DO BLOCO DE MEMÓRIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA
; INICIALIZAÇÃO DA EEPROM, DE ACORDO COM A DESCRIÇÃO NO ARQUIVO "Def_Rega_Formigas.inc"

;A PARTIR DO ENDEREÇO ZERO DA EEPROM, DADOS EM ORDEM ALEATÓRIA
	ORG 0x2100
	DE	0X89,0X1E,0X39,0X9F,0XC2,0X0C,0XAB,0X33,0X63,0XD3,0X95,0X7B,0X38,0XD6,0X1E,0X48
	DE	0XDB,0XD8,0X86,0XFD,0XA5,0XFC,0X0C,0XBE,0X68,0X9B,0XD9,0X10,0XD8,0XEC,0X90,0X91
	DE	0XAA,0XBB,0XCC,0XDD,0XEE,0XF1,0XC9,0X77

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
LE_EEPROM
;LER DADO DA EEPROM, CUJO ENDEREÇO É INDICADO EM W
;O DADO LIDO RETORNA EM W
	ANDLW	.127		;LIMITA ENDEREÇO MAX. 127
	BANK1				;ACESSO VIA BANK 1
	MOVWF	EEADR		;INDICA O END. DE LEITURA
	BSF		EECON1,RD	;INICIA O PROCESSO DE LEITURA
	MOVF	EEDATA,W	;COLOCA DADO LIDO EM W
	BANK0				;POSICIONA PARA BANK 0
	RETURN

GRAVA_EEPROM
;ESCREVE UM DADO NA EEPROM, CUJO ENDEREÇO É INDICADO EM W
;O DADO A SER ESCRITO DEVE ESTAR ARMAZENADO NA VARIÁVEL DADO
	ANDLW	.127		;LIMITA ENDEREÇO MAX. 127
	BANK1				;ACESSO VIA BANK 1
	MOVWF	EEADR
	MOVF	DADO,W
	MOVWF	EEDATA
	BSF		EECON1,WREN ;HABILITA ESCRITA
	BCF		INTCON,GIE	;DESLIGA INTERRUPÇÕES
	MOVLW	B'01010101'	;DESBLOQUEIA ESCRITA
	MOVWF	EECON2		;
	MOVLW	B'10101010'	;DESBLOQUEIA ESCRITA
	MOVWF	EECON2		;
	BSF		EECON1,WR ;INICIA A ESCRITA
AGUARDA
	BTFSC	EECON1,WR ;TERMINOU?
	GOTO	AGUARDA
	BSF		INTCON,GIE ;HABILITA INTERRUPÇÕES
	BANK0				;POSICIONA PARA BANK 0
	RETURN

ATUALIZA_MAIOR
	; ENDERECO E VALOR DA MAIOR VARIAVEL ENCONTRADA SAO SALVOS
	MOVFW	CONT2
	MOVWF	ENDERECO_DO_MAIOR
	MOVWF	FSR
	MOVFW	INDF
	MOVWF	MAIOR_VALOR
	BSF	AUX,0	; SE HOUVE ATUALIZACAO, BIT 0 DO AUX VAI PARA ALTO
	RETURN

TROCA
	; SE FOI ENCONTRADO UM VALOR MAIOR DO QUE O PIVO,
	; HAVERA UMA TROCA ENTRE OS DOIS
	MOVFW	CONT1
	MOVWF	FSR
	MOVFW	INDF
	MOVWF	VALOR_DO_PIVO	; SALVO O VALOR DO PIVO
	MOVFW	ENDERECO_DO_MAIOR
	MOVWF	FSR
	MOVFW	VALOR_DO_PIVO
	MOVWF	INDF	; VALOR O PIVO SALVO NA POSICAO QUE FOI ENCONTRADO O MAIOR VALOR
	MOVFW	CONT1
	MOVWF	FSR
	MOVFW	MAIOR_VALOR
	MOVWF	INDF	; MAIOR VALOR SALVO NA POSICAO DO PIVO
	BCF	AUX,0	; VALOR DE AUX VOLTA PARA BAIXO
	RETURN

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
	CLRF	GPIO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
	CLRF	AUX

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

; O ALGORITMO UTILIZADO FOI O INSERTION SORT
; FIXADO UM NUMERO E, INICIALMENTE, ASSUMINDO ELE COMO MAIOR
; BUSCA-SE DO PROXIMO EM DIANTE UM VALOR MAIOR
; SE ENCONTRAR UM VALOR MAIOR, TROCA A POSICAO

MAIN
	BSF	GPIO,GP5    ; GP5 LIGADO PARA INICIAR A ORDENACAO
	
	MOVLW	0X30
	MOVWF	FSR
	
	MOVLW	.0
	MOVWF	CONT

; VALORES DA EEPROM SALVOS NA RAM
LOOP_EEPROM_PARA_RAM
	MOVLW	.40
	SUBWF	CONT,W
	BTFSC	STATUS,Z
	GOTO	INSERTION_SORT
	MOVFW	CONT
	CALL	LE_EEPROM
	MOVWF	INDF
	
	INCF	FSR
	INCF	CONT
	GOTO	LOOP_EEPROM_PARA_RAM

; CONT1 REPRESENTA O PIVO E INICIALMENTE ELE EH TIDO COMO MAIOR VALOR
; CONT2 PERCORRERA OS VALORES ADIANTE, PROCURANDO POR UM VALOR MAIOR
; SEMPRE QUE FOR ENCONTRADO UM MAIOR VALOR, HAVERA UMA ATUALIZACAO
; E ESTE VALOR, TAL COMO SUA POSICAO, FICARAO GUARDADOS
; APOS ENCERRADA A BUSCA, SE FOI ENCONTRAD UM VALOR MAIOR, É FEITA UMA TROCA
; DE POSICOES ENTRE O MAIOR VALOR E O PIVO
; CONT1 ENTAO EH INCREMENTADA E O ALGORITMO SEGUE ATE O ULTIMO VALOR
INSERTION_SORT
	MOVLW	0X30
	MOVWF	CONT1
	
LOOP1
	MOVLW	0X58
	SUBWF	CONT1,W
	BTFSC	STATUS,Z
	GOTO	FIM_LOOP1
	MOVFW	CONT1
	MOVWF	CONT2
	MOVWF	FSR
	MOVWF	ENDERECO_DO_MAIOR   ; CONT1 (PIVO) EH ASSUMIDO COMO MAIOR, ENTAO SEU ENDERECO EH SALVO
	MOVFW	INDF
	MOVWF	MAIOR_VALOR ; CONT1 (PIVO) EH ASSUMIDO COMO MAIOR, ENTAO SEU VALOR EH SALVO
	INCF	CONT2	; CONT2 SEMPRE COMECA UM A FRENTE DE CONT1 (PIVO)
LOOP2
	MOVLW	0X58
	SUBWF	CONT2,W
	BTFSC	STATUS,Z
	GOTO	FIM_LOOP2
	MOVFW	CONT2
	MOVWF	FSR
	MOVFW	INDF
	SUBWF	MAIOR_VALOR,W	;   SE O VALOR DE CONT2 > CONT1, C = 0
	BTFSS	STATUS,C    ; SE C = 0, SIGNIFICA QUE PRECISA ATUALIZAR OS VALORES
	CALL	ATUALIZA_MAIOR
	INCF	CONT2
	GOTO	LOOP2

FIM_LOOP2
	BTFSC	AUX,0	; SO CHAMA TROCA SE HOUVE UMA ATUALIACAO NO VALOR DO MAIOR
	CALL	TROCA
	INCF	CONT1
	GOTO	LOOP1

FIM_LOOP1
	MOVLW	0X30
	MOVWF	FSR
	
	MOVLW	.0
	MOVWF	CONT

; VALORES DA RAM SALVOS NA EEPROM
LOOP_RAM_PARA_EEPROM
	MOVLW	.40
	SUBWF	CONT,W
	BTFSC	STATUS,Z
	GOTO	FIM_GRAVACAO_NA_EEPROM
	MOVFW	INDF
	MOVWF	DADO
	MOVFW	CONT
	CALL	GRAVA_EEPROM
	CLRF	DADO
	
	INCF	FSR
	INCF	CONT
	GOTO	LOOP_RAM_PARA_EEPROM
	
FIM_GRAVACAO_NA_EEPROM
	BCF	GPIO,GP5    ; GP5 DESLIGADO APOS O FIM DA ORDENACAO

FIM
	GOTO FIM

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
