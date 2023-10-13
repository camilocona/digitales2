.global _start
.equ MAXN, 200

.text
_start:


LDR R2, =Data //Lista de datos sin arreglar s
MOV R0, #0 // i
LDR R1, =N
LDR R1, [R1]
SUB R1, #1//j=N-1

mergeSort:  //(s,i,j)
	PUSH {LR,R2,R0,R1,R4} 
	LDR R3, =SortedData //Lista de salida arreglada c
If1:
	CMP R0,R1
	BNE CONTINUE  //Cuando i!=j
	POP {LR,R2,R0,R1,R4}  //VOLVEMOS A CARGAR ANTES DEL RETORNAR
	MOV PC, LR

CONTINUE:
	ADD R4,R0,R1 //M=  i+j FALTA EL /2
	ASR R4, R4, #1 //M=(i+j)/2   
	MOV R1,R4 //J<-M
	//LLAMAR POR PRIMERA VEZ MERGESORT   ------DUDA-------
	
	BL mergeSort   //MergeSort(s,i,m) 


	ADD R5,R4,#1 //M+1
	MOV R0,R5 // I <- M+1

	ADD SP,SP,#16

	BL mergeSort   //MergeSort(s,m+1,j)

	ADD SP,SP,#16


//DUDA DE COMO ENTRARLE I,J A FUSE
	BL fuse

for1:
	MOV R8,#0 //K que recorre el fuse

	MOV R8, R0  //K <- I
	//LDR
	CMP R8, R1
	BEQ RETURN
	ADD R8, R8,#4 //se recorre la lista K++
	LDR R2, [R8], #0 //SE GUARDA LA PRIMERA DE LA LISTA DE S
	LDR R3, [R8], #0 //SE GUARDA LA PRIMERA DE LA LISTA DE S EN C 

//----------FUSE-------------
fuse:

	MOV R9, R0 //P <-I
	MOV R10,R5 //Q <- M+1
	MOV R11, R0 //R <- I

WHILE1:
	CMP R9,R4
	BGT WHILE2 //VA A WHILE2 SI P>M

	CMP R10,R1
	BGT WHILE2 //VA A WHILE2 SI Q>J
	B IFW1
	ADD R11,R11,#4  //R++

IFW1:
	MOV R6,#0 // Sp
	MOV R7,#0 // Sq
	MOV R8,#0 //SE REUTILIZA PARA Cr
	LDR R6,[R2,R9] //Sp
	LDR R7,[R2,R10] //Sq
	LDR R8,[R3,R11] //Cr
	CMP R6,R7
	BGE ELSEW1 //SI R6>=R7 SE VA A ELSEW1
	MOV R8,R6   //Cr <- SP
	ADD R9,R9,#4 //P++

ELSEW1:
	MOV R8,R7  //Cr <- Sq
	ADD R10,R10,#4 //Q++

WHILE2:
	CMP R9,R4
	BGT WHILE3 //VA A WHILE2 SI P>M
	MOV R8,R6   //Cr <- Sp
	ADD R9,R9,#4 //P++
	ADD R11,R11,#4  //R++

WHILE3:
	CMP R10,R1
	BGT WHILE2 //VA A WHILE2 SI Q>J
	MOV R8,R7  //Cr <- Sq
	ADD R10,R10,#4 //Q++	
	ADD R11,R11,#4  //R++

	POP {R2,R0,R1,R3}
	MOV PC,LR
	
RETURN:
	MOV PC,LR

stop:
	B stop
.data
N: .dc.l 10
Data: .dc.l -4,-12,2,6,136,1571,0,56,4,-977
SortedData: .ds.l MAXN
