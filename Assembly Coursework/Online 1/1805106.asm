.MODEL SMALL

.STACK 100H

.DATA
LF EQU 0AH
CR EQU 0DH
 
INPUT DB 'ENTER A CAPITAL LETTER: $'
OUTPUT DB 'ENCRYPTED SMALL LETTER FOR $'
OUTPUT2 DB ' IS: $'

X DB ?
Y DB ?
.CODE

MAIN PROC
    ; DATA SEGMENT INITIALIZATION
    MOV AX, @DATA
    MOV DS, AX
               
    ; INPUT PROMPT
    LEA DX, INPUT
    MOV AH, 9
    INT 21H
    
    ;TAKE INPUT
    MOV AH, 1
    INT 21H
    MOV X, AL
    MOV Y, AL
    
    ;NEW LINE
    MOV DL, LF
    MOV AH, 2
    INT 21H
    MOV DL, CR
    INT 21H
    
    ;SUB 65
    SUB X, 65
    
    ;XOR 1
    MOV DL, X
    AND DL, 1
    SUB X, DL
    XOR DL, 1
    ADD X, DL
    
    ;25-X
    MOV DL, 25
    SUB DL, X
    MOV X, DL
    
    ;ADD 97
    ADD X, 97
    
    
    ;OUTPUT PROMPT
    LEA DX, OUTPUT
    MOV AH, 9
    INT 21H
          
    MOV DL, Y
    MOV AH, 2
    INT 21H
    
    LEA DX, OUTPUT2
    MOV AH, 9
    INT 21H
    
    ;PRINT
    MOV DL, X
    MOV AH, 2
    INT 21H
       
    
    ;NEW LINE
    MOV DL, LF
    MOV AH, 2
    INT 21H
    MOV DL, CR
    INT 21H
    
    ;DOS EXIT
    MOV AH, 4CH
    INT 21H
    
MAIN ENDP
END MAIN