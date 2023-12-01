.global _start
_start:
	mov R0,#0
	LDR R1,[R0]
	LDR R11,[R1]
	SUBS R11,R11,#1
	BEQ secuencia1
	b secuencia2
	b _start
// aca va la primera secuencia
secuencia1:
	MOV R0,#0
	mov R9,#15
	LDR R1, [R0, #0] // Loads 0xC000_0000 into R1
Counter:
	MOV R2, #0
Loop:
	MOV R3,#1
	LSL R3,R3,#9
	ADD R3,R3,#1
	SUBS R12, R2, R3 // R4 as a temporal register
	BLS WriteToLeds
	MOV R2, #0// Reset the value
WriteToLeds:
	STR R2, [R1, #4] // Write counter into LEDs	
	lsl R2,R2,#1
	LDR R3, [R0, #4] // Loads delay value into R3
	//acaaaaaaaaaaaaaaaaaaaa
	subs R9,#1
	beq _start
Delay1:
	SUBS R3, R3, #1
	BNE Delay1
	ADD R2, R2, #1 // Increment counter
	B Loop
// aca la segunda secuencia
secuencia2:
	mov R0,#0
	mov R7,#6
	LDR R1, [R0, #0] // Loads 0xC000_0000 into R1
	mov R4,#48
	MOV R6,#48
	b llamadoand
and:
	AND R5,R4,#992
	AND R4,R4,#31
	mov pc,lr
llamadoand:
	bl and
	b sec2_p2
sec2_p2:
	STR R6,[R1,#4]
	LSL R5,R5,#1
	LSR R4,R4,#1
	ORR R6,R4,R5
	LDR R3, [R0, #4] // Loads delay value into R3
	SUBS R7,R7,#1
	BEQ _start
	b Delay
Delay:
	SUBS R3, R3, #1
	BNE Delay
	ADD R2, R2, #1 // Increment counter
	B sec2_p2 
	