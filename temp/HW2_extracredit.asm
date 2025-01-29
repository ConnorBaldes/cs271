; AddTwo.asm - adds two 32-bit integers.
; Chapter 3 example

INCLUDE Irvine32.inc

.386
.model flat,stdcall
.stack 4096	;SS
ExitProcess proto,dwExitCode:dword

.data
	into1	BYTE	"Hi, this is Paris",0
	prompt1 BYTE	"Please give me your name.",0
	prompt2 BYTE	"Please give me your age.",0
	ifstring BYTE	"Wow! That young? yet you know how to use a computer!",0
	uName	BYTE	15 DUP(0)
	uNameLength	DWORD	?
	uAge	DWORD	?
	uCreet1	BYTE	"Hi ",0
	uCreet2	BYTE	" your age in dog's years is: ",0
	dYears	DWORD	?
	bye1	BYTE	"Thanks for playing! Have a nice day!",0

.code
main proc

	Introduction:
		mov	EDX, OFFSET into1				
		call WriteString
		call Crlf

	Get_name_age:
		mov	EDX, OFFSET prompt1				
		call WriteString
		call Crlf
		mov EDX, OFFSET uName
		mov ECX, 15
		call ReadString
		mov uNameLength, EAX
		call Crlf
		call WriteDec
		call Crlf

		mov	EDX, OFFSET prompt2			
		call WriteString
		call Crlf
		call ReadInt
		mov uAge, EAX

	Calculate_dog_years:
		mov EAX, uAge
		mov EBX, 7
		mul	EBX
		mov dYears, EAX

	Report_dog_years:
		mov	EDX, OFFSET uCreet1				
		call WriteString
		mov	EDX, OFFSET uName				
		call WriteString
		mov	EDX, OFFSET uCreet2			
		call WriteString
		mov EAX, dYears
		call WriteDec
		call Crlf

	If_age_five:
		mov EAX, uAge
		cmp EAX, 5
		jl age_five
		jmp Good_bye

	age_five:
		mov EDX, OFFSET ifstring
		call WriteString
		call Crlf


	Good_bye:
		mov	EDX, OFFSET bye1				
		call WriteString
		call Crlf



	invoke ExitProcess,0
main endp
end main