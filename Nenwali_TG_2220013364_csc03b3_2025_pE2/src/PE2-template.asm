;	Update all of this information to reflect your own details and the practical
;	Author:	TG Nenwali
;	Student Number: 222001364
;	PE2 DLL - countsubstring implementation
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

countsubstring PROC NEAR32
	; TODO
	push ebp
	mov ebp, esp
	sub esp, 4
	push ebx
	push ecx
	push edx
	
	mov eax, [ebp+8]
	mov ebx, [ebp+12]
	
	test eax, eax
	jz finish
	test ebx, ebx
	jz finish
	
	xor ecx, ecx
	mov [ebp-4], ecx
	
	mov ecx, ebx
	xor edx, edx
get_substr_len:
	cmp byte ptr [ecx], 0
	je got_len
	inc ecx
	inc edx
	jmp get_substr_len
	
got_len:
	test edx, edx
	jz finish
	
	mov ecx, eax
	
outer_loop:
	cmp byte ptr [ecx], 0
	je finish
	
	push ecx
	push edx
	xor eax, eax
	
compare_loop:
	mov dl, byte ptr [ebx+eax]
	test dl, dl
	jz found_match
	
	mov dh, byte ptr [ecx+eax]
	test dh, dh
	jz not_match
	
	cmp dl, dh
	jne not_match
	
	inc eax
	jmp compare_loop
	
found_match:
	pop edx
	pop ecx
	inc dword ptr [ebp-4]
	add ecx, edx
	jmp outer_loop
	
not_match:
	pop edx
	pop ecx
	inc ecx
	jmp outer_loop
	
finish:
	mov eax, [ebp-4]
	pop edx
	pop ecx
	pop ebx
	mov esp, ebp
	pop ebp
	ret 8
countsubstring ENDP

end LibMain