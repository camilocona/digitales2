.global _start
	.equ MAXN, 200

.text
_start:

MOV R2, #0
MOV R3, #0

LDR R1, =datos
LDR R4, =N //Carga en R4 la dirección de memoria donde se encuentra la variable N.
LDR R5, [R4] //Carga el valor almacenado en la dirección apuntada por R4 (es decir, el valor de N) en el registro R5.

SUB R5, R5, #1
LDR R6, =OP
LDR R6, [R6] //Carga el valor almacenado en la dirección apuntada por R6 (es decir, el valor de OP) en el registro R6.

MOV R7, #0

CMP R6, #2
BGE _WHILE1ASCENDENTE_

_WHILE1DESCENDENTE_:
	MOV R0, #0 //Posiciones de memoria
	MOV R8, #4 
	
	MOV R9, #0 //j while interior
	
	CMP R2, R5

	BGE FIN_Y_MULTIPLOS //Comparador para saber si termino con todo el proceso y manda a organizador de multiplos
	
	ADD R2, R2, #1
	b _WHILE2DESCENDENTE_
	
_WHILE2DESCENDENTE_:
	CMP R9,R5	//Genero loop hasta valor N-1 (5 en este caso)
	BGE _WHILE1DESCENDENTE_
	b _if2_

_if2_:			
	LDR R10,[R1,R0]
	LDR R4,[R1,R8]
	CMP R10, R4
	BGE _DESCENDENTE_
	
	STR R4, [R1,R0]
	STR R10, [R1,R8]
	b _CONTADORES2_
	
_DESCENDENTE_: 
	STR R10, [R1,R0]
	STR R4, [R1,R8]
	b _CONTADORES2_
	
_CONTADORES2_:

	ADD R9, R9, #1 //Para el loop interno
	ADD	R0, R0, #4 //Para recorrer la memory
	ADD R8, R8, #4 //Para recorrer la memory en una posicion mas
	b _WHILE2DESCENDENTE_
	
FIN_Y_MULTIPLOS:
	MOV R3, #0
	MOV R5, #0
	MOV R10, #0
	ADD R2, R2, #1
	LDR R5, =mult
	B _MULTI_
	
_MULTI_: //MULTIPLOS DE 4
	MOV R9, #0x03
	CMP R3,R2
	BGE fin
	
	LDR R4, [R1,R7]
	AND R0, R4, R9
	
	CMP R0, #0
	BEQ MULTIPLO_DE_4
	
	
	
	ADD R7, R7, #4
	ADD R3, R3, #1
	B _MULTI_

MULTIPLO_DE_4:
	STR R4, [R5,R10]
	ADD R7, R7, #4
	ADD R10, R10, #4
	ADD R3, R3, #1
	B _MULTI_

	



_WHILE1ASCENDENTE_:
	MOV R0, #0 
	MOV R8, #4 

	MOV R9, #0 //j while interior

	CMP R2, R5
	BGE FIN_Y_MULTIPLOS1	   // While (i<N) 
	ADD R2, R2, #1 //i++
	b _WHILE2ASCENDENTE_ 

_WHILE2ASCENDENTE_:
	CMP R9,R5	//Genero loop hasta valor N-1 (5 en este caso)
	BGE _WHILE1ASCENDENTE_
	b _if1_

 _if1_:
	LDR R10,[R1,R0]
	LDR R4,[R1,R8]
	CMP R10, R4
	BGE _ASCENDENTE_
	
	STR R10, [R1,R0] //PROBAR BORRAR
	STR R4, [R1,R8] //PROBAR BORRAR
	b _CONTADORES_
	
_CONTADORES_:

	ADD R9, R9, #1 //Para el loop interno
	ADD	R0, R0, #4 //Para recorrer la memory
	ADD R8, R8, #4 //Para recorrer la memory en una posicion mas
	b _WHILE2ASCENDENTE_


FIN_Y_MULTIPLOS1: //Multiplos de 2
	MOV R3, #0
	MOV R5, #0
	MOV R10, #0
	ADD R2, R2, #1
	LDR R5, =mult
	B _MULTI1_

_ASCENDENTE_: //Organiza lista
	STR R4, [R1,R0] //PROBAR BORRAR
	STR R10, [R1,R8] //PROBAR BORRAR
	b _CONTADORES_
	


	
_MULTI1_: //MULTIPLOS DE 2
	MOV R9, #0x01
	CMP R3,R2
	BGE fin
	
	LDR R4, [R1,R7]
	AND R0, R4, R9
	CMP R0, #0
	BEQ MULTIPLO_DE_2
	ADD R7, R7, #4
	ADD R3, R3, #1
	B _MULTI1_
	

	
MULTIPLO_DE_2:
	STR R4, [R5,R10]
	ADD R7, R7, #4
	ADD R10, R10, #4
	ADD R3, R3, #1
	B _MULTI1_
	
fin:
	b fin
	


.data
N: .dc.l 10
datos: .dc.l -4,-12,1,6,136,1571,0,56,1,-977
mult: .dc.l 0
OP: .dc.l 2

SortedData: .ds.l MAXN
	
