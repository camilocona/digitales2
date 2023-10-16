.global _start
.equ MAXN, 200

.text
_start:


LDR R2, =Data //Lista de datos sin arreglar s
MOV R0, #0 // i
LDR R1, =N
LDR R1, [R1]
SUB R1, #1//j=N-1

forC:


BL mergeSort
B stop

mergeSort:  //(s,i,j)
	PUSH {LR} 
	LDR R3, =Data2 //Lista de salida arreglada c
If1:
	CMP R0,R1
	BNE CONTINUE  //Cuando i!=j
	POP {LR}  //VOLVEMOS A CARGAR ANTES DEL RETORNAR
	MOV PC, LR
	

CONTINUE:
	ADD R4,R0,R1 //M=  i+j FALTA EL /2
	LSR R4, R4, #1 //M=(i+j)/2   
	//LLAMAR POR PRIMERA VEZ MERGESORT   ------DUDA-------
	PUSH {R2,R0,R1,R4} 
	MOV R1,R4 //J<-M
	BL mergeSort   //MergeSort(s,i,m) 
	
	POP {R2,R0,R1,R4}
	
	PUSH {R2,R0,R1,R4}
	
	ADD R4,R4,#1 //M = M+1
	MOV R0,R4 // I <- M+1

	BL mergeSort   //MergeSort(s,m+1,j)
	POP {R2,R0,R1,R4}
	


	
//DUDA DE COMO ENTRARLE I,J A FUSE
	PUSH {R3,R0,R1}  //ENTRADA FUSE(C,I,J)
	BL fuse
	POP {R3,R0,R1}

for1:
	MOV R8,#0 //K que recorre el fuse

	MOV R8, R0  //K <- I
	//LDR
	CMP R8, R1
	LDR R8,[R8]
	
	ADD R8, R8, #1 //se recorre la lista K++
	LDR R2, [R8, LSL #2], #0 //SE GUARDA LA PRIMERA DE LA LISTA DE S
	LDR R3, [R8, LSL #2], #0 //SE GUARDA LA PRIMERA DE LA LISTA DE S EN C
	BLE for1
	
	POP {LR}  //VOLVEMOS A CARGAR ANTES DEL RETORNAR
	MOV PC, LR


//----------FUSE-------------


fuse:
	MOV R9, R0 //P <-I
	MOV R10,R4 //Q <- M+1
	MOV R11, R0 //R <- I

WHILE1:
	CMP R9,R4
	BGT WHILE2 //VA A WHILE2 SI P>M

	CMP R10,R1
	BGT WHILE2 //VA A WHILE2 SI Q>J
	B IFW1
	ADD R11,R11,#1  //R++

IFW1:
	MOV R6,#0 // Sp
	MOV R7,#0 // Sq
	MOV R8,#0 //SE REUTILIZA PARA Cr
	LDR R6,[R2,R9, LSL #2] //Sp
	LDR R7,[R2,R10, LSL #2] //Sq
	LDR R8,[R3,R11, LSL #2] //Cr
	CMP R6,R7
	BGE ELSEW1 //SI R6>=R7 SE VA A ELSEW1
	STR R6,[R8]   //Cr <- SP
	ADD R9,R9,#1 //P++

ELSEW1:
	MOV R8,R7  //Cr <- Sq
	ADD R10,R10,#1 //Q++

WHILE2:
	CMP R9,R4
	BGT WHILE3 //VA A WHILE2 SI P>M
	MOV R8,R6   //Cr <- Sp
	ADD R9,R9,#1 //P++
	ADD R11,R11,#1  //R++

WHILE3:
	CMP R10,R1
	BGT WHILE2 //VA A WHILE2 SI Q>J
	MOV R8,R7  //Cr <- Sq
	ADD R10,R10,#1 //Q++	
	ADD R11,R11,#1  //R++
	
	MOV PC,LR
	

stop:
	B stop
.data
N: .dc.l 10
Data: .dc.l -4,-12,2,6,136,1571,0,56,4,-977
Data2: .dc.l 0
SortedData: .ds.l MAXN	
