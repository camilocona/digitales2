//

mergeSort:
LDR R2, =Data //Lista de datos sin arreglar s
LDR R3, =Data2 //Lista de salida arreglada c


If1:
LDR R0, #0 // i
SUB R1, N, #1   //j=N-1
BEQ RETURN  //Cuandi i=j


ADD R4,R0,R1 //M=i+j
ASRS R4, R4, #1 //M=(i+j)/2
ADD R5,R4,#4 //M+1

//LLAMAR MERGESORT   ------DUDA-------
LDR R6, R4 //J=M NUEVA COPIA DE J
BL mergeSort   //MergeSort(I,M)

LDR R7,R5 //I=M+1 NUEVA COPIA DE I
BL mergeSort   //MergeSort(M+1,J)

//DUDA DE COMO ENTRARLE I,J A FUSE
BL fuse

for1:
LDR R8,#0 //K que recorre el fuse

lDR R8, R0  //K <- I
//LDR
CMP R8, R1
BEQ RETURN
ADD R8, R8,#4 //se recorre la lista K++
LDR R2, [R8], #0 //SE GUARDA LA PRIMERA DE LA LISTA DE S
LDR R3, [R8], #0 //SE GUARDA LA PRIMERA DE LA LISTA DE S EN C 


fuse:
LDR R9, R0 //P <-I
LDR R10,R5 //Q <- M+1
LDR R11, R0 //R <- I

WHILE1:
CMP R9,R4
BGT WHILE2 //VA A WHILE2 SI P>M

CPM R10,R1
BGT WHILE2 //VA A WHILE2 SI Q>J
B IFW1
ADD R11,R11,#4  //R++

IFW1:
MOV R6,#0 //SE REUTILIZA PARA Sp
MOV R7,#0 //SE REUTILIZA PARA Sq
MOV R8,#0 //SE REUTILIZA PARA Cr
LDR R6,[R2,R9] //Sp
LDR R7,[R2,R10] //Sq
LDR R8,[R3,R11] //Cr
CMP R6,R7
BGE ELSEW1 //SI R6>=R7 SE VA A ELSEW1
LDR R8,R6   //Cr <- SP
ADD R9,R9,#4 //P++

ELSEW1:
LDR R8,R7  //Cr <- Sq
ADD R10,R10,#4 //Q++

WHILE2:
CMP R9,R4
BGT WHILE3 //VA A WHILE2 SI P>M
LDR R8,R6   //Cr <- Sp
ADD R9,R9,#4 //P++
ADD R11,R11,#4  //R++

WHILE3:
CPM R10,R1
BGT WHILE2 //VA A WHILE2 SI Q>J
LDR R8,R7  //Cr <- Sq
ADD R10,R10,#4 //Q++
ADD R11,R11,#4  //R++

RETURN:
MOV PC,LR
