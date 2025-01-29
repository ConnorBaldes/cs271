 
INCLUDE Irvine32.inc

.386
;.model flat,stdcall
.stack 4096	;SS
ExitProcess proto,dwExitCode:dword

.data
	into1	BYTE	"Welcome User. What is your name?",0
	intro2	BYTE	"? What a great name. Today I will be calculating Fibonacci numbers for you.",0
	prompt1 BYTE	"Pick the number of Fibonacci I will be displaying (must be 1-46):",0
	pSpace	BYTE	"     ",0

	uName	BYTE	15 DUP(0)

	fNum1	DWORD	?
	fNum2	DWORD	?
	
	uCount	DWORD	?
	lBound	DWORD	0
	uBound	DWORD	?
	lCount	DWORD	?

	bye1	BYTE	"Thanks for joining me! Have a nice day!",0

.code
main proc

	Introduction:
		mov	EDX, OFFSET into1				
		call WriteString
		call Crlf
		mov EDX, OFFSET uName
		mov ECX, 15
		call ReadString
		call Crlf
		call WriteString
		mov	EDX, OFFSET intro2				
		call WriteString
		call Crlf

	Get_Bound:
		mov	EDX, OFFSET prompt1
		call WriteString
		call Crlf
		call ReadInt
		mov uBound, EAX
		cmp EAX, 46
		jle Less_Than
		jmp Get_Bound

	Less_Than:
		cmp EAX, 1
		jge Prepare
		jmp Get_Bound

	Prepare:
		call Crlf
		mov uBound, EAX
		mov uCount, 0
		mov lCount, 0
		mov fNum1, 0
		mov fNum2, 1

	Fib:
		mov ECX, lCount
		add ECX, 1
		mov lCount, ECX
		mov EAX, uCount
		add EAX, 1
		mov uCount, EAX
		
		mov EAX, fNum1
		mov EBX, fNum2
		add EAX, EBX
		mov EDX, EAX
		call WriteInt
		mov EDX, OFFSET pSpace
		call WriteString
		mov ECX, fNum2
		mov fNum1, ECX
		mov fNum2, EAX
		mov EAX, uBound
		cmp EAX, uCount
		jle Goodbye
		cmp lCount, 5
		je Newline
		jmp Fib


	Newline:
		call Crlf
		mov lCount, 0
		jmp Fib

	Goodbye:
		call Crlf
		mov EDX, OFFSET bye1
		call WriteString
		call Crlf


	invoke ExitProcess,0
main endp
end main