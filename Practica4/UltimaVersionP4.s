.global _start
.equ MAXN, 200

.text
_start:

MOV R2, #0 //Para el while exterior (i) se pone en 0
MOV R3, #0 //Se pone en 0 para evitar numeros arbitrarios

LDR R1, =datos //Carga de la direccion del arreglo de datos
LDR R4, =N //Carga en R4 la dirección de memoria donde se encuentra la variable N.
LDR R5, [R4] //Carga el valor almacenado en la dirección apuntada por R4 (es decir, el valor de N) en el registro R5.

SUB R5, R5, #1 //Resta 1 para recorrer la lista para el total de elementos -1 porque el último no tendría con cual compararlo
LDR R6, =OP 
LDR R6, [R6] //Carga el valor almacenado en la dirección apuntada R6 que es el valor de OP en el registro R6.
MOV R7, #0 //se inicia en 0

CMP R6, #2 //Se resta R6 con 2, donde se miran las Flags (en este caso N o Z)
BGE _WHILE1ASCENDENTE_ //Se va a _WHILE1ASCENDENTE_ cuando se cumpla la condicion de R6>=2, sino continua a la siguinte instruccion

_WHILE1DESCENDENTE_:
	MOV R0, #0 //Posiciones de memoria
	MOV R8, #4 //Siguiente posicion de memoria	
	MOV R9, #0 //Para el while exterior (j) se pone en 0
	
	CMP R2, R5 // i<N
	BGE FIN_Y_MULTIPLOS //Se va a FIN_Y_MULTIPLOS cuando se cumpla la condicion de R2>=R5, sino continua
	
	ADD R2, R2, #1 // i+1
	B _WHILE2DESCENDENTE_
	
_WHILE2DESCENDENTE_:
	CMP R9,R5	//j<N
	BGE _WHILE1DESCENDENTE_ //Se va a _WHILE1DESCENDENTE_ cuando se cumpla la condicion de R9>=R5, sino continua
	B _if2_

_if2_:			
	LDR R10,[R1,R0] //R10=datos[pos1]  pos actual
	LDR R4,[R1,R8] //R4=datos[pos1+1] ´pos siguiente
	CMP R10, R4  //Compara R10 Y R4 (5 y 3)
	BGE _DESCENDENTE_ //Se va a _DESCENDENTE_ cuando se cumpla la condicion de R10>=R4, sino continua
	STR R4, [R1,R0] //se cambia el orden R4=datos[pos1] pos actual
	STR R10, [R1,R8] //se cambia el orden R10=datos[pos1+1] pos siguiente
	B _CONTADORES2_
	
_DESCENDENTE_: 
	STR R10, [R1,R0]
	STR R4, [R1,R8]
	B _CONTADORES2_
	
_CONTADORES2_:

	ADD R9, R9, #1 //Para el loop interno
	ADD	R0, R0, #4 //Para recorrer la memoria
	ADD R8, R8, #4 //Para recorrer la memoria en una posicion mas
	B _WHILE2DESCENDENTE_
	
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
	BGE Final  //Se va a Final cuando se cumpla la condicion de R3>=R2, sino continua
	
	LDR R4, [R1,R7]
	AND R0, R4, R9
	
	CMP R0, #0
	BEQ MULTIPLO_DE_4  //Se va a MULTIPLO_DE_4 cuando se cumpla la condicion de R0=0, sino continua
	
	
	
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
	B _WHILE2ASCENDENTE_ 

_WHILE2ASCENDENTE_:
	CMP R9,R5	//Genero loop hasta valor N-1 (5 en este caso)
	BGE _WHILE1ASCENDENTE_   //Se va a _WHILE1ASCENDENTE_ cuando se cumpla la condicion de R9>=R5, sino continua
	B _if1_

 _if1_:
	LDR R10,[R1,R0]
	LDR R4,[R1,R8]
	CMP R10, R4
	BGE _ASCENDENTE_ //Se va a _ASCENDENTE_ cuando se cumpla la condicion de R10>=R4, sino continua
	B _CONTADORES_
	
_CONTADORES_:

	ADD R9, R9, #1 //Para el loop interno
	ADD	R0, R0, #4 //Para recorrer la memory
	ADD R8, R8, #4 //Para recorrer la memory en una posicion mas
	B _WHILE2ASCENDENTE_


FIN_Y_MULTIPLOS1: //Multiplos de 2
	MOV R3, #0
	MOV R5, #0
	MOV R10, #0
	ADD R2, R2, #1
	LDR R5, =mult
	B _MULTI1_

_ASCENDENTE_: //Organiza lista
	STR R4, [R1,R0] 
	STR R10, [R1,R8] 
	B _CONTADORES_
	


	
_MULTI1_: //MULTIPLOS DE 2
	MOV R9, #0x01
	CMP R3,R2
	BGE Final //Se va a Final cuando se cumpla la condicion de R3>=R2, sino continua
	
	LDR R4, [R1,R7]
	AND R0, R4, R9
	CMP R0, #0
	BEQ MULTIPLO_DE_2 //Se va a MULTIPLO_DE_2 cuando se cumpla la condicion de R0=0, sino continua
	ADD R7, R7, #4
	ADD R3, R3, #1
	B _MULTI1_
	

	
MULTIPLO_DE_2:
	STR R4, [R5,R10]
	ADD R7, R7, #4
	ADD R10, R10, #4
	ADD R3, R3, #1
	B _MULTI1_
	
Final:
	B Final
	


.data
N: .dc.l 10
datos: .dc.l -4,-12,1,6,136,1571,0,56,1,-977
mult: .dc.l 0
OP: .dc.l 2

SortedData: .ds.l MAXN
