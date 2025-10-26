## Atividade 2
**Tema:** Tipo de triângulo

**Objetivo:** Exercícios de familiarização com o conjunto de instruções do PIC.

**Especificações:**
* Dado três valores correspondentes aos lados de um triângulo, indicados nas variáveis X1, Y1 e Z1, proponha e implemente um programa escrito em Assembly (PIC12F675) para determinar, com base nos valores, qual é o tipo de triângulo: escaleno, isósceles ou equilátero.
* A resposta deve ser dada através do WORK, de acordo com a seguinte notação:
    * $W=1$ escaleno;
    * $W=2$ isósceles;
    * $W=3$ equilátero;
    * $W=4$ não é um triângulo;

---

## Atividade 3
**Tema:** Controlador de intensidade de um LED

**Objetivo:** Exercicios para gerenciamento de portas, de tempo e de interrupções.

**Especificações:**
* Utilize a template "vazio.asm";
* Duas chaves serão utilizadas para configurar a intensidade do LED, alterando o duty cycle, conforme tabela abaixo:

| Chaves | Duty cycle |
| :--- | :--- |
| 00 | desligado |
| 01 | 10% |
| 10 | 40% |
| 11 | 100% |

* Quando houver duty cycle diferente de 100%, a frequência do sinal deve ser de 500Hz;
* GPO deverá ser utilizado para o bit 0 da chave;
* GP1 deverá ser utilizado para o bit 1 da chave;
* GP5 deverá ser utilizado para ativar o LED
* Pelo menos um TIMER deve ser utilizado;
* Pelo menos uma interrupção deve ser utilizada.

---

## Atividade 4
**Tema:** Controlador automotivo: PISCA

**Objetivo:** Exercícios para gerenciamento de portas e de tempo (com TIMERs e interrupção).

**Contexto:** Sistema de sinalização automotiva, controlando o "pisca-pisca" lados direito e esquerdo, quando acionados.

**Especificações:**
* O sistema contém um interruptor de 3 posições, para acender 2 LEDs (LED-E e LED-D):
    * Quando na posição central, o LED-E e o LED-D permanecem apagados;
    * Quando na posição E (esquerda), o LED-E piscará com frequência de 1 Hz;
    * Quando na posição D (direita), o LED-D piscará com frequência de 1 Hz;
* O sistema contém um interruptor (liga-desliga), para piscar os dois LEDs ao mesmo tempo (função alerta), com frequência de 1 Hz.
* Esse interruptor deve ter maior prioridade;
* GPO deverá ser utilizado com o interruptor que comandará a função "alerta";
* GP1 e GP2 deverão ser utilizados para o interruptor de 3 posições;
* GP4 e GP5 deverão ser utilizados, respectivamente, para os LED-E e LED-D;
* O uso de interrupção é obrigatório.

---

## Atividade 5
**Tema:** Controle de temperatura

**Objetivo:** Exercício de aplicação e gerenciamento do comparador.

**Contexto:** Sistema de controle de temperatura para ambiente refrigerado, utilizando o princípio da histerese para evitar a "flutuação" da comutação no valor de comparação. Para isso, utiliza-se dois valores distintos ($T_{min}$ e $T_{max}$) para definir uma faixa de comutação.

**Como funciona:**
* **Condições iniciais 1:**
    * Supondo que a temperatura de controle do comparador está configurado para $T_{max}$
    * Supondo que a temperatura ambiente ($T_{AR}$), a ser comparada, é superior a $T_{max}$
    * Nessas condições:
        * o compressor deve ser ligado;
        * e altera-se a configuração do comparador para $T_{min}$
* **Condições iniciais 2:**
    * Supondo que a temperatura de controle do comparador está configurado para $T_{min}$;
    * Supondo que a temperatura ambiente ($T_{AR}$), a ser comparada, é inferior a $T_{min}$
    * Nessas condições:
        * o compressor deve ser desligado;
        * e altera-se a configuração do comparador para $T_{max}$
* **Para qualquer outra condição diferente das descritas acima:**
    * Mantém o estado anterior de funcionamento do compressor (ligado ou desligado);
    * Mantém o valor anterior de configuração do comparador ($T_{min}$ ou $T_{max}$).

**Especificações:**
A conversão de temperatura (ºC) para tensão (V) será feita considerando a seguinte expressão:
V = 0,285T − 5,4

As faixas de temperatura de controle deverão ser:
26ºC e 30ºC

* A escolha da equação da tensão de referência do comparador deve ser justificada pela demonstração dos diferentes valores obtidos.
* GP1 deverá ser utilizado para receber o sinal de temperatura;
* GP2 deve ser configurado com entrada digital, embora não seja utilizada nesta aplicação;
* GP5 deverá ser utilizado para fornecer o sinal de controle.

---

## Atividade 6
**Tema:** Conversor A/D: medindo de 0 a 5V em uma escala de 0 a 9 e indicação em BCD

**Objetivo:** Exercício de familiarização com o conversor A/D do PIC.

**Contexto:** Um valor de tensão entre 0 e 5V deve ser representado em uma escala discreta, indicando a escala de 0 a 9 em BCD, para representação em um display de 7 segmentos.

**Especificações:**
* NÃO é permitida a utilização do comparador;
* A tensão de entrada é de OV a 5V;
* A conversão de tensão para a escala de 0 a 9 deve ser efetuada através do conversor A/D;
* O valor da tensão deve ser convertido para codificação BCD para ser conectado ao display de 7 segmentos;
* A indicação deve ser efetuada, em modo cíclico, com taxa de amostragem de 100ms;
* Os bits do display b3,b2,b1,b0 devem ser conectados às portas GP5, GP4, GP2, GP0, respectivamente;
* Os níveis de tensão e a escala correspondente está na descrito na tabela a seguir:

| Valor da tensão (V) | Valor mostrado no display |
| :--- | :--- |
| $V<0,5$ | 0 |
| $0,5<V<1,0$ | 1 |
| $1.0<V<1,5$ | 2 |
| $1,5<V<2,0$ | 3 |
| $2,0<V<2,5$ | 4 |
| $2.5<V<3,0$ | 5 |
| $3,0<V<3,5$ | 6 |
| $3,5<V<4,0$ | 7 |
| $4,0<V<4,5$ | 8 |
| $4,5<V$ | 9 |

---

## Atividade 7
**Tema:** Utilizando a EEPROM

**Objetivo:** Gravar e recuperar dados na memória perene (EEPROM).

**Contexto:** Medir o tempo para colocar em ordem decrescente dados previamente armazenados na EEPROM.

**Especificações:**
* Apague todos os leds;
* Considere 40 bytes já armazenados na EEPROM, a partir do endereço $00_{h}$;
* Acenda o led GP5 imediatamente antes de iniciar a ordenação DECRESCENTE, para sinalizar o início do processo;
* Coloque os dados da EEPROM em ordem DECRESCENTE;
* Apague o led GP5 imediatamente depois para sinalizar que a ordenação DECRESCENTE terminou;
* Para fins de simulação, a medição pode ser efetuada com o stopwatch do MPLAB;
* Na correção da atividade, após a gravação no PIC, a medição será efetuada com o osciloscópio.

---

## Atividade 8
**Tema:** Utilizando o Watchdog e o modo SLEEP

**Objetivo:** Exercício de familiarização com Watchdog e modo Sleep.

**Contexto:** Um valor de tensão entre 0 e 5V deve ser representado em uma escala discreta, indicando a escala de 0 a 9 em BCD, para representação em um display de 7 segmentos. O microcontrolador deve ser mantido em modo sleep, sendo "acordado" pelo watchdog a cada (aproximadamente) 100 ms para atualizar o valor da medida.

**Especificações:**
* A tarefa efetiva do microcontrolador é fazer a conversão A/D e atualizar o valor no display de 7 segmentos;
* Enquanto não estiver em atividade, o microcontrolador deve ser mantido em modo sleep;
* Para sair do modo sleep o watchdog deve ser utilizado;
* A conversão A/D e atualização do display deve ser efetuada, em modo cíclico, com taxa de amostragem de (aproximadamente) 100ms;
* NÃO é permitida a utilização do comparador;
* A tensão de entrada é de OV a 5V;
* A conversão de tensão para a escala de 0 a 9 deve ser efetuada através do conversor A/D;
* O valor da tensão deve ser convertido para codificação B
