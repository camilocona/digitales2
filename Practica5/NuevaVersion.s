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
ADD R8, R8,#4 //se recorre la lista
LDR R2, [R8], #0 //SE GUARDA LA PRIMERA DE LA LISTA DE S
LDR R3, [R8], #0 //SE GUARDA LA PRIMERA DE LA LISTA DE S EN C 


fuse:




RETURN:
MOV PC,LR
