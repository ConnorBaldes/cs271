TITLE HW4

;Connor Baldes
;CS271		2/26/2020
;Description: This is the assignment 4 program for CS271.
; This program will take a given number by the user between 10-200
; which will be used for the size of an array that will be filled randomly
; with numbers between 100-999 these numbers will then be shown to the user in
; there random unsorted form in horizontal groups of 10. The program will then use
; a recursive merge sort algorythm to sort the random numbers in descending order.
; The program will also calculate the median and average_vale integers which will be displayed
; along with the sorted integers.


;***************CITATION*********************
;
;
;
; The merge sort algorythm I used, I learned from an online post, created by Albert Chang.
; He posted his algorythm and a walk through of how to implement the code  in MASM on github
; in 2016 (username: k-cal). The merge sort algorythm I use and how to implement it, I learned from his 
; post. Due to this some of the structure of my merge sort algorythm is similiar to his as I used 
; it to teach myself how merge sort can be implemented in MASM. Additionally I was having trouble with 
; finding the median value of the array and in his post Albert also showed how to calculate the median 
; value and I based how I did my median value calculation off of his design.
;
;
;
;
;***********************************************


INCLUDE Irvine32.inc

.386
.stack 4096 ;SS
ExitProcess proto,dwExitCode:dword

MIN = 10

MAX = 200

;LOW = 100 
                ;VS did not like these while building I dont know why
;HIGH = 999


L_index         EQU     DWORD PTR [ebp - 4]

R_index         EQU     DWORD PTR [ebp - 8]         ; these constants are used during the merge sort
                                                    ; procedure to give refrence to locations whem merge
T_index         EQU     DWORD PTR [ebp - 12]        ; sort splits the array into parts

distance        EQU     DWORD PTR [ebp - 16]

midpoint        EQU     DWORD PTR [ebp - 20]



;---------------------------MACROS-----------------------------------------------------


clear_screen	MACRO	;wrapper for irvinve clear screen procedure

	call clrscr		

ENDM

clear_line	MACRO	;wrapper for irvine clear line procedure

	call crlf

ENDM

read_integer	MACRO	variable	;wrapper for irvine read integer procedure

	call readint

	mov [variable], eax

ENDM

read_string	MACRO	string, string_length, string_size	;wrapper for irvine read string procedure

	mov edx, OFFSET string

	mov ecx, string_size

	call read_string

	mov string_length, eax

ENDM

write_int		MACRO	variable	;wrapper for irvine write integer procedure

	mov eax, variable

	call writeint

ENDM

write_dec		MACRO	variable	;wrapper for irvine write decimal procedure

	mov eax, variable

	call writedec

ENDM

write_string	MACRO	string	;'wrapper for irvine write string procedure

	mov edx, OFFSET string

	call writestring

ENDM

; when using read_float and write_float you must make sure that the fpu is initialized
; otherwise the macros will not work
read_float	MACRO	;wrapper for irvine read float procedure

	call readfloat

ENDM

write_float	MACRO	;wrapper for irvine write float procedure

	call writefloat

ENDM

;-----------------------------End of MACROS------------------------------------------




.data

intro_0	BYTE		"Connor Baldes ID: 933324282 CS271 Homework 4", 0

intro_1	BYTE		"In this program you will be asked to input a number which will be the size of an array that will be filled with random integers.", 0

intro_2	BYTE		"Those random integers will displayed to you then will be sorted in descending order and will be re-displayed along with the median and ", 0

intro_3	BYTE		"average_vale of those numbers.", 0

prompt_1	BYTE		"Array size: ", 0

lower_limit_size	DWORD	MIN

upper_limit_size	Dword	MAX

;test		BYTE		"test location", 0


array_size	DWORD	?	;number of elements in array determined by user input


array	DWORD	MAX	DUP(?)      ; array which will stored with random integers

temp_array	DWORD	MAX	DUP(?)      ; array used during merge sort to store temp values
                                    ; same size as orginal array

print_space	BYTE		"   ", 0    ; space to seperate numbers while printing

count		Dword	10      ; used to show when to go to new line while printing

unsorted_array	BYTE		"Unsorted Array: ", 0

sorted_array	BYTE		"Sorted Array: ", 0

median      BYTE    "Median: ",0

average     BYTE    "Average: ", 0

average_calc_1   DWORD   ?

average_calc_2  DWORD   ?

average_calc_3  DWORD   ?

average_calc_4  DWORD	?

average_value     DWORD   ?       ;where average_vale will be stored


exit_message    BYTE    "Thank you for playing.", 0

EC_wrap         BYTE    "---------------------------------------------------------------------", 0

EC_description		BYTE	" **EC:DESCRIPTION** ", 0

EC_one          BYTE    "Extra Credit One: Used recursive merge sort for sorting array. ", 0

EC_two          BYTE    "Extra Credit Two: Used macro wrappers instead of Irvine procedures. ", 0







.code

;------------------------------PROCEDURES--------------------------------------------

;----------------------------
;introduction
;
;Description: This procedure prints the introduction of the program to the
; users screen.
;
;Recieves: none
;
;Returns: Printed introduction to users screen
;
;Registers Changed: none
;
;-----------------------------
introduction	PROC

	;displays introduction to the user


	clear_line              ; clear line is used to make the introduction
                            ; easier to read for the user 
	write_string intro_0

	clear_line

	write_string intro_1    ; introductions are split into sections to help
                            ; user readability and are printed through the write_string
	clear_line              ; macro. 

	write_string intro_2

	clear_line

	write_string intro_3

	clear_line

	ret                     ; nothing needs to be returned so we just use ret

introduction ENDP

;----------------------------
;get_user_input
;
;Description: This procdedure is called to acquire the input of how large they would like
; the array of random numbers to be. It is split into two parts first setting up the stack
; frame so datat can be stored and ascessed. Second the user input is taken and checked. The 
; user must input an integer in the range 10-200. If the user does not they will be re prompted
; for a new integer that is within that range. 
;
;Recieves: Empty array_size: where the user input size will be stored
;
;Returns: array_size with user input size stored in it.
;
;Registers Changed: ebp, ebx, eax are all used and adjusted in this procedure
;
;-----------------------------
get_user_input	PROC


stack_setup:

	push ebp
					;setting up stack frame
	mov ebp, esp


	mov ebx,[ebp + 8]   ;going to location of array_size

check_input:

	write_string prompt_1

	read_integer ebx        ; macro to read integer and place into ebx
                            ; which is currently pointing at array_size
	pop ebp

	mov eax, array_size     ; moves the size of array into eax

	cmp eax, lower_limit_size   ; compares gien size with lower limit of size

	jl stack_setup              ; if the input array size value is lower than the 
                                ; the lower limit the program loops back to the top
	cmp eax, upper_limit_size   ; compares given user array size and upper limit

	jg stack_setup              ; if array size is greater than upper limit program loops
                                ; and re prompts
	clear_line
	write_string unsorted_array 
	clear_line

	ret 4                       ; return the size of the data array_size= Dword = 4

get_user_input ENDP

;----------------------------
; array_fill
;
;Description: This function takes an array of the size input by the user in get_user_input
; and fills it with random integers within the range 100-999. The procedure starts by settig 
; up the stack and setting ecx to equal array size so that it will loop through the array the 
; same number of times as the elements. A random number is then generated for each element in the
; array and is stored in that element.
;
;Recieves: array: array is passed to the procedure by refrence via the stack
;          array_size: array_size is passed to the procedure by refrence via the stack
;
;Returns: Returns array with random integers in the number of elements same as array_size
;
;Registers Changed: ebp, esp, edi, ecx, eax, are used and adjusted in this procedure
;
;-----------------------------
array_fill PROC

	
	push ebp

	mov ebp, esp        ; set up for stack frame

	mov edi, [ebp+12]	; at array in edi


	mov ecx, array_size ; ecx is set to the number of elements of the array so when the 
                        ; program loops to fill the array ecx decrements and array will
fill:                   ; only be filled with the input number of elements

	mov eax, 900        ; hi=999 - low=100 = 899 + 1 = 900 put in eax for random range

	call RandomRange    ; get a number within range stored in eax

	add eax, 100        ; add the low back to the random number in eax

	
	mov [edi], eax      ; mov value to location in stack

	add edi, 4          ; move to next element in array
	
	dec ecx             ; decrement ecx which stores array size
	cmp ecx, 0          ; if array size is 0 get out of loop
	je next


	jmp fill            ; loop and continue filling

next:

	pop ebp             

	ret 8


array_fill ENDP

;----------------------------
; display_array
;
;Description: This procedure takes the array of random integers and displays them to the user. The integers are displayed in the
; order that they are in, in the array in rows of 10 with each numbber having 3 spaces in between. 
;
;Recieves: arra from stack, array size from stack
;
;Returns:   printed array to screen 
;
;Registers Changed: ebp, esp, ecx, eax, esi, are used ald altered in this procedure
;
;-----------------------------
display_array PROC

	clear_line

	push ebp        ;set up stack frame

	mov ebp, esp

	mov esi, [ebp+12] ; at list in esi

	mov ecx, array_size     ; ecx will be used to know where we are in array and how many elements
                            ; are left. 
	print:

		mov eax, [esi]      ; moves the value at current position in array into eax

		write_dec eax       ; prints value in eax



		write_string print_space    ; space is printed to seperated numbers

		add esi, 4      ; increment to next element in stack

		dec count       ; count is used to calculate when a new line character must be printed.
                        ; count starts at 10 and each time an integer is printed it is decremented.
		dec ecx         ; move to the next element in array count

		cmp ecx, 0      ; check to see if we have reached last element in array

		je next_two     ; if we have reached last element in array jump out of loop

		cmp count, 0    ; check to see if 10 numbers have been printed to scree

		je new_line     ; if so jump to new line

		jmp print       ; loop back to print
			
	new_line:

		mov count, 10   ; reset cout to 10

		clear_line      ; print new line

		jmp print       ; jump back to print
	
next_two:

	clear_line

	pop ebp ;reset stack

	ret 8       ;return size of value

display_array ENDP


;----------------------------
; print_array
;
;Description: print array is a different approach on how to print the array then display array, it uses all registers to move through the array
; and increment a count. unlike display array which decrements a count variable print array uses ebx and increments it on each loop and 
; checks if ebx is equal to 10 and if so prints a new line. 
;
;Recieves: array, via stack to be printed, array size via stack for count
;
;Returns:  sorted array printed in rows of 10 with 3 spaces inbetween 
;
;Registers Changed: ebp, esp, edi, edx, ecx, ebx, eax 
;
; DISCLAIMER: my original method for printing array was not working after sorting the array
; and I could not figure out why so I used the same site that helped me make my merge sort procedure
; to help me create a new procedure that I use to print the sorted list. ***Like the merge sort algorythm
; the creation of the algorythm used in this print procedure belongs to the person named above in the citation section***
; I simply used it to help me understand another way to print and solve a problem. 
;
;-----------------------------
print_array PROC       

    push    ebp

    mov     ebp, esp

    push    edi                 ; push registers into stack for use in procedure

    push    edx

    push    ecx

    push    ebx

    push    eax
    
    mov     edx, [ebp + 8]  ; ebp holds the sorted array prompt so we pass it into edx to be printed.

    clear_line

    call    WriteString     ;This is the one occurance where write_string macro not used because of 
                            ; special print case where you do not OFFSET so we use writestring. everywhere
                            ; else irvine wrapper macros are used. 
    clear_line
    clear_line
    
    mov     ecx, [ebp + 12]

    mov     edi, [ebp + 16]

    mov     ebx, 0          ; ebx here is being set up to increment for the new line character.

                            


print_loop:

    inc     ebx             ; ebx is beint used like the count variavle in display_array except where count was decremented
                            ; till 0 ebx is incremented till it hits 10

    write_dec [edi]         ; value at current array position is printed using write_dec macro

    add average_value, eax  ; this is where we will get our sum that will be used in getting the average later
                            ; each time the program pushed an array value into eax to be printed it is also adding
                            ; that value to average_value which at the moment is the sum
    write_string print_space 
                           
    cmp     ebx, 10     ; check to see if it is time to print newl line.

    jb      no_break    ; if ebx is not equal to 10 jump over the clear line and continue printing 
    
    cmp     ecx, 1      ; check if array is over.

    je      no_break
    
    clear_line          ; print new line

    mov     ebx, 0      ; reset ebx to 0 for count
    
no_break:

    add     edi, 4      ; go to next element in array

    loop    print_loop  ; loop back to print next integer
    
    pop     eax

    pop     ebx

    pop     ecx
                        ; reset stack
    pop     edx

    pop     edi
    
    pop     ebp

    ret     12

print_array ENDP



;----------------------------
; merge_sort
;
;Description: This procedure uses a merge sort algorythm(see citation for source) to sort an array 
; of random integers in descending order. merge sort works by continuosly splitting an array through
; recursion. It then one by one puts the array back together to form a sorted array. 
;
;Recieves: array, passed via the stack, array size, via the stack, temp array, via the stack
;
;Returns: sorted array that was passed to procedure in descening order 
;
;Registers Changed: none where changed after procedure ends
;
;-----------------------------
merge_sort PROC

    push    ebp

    mov     ebp, esp

    push    eax
    
    mov     eax, [ebp + 16]     ; procedure passes parameters directly

    push    eax             
    

    mov     eax, 0

    push    eax

    mov     eax, [ebp + 12]

    push    eax

    mov     eax, [ebp + 8]
    
    push    eax
    
    call    value_compare ; The merge sort procedure itself does not do any of the sorting
                          ; it simply takes the required values from the user and passes them
    pop     eax           ; to value compare which does the actual sorting. 
                         
    pop     ebp          

    ret     12           

merge_sort ENDP           


;----------------------------
; value_compare
;
;Description: This procedure is where the merge sorting takes place. It takes the given array and continuoulsu splits
; it using recursion storing the temporary values in a temporary array of the same size as that of the original array.
;
;Recieves: array, via stack where sorted integers will be placed. left side index value. right side index value.
; temporary array used to temporaroly store integer values
;
;Returns: sorted array of integers
;
;Registers Changed: none remain changed after procedure
;
;-----------------------------
value_compare PROC,
    v_temp_array:PTR DWORD,
    v_right:DWORD,              ; locak variavle to help with sort
    v_left:DWORD,
    v_main_array:PTR DWORD

    sub     esp, 20 ; Space for five integers: three index counters, midpoint, and distance.
    
    push    esi     

    push    edi     
                    ; push all registers into stack. same as pushad but it is easier to keep track 
    push    edx     ; by just manually pushing each register. 

    push    ecx     

    push    ebx     
    push    eax
         
; Checking for base case if v_left and v_right are within one of each other than the array length is 1

    mov     eax, v_left

    inc     eax            ; increment eax
    
    cmp     eax, v_right

    je      recursion_done  ; if it is an array length of 1 then there is nothing to sort therefore no more recursion
                            ; jump to after recursion 
    
; Find midpoint for recursion this is a necessary part of all merge sort algorythms

    mov     eax, v_right    ; move value of v_right into eax

    sub     eax, v_left     ; subtract eax(v_right) by v_left = distance

    mov     distance, eax   ; Store the distance 

    xor     edx, edx        ;  clear edx before division

    mov     ebx, 2      

    div     ebx             ; divide by two aka split array in half
    
    mov     midpoint, eax   ; midpoint now holds the middle index. EDX holds 1 or 0.
    
    mov     eax, v_left

    mov     L_index, eax    ; Initialising L_index, now that we have the midpoint.

    add     eax, midpoint   ; set eax to equal midpoint

    mov     R_index, eax  ; L_index will count up for the left half, R_index for the right half.

    
; push arguments for recursion .

    push    v_main_array

    mov     eax, v_left

    push    eax           ; same as pushing v_left

    add     eax, midpoint ; eax(v_left) + midpoint.

    push    eax           ; recursive right v_left + midpoint.

    push    v_temp_array

    call    value_compare  ; Recursively call the procedure for the left half.
    
    push    v_main_array

    push    eax          ;  push v_left + midpoint

    push    v_right      

    push    v_temp_array

    call    value_compare ; Recursively call the procedure for the right half.
    
    mov     ecx, distance ; set ecx to distance so it will run as many times as the size of the array 
                        
    mov     T_index, 0    ; 

compare_loop_start:

    mov     esi, L_index    ; ESI=left, 
                            ; EDI=right.

    mov     edi, R_index   

    mov     edx, v_left     ;check to see if we reached the end of left side array. 

    add     edx, midpoint

    cmp     esi, edx

    jae     insert_right
    
    cmp     edi, v_right    ; check to see if we reached end of right side array.

    jae     insert_left
    
    mov     edx, v_main_array    ; EDX=array address. 

    mov     eax, [edx + esi*4]   ; EAX and EDX[ESI] are being used for left side array

    mov     ebx, [edx + edi*4]   ; EBX and EDX[EDI] are being used for right side array

    cmp     eax, ebx

    jb      insert_right
    
insert_left:

    mov     edx, v_main_array ;used if earlier checks jump

    mov     eax, [edx + esi*4];  chech that EAX and EBX contain correct values.
    
    inc     L_index

    mov     edx, v_temp_array  ; use temp array to insert values.

    mov     edi, T_index       

    mov     [edx + edi*4], eax ; EAX is left side value.

    jmp     compare_loop_end
    
insert_right:       ; same as left_insert but with right side values

    mov     edx, v_main_array 

    mov     ebx, [edx + edi*4]
    
    inc     R_index

    mov     edx, v_temp_array  

    mov     esi, T_index       

    mov     [edx + esi*4], ebx ; EBX is right side value.
    
compare_loop_end:

    inc     T_index

    loop    compare_loop_start
    
; In this portion the values that are being stored in t he temp array are written back into the main array. 

    mov     edi, v_left ; The index starts at v_left because we're not necessarily
                        ;  working with the start of the array in recursive calls.
write_back_loop:

    mov     edx, v_temp_array

    mov     esi, edi

    sub     esi, v_left        ; working with beginning of temporary array, regardless of v_left.

    mov     eax, [edx + esi*4] ; EAX=temporary array
    
    mov     edx, v_main_array

    mov     [edx + edi*4], eax ; EAX value from temporary array, moved to main array.
    
    inc     edi

    cmp     edi, v_right    ; Loop until EDI is at v_right meaning we have completed this section of the array

    jb      write_back_loop
    
recursion_done:

    pop     eax

    pop     ebx

    pop     ecx            ; reset stack

    pop     edx

    pop     edi

    pop     esi

    add     esp, 20     ; Get rid of the local variables.
    
    ret

value_compare ENDP



;----------------------------
; show_medain
;
;Description: This procedure takes the now sorted array of integer and calculates and prints its median(middle).
;
;Recieves: array, size of array
;
;Returns: prints the medain value of the sorted array to the screen 
;
;Registers Changed: none 
;
; DISCLAIMER: As stated in the citation the method for finding the median I learned from the above stated post. 
;
;-----------------------------
show_median PROC

    push    ebp

    mov     ebp, esp

    
    push    edx

    push    ecx     ; push registers into stack like pushad

    push    ebx     

    push    eax
    
    mov     eax, [ebp + 8] ; puts size of array into eax

    xor     edx, edx

    mov     ebx, 2

    div     ebx
    
    cmp     edx, 0  ;checks to see if the size of the array is even meaning that the median would be between two numbers

    je     median_even
    
; If the array has an odd number of elements this code is used 

    mov     edx, [ebp + 12] ; Get array address.

    mov     eax, [edx + eax*4]   ; EAX=median.

    jmp     print_median    ;jump to print median
    
; if the array has an even number of elements this code is used

median_even:

    mov     edx, [ebp + 12]    ; Get array address.

    mov     ecx, [edx + eax*4] ; ECX now holds the upper value for the median.

    dec     eax

    mov     ebx, [edx + eax*4] ; EBX now holds the lower value for the median.

    
    xor     edx, edx    ; Clear EDX.

    mov     eax, ebx    ; EAX= lower median value

    add     eax, ecx    ; lower + upper median value.

    mov     ebx, 2      ; set to divide to get average of two values

    div     ebx         ; divide

    cmp     edx, 0      ; check to see if rounding is necessary by checking for remainder

    je      print_median    ; if no remainder go to print

    inc     eax         ; round the value up 
    
print_median:

    clear_line
                    ; make it look pretty
    clear_line

    write_string median

    write_dec eax   ; The median is already in EAX.

    clear_line
    
    pop     eax

    pop     ebx
                    ;reset stack
    pop     ecx

    pop     edx
    
    pop     ebp

    ret     8

show_median ENDP

;----------------------------
; show_average
;
;Description: This procedure calculates and prints the average value of the integer array. 
;
;Recieves: array, via stack. array size, via stack
;
;Returns: prints average of array values to screen
;
;Registers Changed: none remain changed after procedure
;
;-----------------------------
show_average PROC

    clear_line

    write_string average

    mov eax, average_value  ;sum of values in array which is currently stored in average_value is placed in eax

    mov edx, array_size     ; size of array is moved to edx

    cdq                     ; set up for division, extend sign in edx

    div array_size          ; sum/size = average stored in eax

    write_dec eax           ; write average

    clear_line

    ret

show_average ENDP

show_exit   PROC

    clear_line

    write_string exit_message

    clear_line

    ret

show_exit ENDP

;----------------------------
; extra_credit
;
;Description: This procedure prints the extra credit that was done in this program
;
;Recieves: none
;
;Returns: prints extra credit completed in this assingment after introduction
;
;Registers Changed: none remain changed after procedure
;
;-----------------------------
extra_credit    PROC


    clear_line

    write_string EC_wrap

    clear_line

    write_string EC_description

    clear_line

    clear_line

    write_string EC_one

    clear_line

    clear_line

    write_string EC_two

    clear_line

    clear_line

    write_string EC_wrap

    clear_line

    clear_line
    
    ret

extra_credit ENDP

;------------------------------------------------------------------------------------------

main PROC
	
	call Randomize      ; seed random number generator

	call introduction   ; introduce the program

    call extra_credit   ; state what extra credit was done

	push OFFSET array_size  ; push array size location into stack

	call get_user_input     ; get size of the array by user 

	push OFFSET array   ; push location of array into stack

	push OFFSET array_size  ; push array size location into stack

	call array_fill     ; fill array with random integers

	push OFFSET array   ; push location of array into stack

	push OFFSET array_size  ; push array size location into stack

	call display_array  ;displays unsorterd array

	push OFFSET array   ; push location of array into stack

	push array_size ; push array size into stack

	push OFFSET temp_array  ; push temp array location into stack

	call merge_sort     ; merge sort procedure to sort integers in descending order

	push OFFSET array   ; push location of array into stack

	push array_size ; push array size into stack

	push OFFSET sorted_array    ;prompt sorted array

	call print_array    ; prints sorted array, different then display array because
                        ; of reasons described in procedure header

    push OFFSET array   ; push location of array into stack

    push array_size     ; push array size into stack

    call show_median    ; calculate and show array median value

    call show_average   ; calculates and shows array average value

    call show_exit

    exit	;exit to operating system

main ENDP

END main