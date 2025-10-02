; Author: TG Nenwali 222001364
;  P05 solutio

.386
.MODEL FLAT                
.STACK 4096              

include io.inc             

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

; Procedures 
inputArray PROTO NEAR32 stdcall arrayPtr:PTR DWORD, arraySize:DWORD
display    PROTO NEAR32 stdcall arrayPtr:PTR DWORD, arraySize:DWORD
totalCost  PROTO NEAR32 stdcall resourcesPtr:PTR DWORD, costsPtr:PTR DWORD, arraySize:DWORD

.DATA
; prompts for string inputs 
strWelcome      BYTE "This is a Costing Calculator!", 10, 0
strBye          BYTE "Shutting down cost analysis systems!", 10, 0
strLoop         BYTE "would you like to do another calculation (Type 0 for NO or 1 for YES): ", 0
strInvalid      BYTE "wrong option", 10, 0
strResources    BYTE "input 5 resource amounts: ", 0
strCosts        BYTE "input 5 cost amounts: ", 0
strResOut       BYTE "Resources: ", 0
strCostOut      BYTE "Costs: ", 0
strTotal        BYTE "Total Cost: ", 0
strSpace        BYTE " ", 0
strNL           BYTE 10, 0

; Global variables
resources       DWORD 5 DUP (?) ;resource amounts
costs           DWORD 5 DUP (?) ; cost amounts
continueFlag    DWORD ?         ;loop continuation

.CODE
_start:

    INVOKE OutputStr, ADDR strWelcome

progStart:
    ; Input resources
    INVOKE OutputStr, ADDR strResources
    INVOKE inputArray, ADDR resources, 5

    ; Input costs
    INVOKE OutputStr, ADDR strCosts
    INVOKE inputArray, ADDR costs, 5

    ; Displayign resources
    INVOKE OutputStr, ADDR strResOut
    INVOKE display, ADDR resources, 5
    INVOKE OutputStr, ADDR strNL

    ; displaying costs
    INVOKE OutputStr, ADDR strCostOut
    INVOKE display, ADDR costs, 5
    INVOKE OutputStr, ADDR strNL

    ; Calculating and display total cost
    INVOKE OutputStr, ADDR strTotal
    INVOKE totalCost, ADDR resources, ADDR costs, 5
    INVOKE OutputInt, eax
    INVOKE OutputStr, ADDR strNL

progLoop:
    ; prompt if they wan tto go again
    INVOKE OutputStr, ADDR strLoop
    INVOKE InputInt
    mov continueFlag, eax
    cmp eax, 1
    je progStart
    cmp eax, 0
    je progExit
    INVOKE OutputStr, ADDR strInvalid
    jmp progLoop

progExit:
    INVOKE OutputStr, ADDR strBye
    INVOKE ExitProcess, 0


inputArray PROC NEAR32 stdcall arrayPtr:PTR DWORD, arraySize:DWORD
    push ebp
    mov ebp, esp
    sub esp, 8

    mov ebx, DWORD PTR [ebp + 8]
    mov ecx, DWORD PTR [ebp + 12]
    mov DWORD PTR [ebp - 4], 0

inputLoop:
    cmp DWORD PTR [ebp - 4], ecx
    jge inputDone

    push ebx
    push ecx
    INVOKE InputInt
    mov DWORD PTR [ebp - 8], eax
    pop ecx
    pop ebx
    mov eax, DWORD PTR [ebp - 8]
    mov DWORD PTR [ebx], eax
    add ebx, 4
    inc DWORD PTR [ebp - 4]
    jmp inputLoop

inputDone:
    mov esp, ebp
    pop ebp
    ret 8
inputArray ENDP


display PROC NEAR32 stdcall arrayPtr:PTR DWORD, arraySize:DWORD
    push ebp
    mov ebp, esp
    sub esp, 4

    mov ebx, DWORD PTR [ebp + 8]
    mov ecx, DWORD PTR [ebp + 12]
    mov DWORD PTR [ebp - 4], 0

displayLoop:
    cmp DWORD PTR [ebp - 4], ecx
    jge displayDone

    push ebx
    push ecx
    mov eax, DWORD PTR [ebx]
    INVOKE OutputInt, eax
    INVOKE OutputStr, ADDR strSpace
    pop ecx
    pop ebx
    add ebx, 4
    inc DWORD PTR [ebp - 4]
    jmp displayLoop

displayDone:
    mov esp, ebp
    pop ebp
    ret 8
display ENDP

totalCost PROC NEAR32 stdcall resourcesPtr:PTR DWORD, costsPtr:PTR DWORD, arraySize:DWORD
    push ebp
    mov ebp, esp
    sub esp, 8

    mov ebx, DWORD PTR [ebp + 8]
    mov edx, DWORD PTR [ebp + 12]
    mov ecx, DWORD PTR [ebp + 16]
    mov DWORD PTR [ebp - 4], 0
    mov DWORD PTR [ebp - 8], 0

totalLoop:
    cmp DWORD PTR [ebp - 4], ecx
    jge totalDone

    mov eax, DWORD PTR [ebx]
    imul eax, DWORD PTR [edx]
    add DWORD PTR [ebp - 8], eax
    add ebx, 4
    add edx, 4
    inc DWORD PTR [ebp - 4]
    jmp totalLoop

totalDone:
    mov eax, DWORD PTR [ebp - 8]
    mov esp, ebp
    pop ebp
    ret 12
totalCost ENDP

Public _start
END

