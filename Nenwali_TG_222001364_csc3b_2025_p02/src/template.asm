;	Update all of this information to reflect your own details and the prac
;	Author:     TG nenwali
;	p02
.386
.model flat, stdcall
option casemap :none

; IO library 
INCLUDE io.inc
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.STACK 4096

.DATA
    ; Input variables
    requiredAmount    DWORD ?
    outputPerMinute   DWORD ?
    
    ; Calculated values
    productionLines   DWORD ?
    totalOutput       DWORD ?
    excessProduction  DWORD ?
    
    ; String messages
    promptRequired    BYTE "Enter required production amount: ", 0
    promptOutputRate  BYTE "Enter output per production line (per minute): ", 0
    msgLinesNeeded    BYTE "Number of production lines needed: ", 0
    msgExpectedOutput BYTE "Expected total output: ", 0
    msgPerfectMatch   BYTE "Production lines perfectly match required amount!", 13, 10, 0
    msgOverProduction BYTE "Over-production will occur. Excess amount: ", 0
    promptContinue    BYTE "Calculate another? (1=Yes, 0=No): ", 0
    errorZeroOutput   BYTE "Error: Output per minute cannot be zero!", 13, 10, 0

.CODE
_start:
    ; Main program loop
    productionLoop:
        ;Get required amount 
        INVOKE OutputStr, ADDR promptRequired
        INVOKE InputInt
        MOV requiredAmount, eax
        
        ; Get output per minute
        getOutputRate:
            INVOKE OutputStr, ADDR promptOutputRate
            INVOKE InputInt
            MOV outputPerMinute, eax
            
            ; Validate output rate is not zero
            CMP eax, 0
            JNE outputValid
            INVOKE OutputStr, ADDR errorZeroOutput
            JMP getOutputRate
        outputValid:
        
        ;Calculate production lines
        MOV eax, requiredAmount
        CDQ                     ; Sign extend for division
        IDIV outputPerMinute    ; signed division
        CMP edx, 0              ; Check remainder
        JE noRoundUp
        INC eax                 ; 
        noRoundUp:
        MOV productionLines, eax
        
        ; expected output
        IMUL eax, outputPerMinute
        MOV totalOutput, eax
        
        ;Display results
        INVOKE OutputStr, ADDR msgLinesNeeded
        INVOKE OutputInt, productionLines
        INVOKE OutputStr, ADDR msgExpectedOutput
        INVOKE OutputInt, totalOutput
        
        ;perfect match or over-production
        MOV eax, totalOutput
        CMP eax, requiredAmount
        JNE overProduction
        
        ; Perfect match case
        INVOKE OutputStr, ADDR msgPerfectMatch
        JMP askContinue
        
        overProduction:
        ; Calculate and display over-production
        SUB eax, requiredAmount
        MOV excessProduction, eax
        INVOKE OutputStr, ADDR msgOverProduction
        INVOKE OutputInt, excessProduction
        
        askContinue:
        ;  Ask to continue
        INVOKE OutputStr, ADDR promptContinue
        INVOKE InputInt
        CMP eax, 1
        JE productionLoop
    
    ; Exit program
    INVOKE ExitProcess, 0

PUBLIC _start
END