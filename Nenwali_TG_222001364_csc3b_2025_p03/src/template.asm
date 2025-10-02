;	Author:     TG Nenwali
;	p03
.386
.model flat, stdcall
option casemap :none

ExitProcess PROTO, dwExitCode:DWORD

.STACK 4096

.DATA
    ; Global variables 
    requiredAmount DWORD ?
    outputPerMin DWORD ?
    inputPerMin DWORD ?
    
    ; String messages 
    promptAmount BYTE "Enter required amount of products: ", 0
    promptOutput BYTE "Enter products output per minute: ", 0
    promptInput BYTE "Enter required input per minute: ", 0
    resultHeader BYTE "Calculation Results:", 13, 10, 0
    resultAmount BYTE "Required amount: ", 0
    resultOutput BYTE "Output per minute: ", 0
    resultInput BYTE "Input per minute: ", 0
    resultLines BYTE "Number of whole lines needed: ", 0
    resultTotalInput BYTE "Total input required: ", 0
    promptContinue BYTE "Process another product? (1=Yes, 0=No): ", 0
    newline BYTE 13, 10, 0
    
    ; Input buffer
    inputBuffer BYTE 16 DUP(0)
    bytesRead DWORD ?

.CODE
start:
    ; Main program loop
    START_LOOP:
        ; Get requiredAmount
        mov eax, 4                  ; 
        mov ebx, 1                  ; stdout
        mov ecx, OFFSET promptAmount
        mov edx, LENGTHOF promptAmount
        int 80h
        
        ; Read input for requiredAmount
        mov eax, 3                  ;
        mov ebx, 0                  ; stdin
        mov ecx, OFFSET inputBuffer
        mov edx, 16
        int 80h
        mov bytesRead, eax
        
        ; Converting ASCII to integer
        mov esi, OFFSET inputBuffer
        xor eax, eax
        xor ecx, ecx
    CONVERT_LOOP1:
        mov cl, [esi]
        cmp cl, '0'
        jb CONVERT_DONE1
        cmp cl, '9'
        ja CONVERT_DONE1
        sub cl, '0'
        imul eax, 10
        add eax, ecx
        inc esi
        jmp CONVERT_LOOP1
    CONVERT_DONE1:
        mov requiredAmount, eax
        
        ; Get outputPerMin
        mov eax, 4
        mov ebx, 1
        mov ecx, OFFSET promptOutput
        mov edx, LENGTHOF promptOutput
        int 80h
        
        ; Read input for outputPerMin
        mov eax, 3
        mov ebx, 0
        mov ecx, OFFSET inputBuffer
        mov edx, 16
        int 80h
        mov bytesRead, eax
        
        ; Convert ASCII to integer
        mov esi, OFFSET inputBuffer
        xor eax, eax
        xor ecx, ecx
    CONVERT_LOOP2:
        mov cl, [esi]
        cmp cl, '0'
        jb CONVERT_DONE2
        cmp cl, '9'
        ja CONVERT_DONE2
        sub cl, '0'
        imul eax, 10
        add eax, ecx
        inc esi
        jmp CONVERT_LOOP2
    CONVERT_DONE2:
        mov outputPerMin, eax
        
        ; Get inputPerMin
        mov eax, 4
        mov ebx, 1
        mov ecx, OFFSET promptInput
        mov edx, LENGTHOF promptInput
        int 80h
        
        ; Read input for inputPerMin
        mov eax, 3
        mov ebx, 0
        mov ecx, OFFSET inputBuffer
        mov edx, 16
        int 80h
        mov bytesRead, eax
        
        ; Convert ASCII to integer
        mov esi, OFFSET inputBuffer
        xor eax, eax
        xor ecx, ecx
    CONVERT_LOOP3:
        mov cl, [esi]
        cmp cl, '0'
        jb CONVERT_DONE3
        cmp cl, '9'
        ja CONVERT_DONE3
        sub cl, '0'
        imul eax, 10
        add eax, ecx
        inc esi
        jmp CONVERT_LOOP3
    CONVERT_DONE3:
        mov inputPerMin, eax
        
        ; Calculating number of lines (requiredAmount / outputPerMin)
        mov eax, requiredAmount
        cdq                     
        idiv outputPerMin       ; Dividing by outputPerMin
        
        ; Round up if remainder exists
        cmp edx, 0
        jz NO_REMAINDER
        inc eax                 ; Rounding up
    NO_REMAINDER:
        mov ebx, eax            ; Storih numberOfWholeLines
        
        ; Calculating the  requiredInput
        imul eax, inputPerMin   ; putr esult in EAX
        
        ; Displaying the results
        mov eax, 4
        mov ebx, 1
        mov ecx, OFFSET resultHeader
        mov edx, LENGTHOF resultHeader
        int 80h
        
        ; Displaying the resultAmount
        mov eax, 4
        mov ebx, 1
        mov ecx, OFFSET resultAmount
        mov edx, LENGTHOF resultAmount
        int 80h
        
        ; Displaying the requiredAmount value
        mov esi, OFFSET inputBuffer + 15
        mov byte ptr [esi], 0   ; Null terminate
        mov eax, requiredAmount
        mov ecx, 10
    CONVERT_TO_ASCII1:
        dec esi
        xor edx, edx
        div ecx
        add dl, '0'
        mov [esi], dl
        test eax, eax
        jnz CONVERT_TO_ASCII1
        
        mov eax, 4
        mov ebx, 1
        mov ecx, esi
        mov edx, OFFSET inputBuffer + 16
        sub edx, ecx
        int 80h
        
        ; Displaying newline
        mov eax, 4
        mov ebx, 1
        mov ecx, OFFSET newline
        mov edx, LENGTHOF newline
        int 80h
        
        ; Displayign thee resultOutput
        mov eax, 4
        mov ebx, 1
        mov ecx, OFFSET resultOutput
        mov edx, LENGTHOF resultOutput
        int 80h
        
        ; Displaying the outputPerMin value
        mov esi, OFFSET inputBuffer + 15
        mov byte ptr [esi], 0
        mov eax, outputPerMin
        mov ecx, 10
    CONVERT_TO_ASCII2:
        dec esi
        xor edx, edx
        div ecx
        add dl, '0'
        mov [esi], dl
        test eax, eax
        jnz CONVERT_TO_ASCII2
        
        mov eax, 4
        mov ebx, 1
        mov ecx, esi
        mov edx, OFFSET inputBuffer + 16
        sub edx, ecx
        int 80h
        
        ; Displaying newline
        mov eax, 4
        mov ebx, 1
        mov ecx, OFFSET newline
        mov edx, LENGTHOF newline
        int 80h
        
        ; Displaying resultInput
        mov eax, 4
        mov ebx, 1
        mov ecx, OFFSET resultInput
        mov edx, LENGTHOF resultInput
        int 80h
        
        ; Displaying the inputPerMin value
        mov esi, OFFSET inputBuffer + 15
        mov byte ptr [esi], 0
        mov eax, inputPerMin
        mov ecx, 10
    CONVERT_TO_ASCII3:
        dec esi
        xor edx, edx
        div ecx
        add dl, '0'
        mov [esi], dl
        test eax, eax
        jnz CONVERT_TO_ASCII3
        
        mov eax, 4
        mov ebx, 1
        mov ecx, esi
        mov edx, OFFSET inputBuffer + 16
        sub edx, ecx
        int 80h
        
        ; Displaying newline
        mov eax, 4
        mov ebx, 1
        mov ecx, OFFSET newline
        mov edx, LENGTHOF newline
        int 80h
        
        ; Displaying resultLines
        mov eax, 4
        mov ebx, 1
        mov ecx, OFFSET resultLines
        mov edx, LENGTHOF resultLines
        int 80h
        
        ; Displayin the  numberOfWholeLines
        mov esi, OFFSET inputBuffer + 15
        mov byte ptr [esi], 0
        mov eax, ebx
        mov ecx, 10
    CONVERT_TO_ASCII4:
        dec esi
        xor edx, edx
        div ecx
        add dl, '0'
        mov [esi], dl
        test eax, eax
        jnz CONVERT_TO_ASCII4
        
        mov eax, 4
        mov ebx, 1
        mov ecx, esi
        mov edx, OFFSET inputBuffer + 16
        sub edx, ecx
        int 80h
        
        ; Displaying the newline
        mov eax, 4
        mov ebx, 1
        mov ecx, OFFSET newline
        mov edx, LENGTHOF newline
        int 80h
        
        ; Displaying the  resultTotalInput
        mov eax, 4
        mov ebx, 1
        mov ecx, OFFSET resultTotalInput
        mov edx, LENGTHOF resultTotalInput
        int 80h
        
        ; Displaying te requiredInput
        mov esi, OFFSET inputBuffer + 15
        mov byte ptr [esi], 0
        mov ecx, 10
    CONVERT_TO_ASCII5:
        dec esi
        xor edx, edx
        div ecx
        add dl, '0'
        mov [esi], dl
        test eax, eax
        jnz CONVERT_TO_ASCII5
        
        mov eax, 4
        mov ebx, 1
        mov ecx, esi
        mov edx, OFFSET inputBuffer + 16
        sub edx, ecx
        int 80h
        
        ; Display the newline
        mov eax, 4
        mov ebx, 1
        mov ecx, OFFSET newline
        mov edx, LENGTHOF newline
        int 80h
        
        ; Ask if user wants to continue
        mov eax, 4
        mov ebx, 1
        mov ecx, OFFSET promptContinue
        mov edx, LENGTHOF promptContinue
        int 80h
        
        ; selct continue choice
        mov eax, 3
        mov ebx, 0
        mov ecx, OFFSET inputBuffer
        mov edx, 16
        int 80h
        mov bytesRead, eax
        
        ; Checking if the user wants to continue
        mov al, [inputBuffer]
        cmp al, '1'
        je START_LOOP           ; Repeat if  1 was entered
    
    ; Exit program
    INVOKE ExitProcess, 0

PUBLIC start
END