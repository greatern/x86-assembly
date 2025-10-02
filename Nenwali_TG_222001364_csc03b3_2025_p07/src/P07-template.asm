;	Update all of this information to reflect your own details and the practical
;	Author:	TG Nenwali
;	P07 DLL starter file
.386
.MODEL FLAT, stdcall
.STACK 4096

.CODE

; LibMain function tests which action is currently beign performed
; The function returns if the DLL is loaded correctly or not.
; We avoid the complex logic here for simplicity.
LibMain proc instance:DWORD, reason:DWORD, unused:DWORD
	mov eax, 1
  ret
LibMain ENDP

aliquotSum PROC NEAR32
	; TODO
    push ebp
    mov  ebp, esp
    push ebx
    push ecx
    push edx

    sub  esp, 4           ; local slot [ebp-4] for sum

    mov  eax, [ebp + 8]   ; variable n
    mov  ebx, eax
    mov  ecx, 1           ; counter for devisor
    mov  dword ptr [ebp-4], 0   ; for the sum (store in local, not a register)

    cmp  eax, 1
    jle  aliquot_end

aliquot_loop:
    cmp  ecx, ebx         ; compare devisor counter with n
    jge  aliquot_end

    mov  eax, ebx         ; n in eax for division
    cdq
    div  ecx              ; remainder in EDX
    cmp  edx, 0           ; check remainder
    jne  aliquot_next     ; if remainder is not 0, then not a divisor

    ; add ecx to sum saved at [ebp-4]
    mov  eax, dword ptr [ebp-4]
    add  eax, ecx
    mov  dword ptr [ebp-4], eax

aliquot_next:
    inc  ecx              ; incerement to next devisor
    jmp  aliquot_loop

aliquot_end:
    mov  eax, dword ptr [ebp-4]   ; return sum in EAX

    add  esp, 4           ; free local
    pop  edx
    pop  ecx
    pop  ebx
    pop  ebp
    ret 4
aliquotSum ENDP

classify PROC NEAR32
	; TODO
push ebp
    mov  ebp, esp
    push ebx
    push ecx
    push edx
    pushfd

    xor  eax, eax
    mov  eax, [ebp+8]     ; n parameter

    push eax              ; push param for aliquotSum (stdcall callee will ret 4)
    call aliquotSum       ; aliquotSum returns sum in EAX
    ; DO NOT add esp,4 here because aliquotSum is stdcall (ret 4)

    mov  ebx, eax         ; ebx = sum
    mov  eax, [ebp+8]     ; eax = n

    cmp  ebx, eax         ; compare sum with n
    jl   sums
    je   sumnauhgt
    jmp  classifymost

sums:
    mov  eax, -1
    jmp  classify_end

sumnauhgt:
    mov  eax, 0
    jmp  classify_end

classifymost:
    mov  eax, 1

classify_end:
    ; clean up
    popfd
    pop  edx
    pop  ecx
    pop  ebx
    pop  ebp
    ret 4

classify ENDP

classify_array PROC NEAR32
    push ebp
    mov  ebp, esp
    push ebx
    push ecx
    push edx

    sub  esp, 4              ; local slot [ebp-4] for length

    mov  ebx, [ebp+8]        ; numbers array pointer 
    mov  ecx, [ebp+12]       ; classes array pointer
    mov  eax, [ebp+16]       ; length
    mov  dword ptr [ebp-4], eax  ; save length to local
    xor  edx, edx            ; counter initialisation

    ; checking valid parameters
    cmp  ebx, 0
    je   array_end
    cmp  ecx, 0
    je   array_end
    cmp  dword ptr [ebp-4], 0
    jle  array_end

array_loop:
    cmp  edx, dword ptr [ebp-4]
    jge  array_end

    ; getting i using ebx
    mov  eax, [ebx + edx*4]

    ; call classify
    push eax
    call classify           ; returns result in eax
    ; classify is stdcall (ret 4), so caller should NOT clean up

    ; store the result
    mov  [ecx + edx*4], eax

    inc  edx                ; increment counter
    jmp  array_loop

array_end:
    mov  eax, edx           ; return count processed

    add  esp, 4             ; free local
    pop  edx
    pop  ecx
    pop  ebx
    pop  ebp
    ret 12
	
classify_array ENDP
end LibMain
