.global _start
.equ MAXN, 200

.text
_start:


LDR R2, =Data //Lista de datos sin arreglar s
LDR R5,=SortedData
MOV R0, #0 // i
LDR R1, =N
LDR R1, [R1]
SUB R1, #1//j=N-1
PUSH {R0}
BL copy_data
POP {R0}
LDR R3, =Data2 //Lista de salida arreglada c
BL mergeSort
B stop
//-------------------------------------------------
	
copy_data: 
	PUSH {LR}
	MOV R0,#0
LOOP_C:
    CMP R0, R1
	BGT DONE
	LDR R3, [R2, R0, LSL #2]	
	STR R3, [R5, R0, LSL #2]	
	ADD R0,R0, #1
	B LOOP_C
DONE:
	POP {LR}
	MOV PC, LR
	

//--------------------------------------------------
mergeSort:  //(s,i,j)
	PUSH {LR,R4,R8} 
	
If1:
	CMP R0,R1
	BNE CONTINUE  //Cuando i!=j
	POP {LR,R4,R8}  //VOLVEMOS A CARGAR ANTES DEL RETORNAR
	MOV PC, LR
	

CONTINUE:
	ADD R4,R0,R1 //M=  i+j FALTA EL /2
	LSR R4, R4, #1 //M=(i+j)/2   
	//LLAMAR POR PRIMERA VEZ MERGESORT   
	PUSH {R0,R1,R4} 
	MOV R1,R4 //J<-M
	BL mergeSort   //MergeSort(s,i,m) 
	POP {R0,R1,R4}

	//------------
	PUSH {R0,R1,R4}
	ADD R4,R4,#1 //M = M+1
	MOV R0,R4 // I <- M+1
	BL mergeSort   //MergeSort(s,m+1,j)
	POP {R0,R1,R4}
	


	  //ENTRADA FUSE(C,I,J,M)
	BL fuse
	MOV R8, R0  //K <- I
	
for1:

	CMP R8, R1
	BGT END
	LDR R12,[R3,R8, LSL #2] //Ck
	STR R12,[R5,R8, LSL #2] //Sk<-Ck
	ADD R8, R8, #1 //se recorre la lista K++
	
	B for1
	
	END:
	POP {LR,R4,R8}  //VOLVEMOS A CARGAR ANTES DEL RETORNAR
	MOV PC, LR


//----------FUSE-------------


fuse:
	PUSH {R6-R11}
	MOV R9, R0 //P <-I
	ADD R10, R4, #1 //Q <- M+1
	MOV R11, R0 //R <- I

WHILE1:
	CMP R9,R4
	BGT WHILE2 //VA A WHILE2 SI P>M

	CMP R10,R1
	BGT WHILE2 //VA A WHILE2 SI Q>J
	B IFW1

IFW1:

	LDR R6,[R5,R9, LSL #2] //Sp
	LDR R7,[R5,R10, LSL #2] //Sq
	CMP R6,R7
	BGE ELSEW1 //SI R6>=R7 SE VA A ELSEW1
	STR R6,[R3,R11, LSL #2] //Cr<-SP
	ADD R9,R9,#1 //P++
	B END_IF

ELSEW1:
	STR R7,[R3,R11, LSL #2] //Cr<-SQ
	ADD R10,R10,#1 //Q++
	
END_IF:
	ADD R11,R11,#1  //R++
	B WHILE1

WHILE2:
	
	CMP R9,R4 
	BGT WHILE3 //VA A WHILE2 SI P>M
	LDR R6,[R5,R9, LSL #2] //Sp
	STR R6,[R3,R11, LSL #2] //Cr<-SP
	ADD R9,R9,#1 //P++
	ADD R11,R11,#1  //R++
	B WHILE2
	
WHILE3:
	
	CMP R10,R1
	BGT DONE_FUSE //VA A WHILE2 SI Q>J
	LDR R7,[R5,R10, LSL #2] //Sq
	STR R7,[R3,R11, LSL #2] //Cr<-SQ
	ADD R10,R10,#1 //Q++	
	ADD R11,R11,#1  //R++
	B WHILE3
	
DONE_FUSE:
	POP {R6-R11}
	MOV PC,LR
	

stop:
	B stop
.data
N: .dc.l 10
Data: .dc.l -4,-12,2,6,136,1571,0,56,4,-977
Data2: .dS.l MAXN
SortedData: .ds.l MAXN	
