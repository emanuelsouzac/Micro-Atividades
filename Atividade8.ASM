;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                ATIVIDADE 8 - EMANUEL SOUZA COSTA                *
;*                           20190031695                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICAÇÕES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                       JUNHO DE 2025                             *
;*                 BASEADO NO EXEMPLO DO LIVRO                     *
;*           Desbravando o PIC. David José de Souza                *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINIÇÕES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADRÃO MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_ON & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

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
		
		ANVAL	;VALOR ANALOGICO DA ENTRADA
		
		;NÃO ESQUEÇA COMENTÁRIOS ESCLARECEDORES

	ENDC			;FIM DO BLOCO DE DEFINIÇÃO DE VARIÁVEIS

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SAÍDAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00		;ENDEREÇO INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    INÍCIO DA INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x04		;ENDEREÇO INICIAL DA INTERRUPÇÃO
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SAÍDA DA INTERRUPÇÃO                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *



;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1
	CLRF	INTCON
	MOVLW	B'11001010' ; XX00X010 - GP5, GP4, GP2 E GP0 OUT - GP1 INPUT
	MOVWF	TRISIO
	CLRF	VRCON
	MOVLW	B'00010010' ; X0010010 - FOSC/8 - GP5, GP4, GP2 E GP0 DIGITAL - GP1 ANALOGICO
	MOVWF	ANSEL
	
	BANK0
	MOVLW	B'00000111' ; COMPARADOR OFF
	MOVWF	CMCON
	MOVLW	B'00000100' ; LEFT JUSTIFIED, VDD, AN1
	MOVWF	ADCON0

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;TABELA QUE RELACIONA PINOS ACESOS DE ACORDO COM O VALOR LIDO
;COM BASE NO DECODIFICADOR BCD 7 SEGMENTOS
;		Display	GP5	GP4	GP2	GP0
;V < 0.5	0	0	0	0	0
;0.5 < V < 1.0	1	0	0	0	1
;1.0 < V < 1.5	2	0	0	1	0
;1.5 < V < 2.0	3	0	0	1	1
;2.0 < V < 2.5	4	0	1	0	0
;2.5 < V < 3.0	5	0	1	0	1
;3.0 < V < 3.5	6	0	1	1	0
;3.5 < V < 4.0	7	0	1	1	1
;4.0 < V < 4.5	8	1	0	0	0
;4.5 < V	9	1	0	0	1

;UTIIZANDO RESOLUCAO DE 8 BITS, ESSES SAO OS VALORES CORRESPONDENTES
;AOS VALORES DE TENSAO NA ESCALA 0-255 PARA OS VALORES ENTRE 0V E 5V
;V	N(Dec)	N(Bin)
;0.5     25	00011001
;1.0     51	00110011
;1.5     76	01001100
;2.0     102	01100110
;2.5     127	01111111
;3.0     153	10011001
;3.5     178	10110010
;4.0     204	11001100
;4.5     229	11100101
	
;APOS A CONVERSAO, OS 8 BITS MAIS SIGNIFICATIVOS QUE SE ENCONTRAM NO ADRESH
;SAO LIDOS E O VALOR SALVO NA VARIAVEL ANVAL
;DEPOIS O VALOR SERA COMPARADO COM OS VALORES DE REFERENCIA, PARA DESCOBRIR
;EM QUE INTERVALO A TENSAO SE ENCONTRA
	
MAIN
	BSF	ADCON0,0    ; LIGA O CONVERSOR AD
	BSF	ADCON0,1    ; DISPARA A CONVERSAO

ESPERA
	BTFSC	ADCON0,1    ; AGUARDA ATE A CONVERSAO ENCERRAR (BIT GOnDONE = 0)
	GOTO	ESPERA
	
	BCF	ADCON0,0    ; DESLIGA O CONVERSOR AD
	
	MOVF	ADRESH,W
	MOVWF	ANVAL
	
	MOVLW	.25	    ; VALOR CORRESPONDENTE A 0.5V
	SUBWF	ANVAL,W
	BTFSC	STATUS,C    ; SE ANVAL < 0.5V, C = 0, PULA E DEFINE O VALOR DOS PINOS
	GOTO	MAIOR_QUE_0_5
	BCF	GPIO,GP0
	BCF	GPIO,GP2
	BCF	GPIO,GP4
	BCF	GPIO,GP5
	GOTO	DORME
	
MAIOR_QUE_0_5
	MOVLW	.51	    ; VALOR CORRESPONDENTE A 1.0V
	SUBWF	ANVAL,W
	BTFSC	STATUS,C
	GOTO	MAIOR_QUE_1_0
	BSF	GPIO,GP0
	BCF	GPIO,GP2
	BCF	GPIO,GP4
	BCF	GPIO,GP5
	GOTO	DORME

MAIOR_QUE_1_0
	MOVLW	.76	    ; VALOR CORRESPONDENTE A 1.5V
	SUBWF	ANVAL,W
	BTFSC	STATUS,C
	GOTO	MAIOR_QUE_1_5
	BCF	GPIO,GP0
	BSF	GPIO,GP2
	BCF	GPIO,GP4
	BCF	GPIO,GP5
	GOTO	DORME

MAIOR_QUE_1_5
	MOVLW	.102	    ; VALOR CORRESPONDENTE A 2.0V
	SUBWF	ANVAL,W
	BTFSC	STATUS,C
	GOTO	MAIOR_QUE_2_0
	BSF	GPIO,GP0
	BSF	GPIO,GP2
	BCF	GPIO,GP4
	BCF	GPIO,GP5
	GOTO	DORME

MAIOR_QUE_2_0
	MOVLW	.127	    ; VALOR CORRESPONDENTE A 2.5V
	SUBWF	ANVAL,W
	BTFSC	STATUS,C
	GOTO	MAIOR_QUE_2_5
	BCF	GPIO,GP0
	BCF	GPIO,GP2
	BSF	GPIO,GP4
	BCF	GPIO,GP5
	GOTO	DORME

MAIOR_QUE_2_5
	MOVLW	.153	    ; VALOR CORRESPONDENTE A 3.0V
	SUBWF	ANVAL,W
	BTFSC	STATUS,C
	GOTO	MAIOR_QUE_3_0
	BSF	GPIO,GP0
	BCF	GPIO,GP2
	BSF	GPIO,GP4
	BCF	GPIO,GP5
	GOTO	DORME

MAIOR_QUE_3_0
	MOVLW	.178	    ; VALOR CORRESPONDENTE A 3.5V
	SUBWF	ANVAL,W
	BTFSC	STATUS,C
	GOTO	MAIOR_QUE_3_5
	BCF	GPIO,GP0
	BSF	GPIO,GP2
	BSF	GPIO,GP4
	BCF	GPIO,GP5
	GOTO	DORME

MAIOR_QUE_3_5
	MOVLW	.204	    ; VALOR CORRESPONDENTE A 4.0V
	SUBWF	ANVAL,W
	BTFSC	STATUS,C
	GOTO	MAIOR_QUE_4_0
	BSF	GPIO,GP0
	BSF	GPIO,GP2
	BSF	GPIO,GP4
	BCF	GPIO,GP5
	GOTO	DORME
	
MAIOR_QUE_4_0
	MOVLW	.229	    ; VALOR CORRESPONDENTE A 4.5V
	SUBWF	ANVAL,W
	BTFSC	STATUS,C
	GOTO	MAIOR_QUE_4_5
	BCF	GPIO,GP0
	BCF	GPIO,GP2
	BCF	GPIO,GP4
	BSF	GPIO,GP5
	GOTO	DORME

MAIOR_QUE_4_5
	BSF	GPIO,GP0
	BCF	GPIO,GP2
	BCF	GPIO,GP4
	BSF	GPIO,GP5
	GOTO	DORME
	
DORME
	; PARA GARANTIR UM CICLO DE APROXIMADAMENTE 100ms
	; FORAM UTILIZADAS DUAS CONFIGURAÇOES DE WATCHDOG
	; QUE SOMADAS RESULTAM EM CERCA DE 103ms
	BANK1
	MOVLW	B'00001001' ; 1:2 - APROXIMADAMENTE 34.4ms
	MOVWF	OPTION_REG
	CLRWDT		    ; RESETA O WATCHDOG ANTES DE DORMIR PARA TEMPO CORRETO
	SLEEP		    ; DORME
	NOP
	MOVLW	B'00001010' ; 1:4 - APROXIMADAMENTE 68.7ms
	MOVWF	OPTION_REG
	CLRWDT
	SLEEP
	NOP
	BANK0
	GOTO	MAIN

	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
