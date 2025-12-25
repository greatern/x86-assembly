;	Author:	TG Nenwali
;	Student Number: 222001364
;	PE1 DLL - Histogram and Proportion Functions


.386
.MODEL FLAT, stdcall
.STACK 4096

.CODE

; LibMain function tests which action is currently being performed
; The function returns if the DLL is loaded correctly or not.
; We avoid the complex logic here for simplicity.
LibMain proc instance:DWORD, reason:DWORD, unused:DWORD
	mov eax, 1
	ret
LibMain ENDP


histogram PROC NEAR32
	push ebp
	mov ebp, esp
	push ebx                    
	push ecx
	push edx
	

	mov eax, [ebp+16]           
	mov ecx, 16                  

init_bins:
	mov DWORD PTR [eax], 0      
	add eax, 4                   
	dec ecx
	jnz init_bins               
	
	; Now process the energy array
	mov ebx, [ebp+8]          
	mov ecx, [ebp+12]           
	
	; Check if array is empty
	cmp ecx, 0
	je done_histogram
	
count_loop:
	; Get the current energy value
	mov edx, [ebx]              
	
	mov eax, [ebp+16]           
	shl edx, 2                   
	add eax, edx                
	
	; Increment the bin count
	inc DWORD PTR [eax]
	
	; Move to next energy value
	add ebx, 4                
	dec ecx                    
	jnz count_loop              
	
done_histogram:
	pop edx                      
	pop ecx
	pop ebx
	pop ebp
	ret 12                       
histogram ENDP


proportion PROC NEAR32
	push ebp
	mov ebp, esp
	push ebx                     
	push ecx
	push edx
	
	; First, calculate the total sum of all bins
	mov ebx, [ebp+8]            
	mov ecx, 16                 
	xor eax, eax                 
	
sum_loop:
	add eax, [ebx]              
	add ebx, 4            
	dec ecx
	jnz sum_loop
	

	cmp eax, 0
	je handle_zero_total
	
	; Save total 
	push eax                     
	
	
	xor ecx, ecx                 
	
calc_loop:

	mov eax, ecx                 
	shl eax, 2                  
	mov ebx, [ebp+8]            
	add ebx, eax                
	
	; Get bin value and calculate percentage
	mov eax, [ebx]              
	imul eax, 100               
	
	cdq                          
	mov ebx, [esp]              
	idiv ebx
	

	mov ebx, ecx                 
	shl ebx, 2                  
	mov edx, [ebp+12]           
	add edx, ebx                
	mov [edx], eax            
	
	; Move to next element
	inc ecx
	cmp ecx, 16
	jl calc_loop
	
	pop eax                     
	jmp done_proportion
	
handle_zero_total:
	; If total is 0, set all ratios to 0
	mov ebx, [ebp+12]           
	mov ecx, 16
	
zero_loop:
	mov DWORD PTR [ebx], 0
	add ebx, 4
	dec ecx
	jnz zero_loop
	
done_proportion:
	pop edx                 
	pop ecx
	pop ebx
	pop ebp
	ret 8                        
proportion ENDP

end LibMain