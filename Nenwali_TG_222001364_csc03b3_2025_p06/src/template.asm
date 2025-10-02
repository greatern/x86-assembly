; Author: Nenwali TG
; Student Number: 222001364
; Prac 06

.386
.MODEL FLAT
.STACK 4096

INCLUDE io.inc

; Exit function
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.DATA
; String prompts 
strInput        BYTE "Enter an integer number from 0-100: ", 0
strResult       BYTE "shaw(", 0
strResultEnd    BYTE ") = ", 0
strContinue     BYTE "Do you want to test another value? (enter 0 = No,or  1 = Yes): ", 0
strNewline      BYTE 10, 0

.CODE

;recursive function
_shaw PROC NEAR32

;save registers and pointers
    PUSH ebp           
    MOV ebp, esp        
    PUSH ebx            
    PUSH ecx
    PUSH edx
    PUSHFD              
    
    ; Variables

    MOV eax, [ebp+8]    ; eax = n
    
    ; initial base case: n <= 0
    CMP eax, 0
    JLE shaw_base_case
    
    ; second case: 0 < n <= 5
    CMP eax, 5
    JLE shaw_shift_case
    
    ; Recursive case: n >= 6
    
    ; initial recursive case shaw(n >> 3)
    MOV ebx, eax        ; ebx = n
    SHR ebx, 3          ; divide by 8
    PUSH ebx            
    CALL _shaw         
    MOV ecx, eax        ; store first result in ecx
    
    ;shaw(n - 3)
    MOV ebx, [ebp+8]   
    SUB ebx, 3          ; ebx = n - 3
    PUSH ebx           
    CALL _shaw         
    
    ADD eax, ecx        ; Add the two results
    JMP shaw_end
    
shaw_base_case:
    ; n <= 0, return 1
    MOV eax, 1
    JMP shaw_end
    
shaw_shift_case:
    MOV eax, [ebp+8]   
    SHL eax, 1          ; multiply by 2
    JMP shaw_end
    
shaw_end:
 ; restore
    POPFD               
    POP edx             
    POP ecx
    POP ebx
    MOV esp, ebp        
    POP ebp             
    RET 4               ; return and clear parameter
_shaw ENDP

; Main program
_start:
    ;stack frame
    PUSH ebp           
    MOV ebp, esp      
    SUB esp, 8          ; space for local variables
    
    ; Local variables:
    ; [ebp - 4] - user input n
    ; [ebp - 8] - continue flag
    
program_loop:
    ; capture input
    INVOKE OutputStr, ADDR strInput  
    INVOKE InputInt
    MOV [ebp-4], eax    
    
   ; input validation
    CMP eax, 0             
    JL input_valid
    CMP eax, 100        
    JG input_valid
    
input_valid:
    ; Call shaw function
    PUSH DWORD PTR [ebp-4]  ; push n as parameter
    CALL _shaw              
    MOV ebx, eax           
    
    ; Display 
    INVOKE OutputStr, ADDR strResult
    INVOKE OutputInt, [ebp-4]   
    INVOKE OutputStr, ADDR strResultEnd
    INVOKE OutputInt, ebx
    INVOKE OutputStr, ADDR strNewline
    
    ; prompt user if tehy want to  continue
continue_prompt:
    INVOKE OutputStr, ADDR strContinue
    INVOKE InputInt
    MOV [ebp-8], eax    ; 
    
    CMP eax, 1
    JE program_loop    
    CMP eax, 0
    JE program_exit
    JMP continue_prompt 
    
program_exit:
    ; Restore stack frame
    MOV esp, ebp        
    POP ebp
    
    ; Exit program
    INVOKE ExitProcess, 0

Public _start
END
