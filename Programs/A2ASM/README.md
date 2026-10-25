    ldr     R0,=VariableA   ; Anw01 load address of VariableA into R0
    ldrb    R2,[R0]         ; Anw02 load first byte of VariableA into R2
    ldrb    R3,[R0,#1]      ; Anw03 load second byte of VariableA into R3
    lsl     R2, #8          ; Anw04 shift R2 left by 8 bits to make space for the second byte
    orr     R2, R3          ; Anw05 combine R2 and R3 to form the new value
    strh    R2,[R0]         ; Anw06 store the new value back into VariableA


Zeile	Befehl	            Register R0	Register R2	Register R3
Anw01	ldr R0,=VariableA	0x20000000	unverändert	unverändert
Anw02	ldrb R2,[R0]	    0x20000000	0x000000EF	unverändert
Anw03	ldrb R3,[R0,#1]	    0x20000000	0x000000EF	0x000000BE
Anw04	lsl R2, #8	        0x20000000	0x0000EF00	0x000000BE
Anw05	orr R2, R3	        0x20000000	0x0000EFBE	0x000000BE
Anw06	strh R2,[R0]	    0x20000000	0x0000EFBE	0x000000BE
