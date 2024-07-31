.MODEL SMALL

.STACK 400H

.DATA

CR EQU 0AH
LF EQU 0DH
ENTER_N DB 'Enter number of elements in array: $'  
ENTER_ELEMENTS DB 'Enter array elements: ', CR, LF, '$'
SORTED_ARRAY DB 'Sorted array: $'                   
SEARCH_QUERY DB 'Enter an integer to search in array: $'
QUERY_SUCCESSFUL DB ' is found at position $' 
QUERY_UNSUCCESSFUL DB ' is not found.', CR, LF, '$'
INVALID_CHAR DB 'Invalid character. Terminating program $'
NEGATIVE DB ?
N DW ? 

ARR DW 200 DUP(?)
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
    
    XOR BX, BX
    
    LEA SI, ARR
    LEA DX, ENTER_ELEMENTS
    MOV AH, 9
    INT 21H
    
    ARRAY_INPUT: 
    
    CMP N, BX
    JNG SORTING
    
    PUSH BX
    CALL INPUT 
    CMP AL, -1
    JE END_PROG
    
    MOV [SI], CX
    
    CALL NEWLINE
    
    POP BX
    
    INC BX
    ADD SI, 2
    
    JMP ARRAY_INPUT
    
    SORTING:       
           
    CALL SORT
    
    LEA SI, ARR 
    XOR BX, BX
    
    LEA DX, SORTED_ARRAY
    MOV AH, 9
    INT 21H
    
    PRINT:        
    
    CMP N, BX
    JNG SEARCHING
    
    PUSH BX 
    MOV AX, [SI]
    
    CALL OUTPUT 
    
    MOV AH, 2
    MOV DL, ' '
    INT 21H
    
    POP BX
    
    INC BX
    ADD SI, 2
    
    JMP PRINT
    
    SEARCHING:
    
    CALL NEWLINE
    
    LEA DX, SEARCH_QUERY
    MOV AH, 9
    INT 21H
    
    CALL INPUT
    CMP AL, -1
    JE END_PROG
    
    CALL NEWLINE
    
    PUSH CX
    MOV AX, CX
    
    CALL OUTPUT
    
    POP CX
    
    CALL SEARCH 
    
    MOV AH, 9
    CMP CX, 0
    JE NOT_FOUND
    
    LEA DX, QUERY_SUCCESSFUL
    INT 21H
    
    MOV AX,CX
    CALL OUTPUT
    CALL NEWLINE
    
    JMP SEARCHING
    
    NOT_FOUND:
    
    LEA DX, QUERY_UNSUCCESSFUL
    INT 21H 
    JMP SEARCHING
    
    END_PROG:
    ;EXIT
    MOV AH, 4CH
    INT 21H
        
MAIN ENDP          

;SEARCH CX IN ARRAY         
SEARCH PROC
    XOR AX, AX
    MOV DX, N
    DEC DX
    
    BIN_SEARCH:
    
    CMP AX, DX
    JGE BREAK_LOOP
           
    MOV BX, AX
    ADD BX, DX
    
    AND BX, 0FFFEH
    
    LEA SI, ARR
    ADD SI, BX
    
    SHR BX, 1
    
    CMP [SI], CX
    JGE LOW
    
    MOV AX, BX
    INC AX
    
    JMP BIN_SEARCH
    
    LOW:
    
    MOV DX, BX
    
    JMP BIN_SEARCH

    BREAK_LOOP:
    
    SHL AX, 1
    LEA SI, ARR
    ADD SI, AX
    CMP [SI], CX
    JE FND
    
    XOR CX, CX
    RET
    
    FND:
    
    MOV CX, DX
    INC CX
    RET    
    
SEARCH ENDP


;SORTS ARR UPTO N
SORT PROC
    LEA SI, ARR
    MOV CX, N       
    
    OUTER_LOOP: 
    
    ADD SI, 2
    DEC CX
    JZ BREAK_OUTER_LOOP
         
    MOV BX, SI
    MOV AX, [SI]
    
    INNER_LOOP:
    
    SUB BX, 2
    CMP BX, OFFSET ARR
    JL BREAK_INNER_LOOP 
    CMP [BX], AX
    JNG BREAK_INNER_LOOP
    
    MOV DX, [BX]
    MOV [BX + 2], DX
    
    JMP INNER_LOOP

    BREAK_INNER_LOOP:
    
    MOV [BX + 2], AX
    JMP OUTER_LOOP

    BREAK_OUTER_LOOP:
    
    RET
    
SORT ENDP


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