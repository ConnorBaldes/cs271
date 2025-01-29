TITLE HW3

;Connor Baldes
;CS271		2/26/2020
;Description: This program will first print out the authors name and 
; title of the program. Then the user will be prompted to enter their name
; and they will be greated by the program. Then the user will be asked to input
; if they want to perform floating point or integer addition and then will be prompted 
; to enter five numbers that will be summed and averaged and the results of those 
; two operations will be displayed. The user will then be asked if they want to go again.

INCLUDE Irvine32.inc

.386
.stack 4096 ;SS
ExitProcess proto,dwExitCode:dword

.data

welcome	BYTE		"Assignment 3 Connor Baldes", 0	;welcome statement
name_prompt	BYTE		"Hello please enter your name: ", 0	;ask user for name
greeting		BYTE		"Hello, ",0	;prints user greeting
greeting_2	BYTE		" in this program you will give 5 numbers that will be summed and averaged.", 0
instruction_1		BYTE		"Please enter 5 numbers to be summed and averaged.", 0
user_name		BYTE	15 DUP(0)	;variable to hold users name
user_name_length	DWORD	?

addition_prompt	BYTE		"Please enter 1 if you would like to perform floating point additon, or", 0
addition_prompt_2	BYTE		"0 if you want to perform integer addition: ",0
in_float			BYTE		"In floating point addition", 0	;variables used to test just statement
in_integer		BYTE		"In integer addition",0
get_number			BYTE		"Number: ", 0	;prompt for user to enter numbers
user_sum			BYTE		"The sum of your numbers is: ", 0
user_average		BYTE		"The average of your numbers is: ",0
five				REAL4		5.0	;for average calculation 
float_conversion	DWORD	?
prompt_goodbye		BYTE		"Goodbye!",0
;stack_count		Real4	0
go_again_prompt	BYTE		"If you would like to go again enter 1, if not enter 0: ", 0
	




.code

get_eip PROC 
	mov eax, [esp]
     ret
get_eip ENDP


main PROC


; welcome statement

Introduction:
	call CrLf
	mov edx, OFFSET welcome
	call WriteString
	call CrLf

; ask user for name

get_name:
	mov edx, OFFSET name_prompt
	call WriteString
	mov edx, OFFSET user_name
	mov ecx, 15
	call ReadString			;getting users name
	mov user_name_length, eax
	call Crlf

; greet user

greet_user:
	mov edx, OFFSET greeting	
	call WriteString
	mov edx, OFFSET user_name
	call WriteString
	mov edx, OFFSET greeting_2
	call WriteString
	call CrLf

; Ask user if they want to perform floating point or integer addition

get_addition:
	mov edx, OFFSET addition_prompt
	call WriteString
	call Crlf
	mov edx, OFFSET addition_prompt_2
	call WriteString
	mov ecx, 2
	call ReadInt
	cmp eax, 1
	JE float		;if the user entered 1 they will be jumped to the floating
				; point calcualor otherwise will continue to integer calculator
integer:

mov ecx, 5		;set to loop five times


integer_addition:	; loop to get integers
	mov edx, OFFSET get_number
	call WriteString
	call ReadInt
	push eax
	loop integer_addition


; calculate integer sum and average

	mov eax, 0

	pop ebx			
	add eax, ebx
	pop ebx
	add eax, ebx
	pop ebx				;popping values of of stack and adding them to the sum 
	add eax, ebx			; stored in eax
	pop ebx
	add eax, ebx
	pop ebx
	add eax, ebx

	;sum
	mov edx, OFFSET user_sum
	call WriteString
	call WriteDec			;WriteDec prints value in eax which is where sum is stored
	call Crlf
	
	;average
	FINIT				; initiate floating point unit to calculate average
	mov edx, OFFSET user_average
	call WriteString
	mov float_conversion, eax
	FLD five				; add 5.0 to stach
	FILD float_conversion	;convert int to float so it can be average
	FDIVR				; divide sum by 5.0 and return anser to stack
	call WriteFloat		; print first item in stack= average
	call Crlf
	jmp go_again			;jump to ask user to go again

	

float:

	mov ecx, 4			;set to loop for times
	FINIT

	mov edx, OFFSET get_number
	call WriteString
	call ReadFloat			;ask for first numbmer in stack

float_addition:
	
	FLD st(0)				;push firt number back one spot in stack
	mov edx, OFFSET get_number		
	call WriteString
	call ReadFloat			;user enters float that is added to first spot in stack
	FADD					;first two spots in stack added anser put in stack spot 1
	loop float_addition


	
sum_float:

	mov edx, OFFSET user_sum
	call WriteString

	call WriteFloat		; numbers already summed in first stack position
	call Crlf				; writefloat prints first position= sum

	;average
	mov edx, OFFSET user_average
	call WriteString
	FLD five				; 5.o added to stack
	FDIV					; divided sum and 5.0 answer pushed to top of stack
	call WriteFloat
	call Crlf
	jmp go_again			



go_again:
	call crlf
	mov edx, OFFSET go_again_prompt
	call WriteString
	mov ecx, 2
	call ReadInt
	cmp eax, 1
	JE get_addition

goodbye_message:

	call crlf
	mov edx, OFFSET prompt_goodbye
	call WriteString
	call crlf


exit	;exit to operating system

main ENDP

END main