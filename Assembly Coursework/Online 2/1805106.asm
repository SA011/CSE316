.MODEL SMALL 
.STACK 400H 
.DATA

CR EQU 0DH
LF EQU 0AH

INPUT_PROMPT DB 'ENTER A CO-ORDINATE: ', CR, LF, '$'
                                        
FQUAD DB 'THE CO-ORDINATE IS IN FIRST QUADRANT. $'
SQUAD DB 'THE CO-ORDINATE IS IN SECOND QUADRANT. $'
TQUAD DB 'THE CO-ORDINATE IS IN THIRD QUADRANT. $'
LQUAD DB 'THE CO-ORDINATE IS IN FOURTH QUADRANT. $'

XAXIS DB 'THE CO-ORDINATE IS IN X AXIS. $'
YAXIS DB 'THE CO-ORDINATE IS IN Y AXIS. $'

ORG DB 'THE CO-ORDINATE IS ORIGIN. $'

ENDL DB CR, LF, '$'

X DB ?
Y DB ?

.CODE 
MAIN PROC 
    MOV AX, @DATA
    MOV DS, AX  
                 
    ;INPUT PROMPT
    LEA DX, INPUT_PROMPT
    MOV AH, 9
    INT 21H 
       
    ;TAKE X
    MOV AH, 1
    INT 21H    
    CMP AL, '0'
    JE POS1
        
    ;NEG
    INT 21H
    AND AL, 0FH
    MOV X, AL
    NEG X
    JMP CONT1 
       
    POS1: 
    
    ;POS
    INT 21H
    AND AL, 0FH
    MOV X, AL 
       
    CONT1: 
    ;IGNORE SPACE 
    INT 21H  
      
    ;TAKE Y
    INT 21H    
    CMP AL, '0'
    JE POS2
    
    ;NEG
    INT 21H
    AND AL, 0FH
    MOV Y, AL
    NEG Y
    JMP CONT2 
       
    POS2:
    
    ;POS
    INT 21H
    AND AL, 0FH
    MOV Y, AL 
       
    CONT2:
    ;ENDL 
    LEA DX, ENDL
    MOV AH, 9
    INT 21H
    
    ;X Y TAKEN    
    CMP X, 0
    JG XGREATER
    JE XEQUAL 
       
    ;XSMALLER
    CMP Y, 0
    JG YGREATER1
    JE YEQUAL1           
    
    ;YSMALLER, 3rd Quadrant
    LEA DX, TQUAD
    JMP END_IF 
       
    YEQUAL1:
    
    ;ON X AXIS
    LEA DX, XAXIS
    JMP END_IF 
       
    YGREATER1: 
    
    ;2ND QUADRANT
    LEA DX, SQUAD
    JMP END_IF
    
    
        
    XEQUAL:      
    CMP Y, 0
    JE ORIGIN  
      
    ;ON Y AXIS   
    LEA DX, YAXIS
    JMP END_IF  
    
      
    ORIGIN:
    LEA DX, ORG 
    JMP END_IF 
           
           
    XGREATER:
    
    CMP Y, 0
    JG YGREATER2
    JE YEQUAL2
        
    ;4TH QUAD
    LEA DX, LQUAD
    JMP END_IF
        
    YEQUAL2:   
    
    ;XAXIS
    LEA DX, XAXIS
    JMP END_IF 
       
    YGREATER2:
    
    ;1ST QUAD
    LEA DX, FQUAD
        
    END_IF:    
    INT 21H  
    
	; interrupt to exit
    MOV AH, 4CH
    INT 21H  
MAIN ENDP 
END MAIN 