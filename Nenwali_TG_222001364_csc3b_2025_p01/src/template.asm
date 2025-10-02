;	Update all of this information to reflect your own details and the prac
;	Author:     TG nenwali
;	p01

.386
.MODEL FLAT
.STACK 4096
INCLUDE io.inc

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD


; The data section stores all global variables
.DATA
    promptAmount BYTE "input required amount...", 0
    promptTime BYTE "enter the craft time in seconds...", 0
    promptOutput BYTE "input output per craft...", 0
    outputTxt BYTE "The number of production lines needed is...", 0
    
	; empty global variables 
    requiredAmount DWORD ?
    recipeCraftTime DWORD ?
    recipeOutput DWORD ?

; The code section may contain multiple tags such as _start, which is the entry
; point of this assembly program
.CODE
_start:
	; Most of your initial code will be under the _start tag.
	; The _start tag is just a memory address referenced by the Public indicator
	; highlighting which functions are available to calling functions.
	; _start gets called by the operating system to start this process.

    ; Get inputs from user 
    INVOKE OutputStr, ADDR promptAmount
    INVOKE InputInt
    MOV requiredAmount, eax
    
    INVOKE OutputStr, ADDR promptOutput
    INVOKE InputInt
    MOV recipeOutput, eax
    
    INVOKE OutputStr, ADDR promptTime
    INVOKE InputInt
    MOV recipeCraftTime, eax
    
    ; Calculate 60/craftTime
    MOV eax, 60
    XOR edx, edx        ; Clearing the register EDX
    DIV recipeCraftTime 
    
    ; Multiply by output
    MUL recipeOutput    ; (60/time)*output
    MOV ebx, eax        ; Storign  our divisor
    
   
    MOV eax, requiredAmount
    XOR edx, edx
    DIV ebx             ; EAX = result
    
    ; Outputs result to the user 
    INVOKE OutputStr, ADDR outputTxt
    INVOKE OutputInt, eax
    
    ; We call the Operating System ExitProcess system call to close the process.
	INVOKE ExitProcess, 0

PUBLIC _start
END
