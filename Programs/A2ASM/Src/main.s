;******************** (C) COPYRIGHT HAW-Hamburg ********************************
;* File Name          : main.s
;* Author             : Martin Becke / Erweiterung    
;* Version            : V1.1
;* Date               : 25.10.2026
;* Description        : Erweiterte Version zur Demonstration des Byte-Swaps
;                     : für VariableA und VariableC.
;*******************************************************************************
    EXTERN initITSboard

    EXPORT main

ConstByteA  EQU 0xaffe
    
    AREA DATA, DATA, align=2    
VariableA   DCW 0xbeef
VariableB   DCW 0x1234
VariableC   DCW 0x0000          ; Neue Variable C im RAM angelegt

    AREA  |.text|, CODE, READONLY, ALIGN = 3    
    ALIGN   
main
    BL initITSboard
    
;* swap memory für VariableA (originaler Block)
    ldr     R0,=VariableA   ; Anw01
    ldrb    R2,[R0]         ; Anw02
    ldrb    R3,[R0,#1]      ; Anw03
    lsl     R2, #8          ; Anw04
    orr     R2, R3          ; Anw05
    strh    R2,[R0]         ; Anw06 
    
;* const in var
    mov     R5,#ConstByteA  ; Anw07
    strh    R5,[R0]         ; Anw08
    
;* ERWEITERUNG: Identischer Byte-Swap für VariableC mit dem Inhalt aus R5
;* Ziel: "affe" im Speicher lesbar machen (0xAF auf niedrigerer, 0xFE auf höherer Adresse)
    ldr     R0,=VariableC   ; Lädt die Adresse von VariableC in R0
    strh    R5,[R0]         ; Schreibt den Wert aus R5 (0xAFFE) initial in VariableC (Speicher: FE AF)
    
    ldrb    R2,[R0]         ; Lädt das erste Byte (0xFE) in R2
    ldrb    R3,[R0,#1]      ; Lädt das zweite Byt (0xAF) in R3
    lsl     R2, #8          ; Verschriebt R2 nach links (0xFE -> 0xFE00)
    orr     R2, R3          ; Verknüpft zu 0xFEAF
    strh    R2,[R0]         ; Schreibt 0xFEAF zurück. Speicher (Little-Endian) dreht es zu: AF FE
    
;* Change value so that memory representation is 0x1234 (12 at lower, 34 at higher address)
    ldr     R1,=VariableB   ; Anw09: Lädt die Adresse von VariableB
    ldrh    R6,[R1]         ; Anw0A: Lädt das Halfword (Wert im Register: 0x1234)
    rev16   R6, R6          ; Dreht die Bytes im Register um (Wert im Register wird zu 0x3412)
    strh    R6,[R1]         ; Anw0D: Schreibt 0x3412 zurück. Little-Endian dreht es im Speicher zu: 12 34
    b .                     ; Anw0E: Endlosschleife

    
    ALIGN
    END
