                   .MODEL SMALL

.STACK 400H

.DATA

CR EQU 0AH
LF EQU 0DH
ENTER_N DB 'Enter a number: $'  
INVALID_CHAR DB 'Invalid character. Terminating program $' 
OUTPUT_PROMPT DB 'Number of Co-prime: $'  
ELEM DB 'CO-Primes:', CR, LF, '$' 
NEGATIVE DB ?
N DW ? 

.CODE
MAIN PROC
    ;DATA SEGMENT INTIALIAZATION
    MOV AX, @DATA
    MOV DS, AX
    
    LEA DX, ENTER_N
    MOV AH, 9
    INT 21H
    
    CALL INPUT
    
    CMP CX, 0
    JL END_PROG
    CMP AL, -1
    JE END_PROG
    
    MOV N, CX
    
    CALL NEWLINE
    
    XOR CX, CX
    MOV BX, N
    DEC BX
    
    FIRST_LOOP:
       CMP BX, 1
       JLE END_PROG
             
       MOV AX, N
       PUSH BX
       CALL GCD
       POP BX
       CMP AX, 1
       JNE NOT_CO
       PUSH BX
       INC CX
       
       NOT_CO:
       DEC BX
       JMP FIRST_LOOP   
    
    
    END_PROG:            
    LEA DX, OUTPUT_PROMPT
    MOV AH, 9
    INT 21H
    
    MOV AX, CX
    PUSH CX
    CALL OUTPUT 
    CALL NEWLINE 
    POP CX   
    
    LEA DX, ELEM
    MOV AH, 9
    INT 21H
    
    PRINT:
        CMP CX, 0
        JE END_P
        
        POP AX
        PUSH CX
        CALL OUTPUT
        CALL NEWLINE
        POP CX
        
        DEC CX
        JMP PRINT
        
    END_P:     
    ;EXIT
    MOV AH, 4CH
    INT 21H
        
MAIN ENDP     
       
       
GCD PROC ;AX = GCD(AX, BX)   g(a, b) = (b == 0 ? a : g(b, a % b))
    WHILE:
    CMP BX, 0
    JE BREAK_GCD
    
    XOR DX, DX
    DIV BX
    
    MOV AX, BX
    MOV BX, DX
    
    JMP WHILE
    
    BREAK_GCD:
    
    RET    
    
GCD ENDP
;PRINTS NEWLINE
NEWLINE PROC  
    MOV AH, 2
    MOV DL, CR
    INT 21H   
    MOV DL, LF
    INT 21H
    RET
NEWLINE ENDP

;PRINT WORD FROM AX REGISTER 
OUTPUT PROC
    XOR CX, CX
    MOV BX, 10
    AND NEGATIVE, 0
    CMP AX, 0
    JGE STORE_DIG
    
    INC NEGATIVE
    NEG AX
    
    STORE_DIG:
    
    XOR DX, DX
    DIV BX
    
    ADD DX, '0'
    PUSH DX
    INC CX
    CMP AX, 0
    JNE STORE_DIG
    
    MOV AH, 2
    CMP NEGATIVE, 0
    JE PRINT_DIG
    
    MOV DL, '-'
    INT 21H
    
    PRINT_DIG:
    
    POP DX
    INT 21H    
    LOOP PRINT_DIG
    
    RET 
OUTPUT ENDP

;TAKES INTEGER (2 BYTE AT MOST) AND STORES IN CX REGISTER 
INPUT PROC
    MOV AH, 1
    INT 21H    
                          
    AND NEGATIVE, 0
    XOR CX, CX 
    CMP AL, '-'
    JNE INPUT_DIG
    
    INC NEGATIVE
    INT 21H
    
    INPUT_DIG:   
    
    ;CHECK NEWLINE AND WHITE SPACE
    CMP AL, CR
    JE END_INPUT
    CMP AL, LF
    JE END_INPUT
    CMP AL, ' '
    JE END_INPUT
    
    CALL CHECK_DIGIT
    CMP AL, -1
    JE RET_INPUT
    
    AND AX, 000FH
    MOV BX, AX
    
    MOV AX, 10
    MUL CX
    
    MOV CX, BX
    ADD CX, AX
    
    MOV AH, 1
    INT 21H
    JMP INPUT_DIG  

    END_INPUT:
    
    CMP NEGATIVE, 0
    JE RET_INPUT
    NEG CX
    
    RET_INPUT:
        
    RET

INPUT ENDP
                
               
CHECK_DIGIT PROC      ;CHECK's AL if it's a digit and set's it as -1
    CMP AL, '0'
    JL INVALID
    CMP AL, '9'
    JG INVALID
    RET
    
    INVALID:
    
    CALL NEWLINE
    MOV AH, 9
    LEA DX, INVALID_CHAR
    INT 21H
    CALL NEWLINE
    MOV AL, -1    
    
    RET
CHECK_DIGIT ENDP
END MAIN