TITLE CS2810-A5

; Student Name: Spencer Rosenvall
; Assignment Due Date: 11/29/2020

INCLUDE Irvine32.inc
.data
	; FIELDS ---------------------------------------------------
	v_semester byte "CS2810 Fall Semester 2020",0
	v_title byte "Assembler Assignment #5",0
	v_name byte "Spencer Rosenvall",0
	v_instruction byte "Guess a number between 0 and 100: ",0

	v_randomNum word "1",0
	v_guessValue word "1",0
	
	v_guessAgain byte "Guess again: ",0
	v_guessTooHigh byte " is too high",0
	v_guessTooLow byte " is too low",0
	v_guessIsCorrect byte " is correct!",0

	v_playAgain byte "Would you like to play again? (1 for yes, 0 for no)",0

	v_carriageReturn byte 13,10,0 ; some irvine var that when outputted to console, moves the cursor down a line	
.code
main PROC
	; [Main CODE] -------------------------------------------------------------------------------------------------------------------------------
	
	call clrscr
	call PrintSemesterInfo
	call PrintTitle
	call PrintName
	call GameLoop ; initial game loop start

	; [Game Methods] -------------------------------------------------------------------------------------------------------------------------
	
	GameLoop:
		call Randomize ; call once in prog to allow randomization
		call GenRandomNum
		call PrintInstruction

		call RunGame ; while loop
		
		; game finished, choose if play again
		call PrintPlayAgain
		call ReadDec
		cmp eax,0
			jnz ResetGame
			jz Finish
	
	RunGame:
		call ReadInput
		cmp ax, v_randomNum
		jg Greater ; jump if greater
		jl Less ; jump if lessthan
		jz Equal ; if equal
	ret
	
	ResetGame:
		call IncrementLine
		jmp GameLoop
	ret

	Greater:
		call PrintGuess
		mov edx, offset v_guessTooHigh
		call WriteString
		call IncrementLine
		call PrintGuessAgain
		call RunGame
	ret

	Less:
		call PrintGuess
		mov edx, offset v_guessTooLow
		call WriteString 
		call IncrementLine
		call PrintGuessAgain
		call RunGame
	ret

	Equal:
		call PrintGuess
		mov edx, offset v_guessIsCorrect
		call WriteString
		call IncrementLine
	ret
	
	GenRandomNum:
		mov eax, 101
		call RandomRange
		mov v_randomNum, ax
	ret
	; [General Methods] -------------------------------------------------------------------------------------------------------------------------
	
	; increment the line using a carriageReturn
	IncrementLine:
		mov edx, offset v_carriageReturn
		call WriteString
	ret

	; print play again
	PrintPlayAgain:
		mov edx, offset v_playAgain
		call WriteString
		call IncrementLine
	ret

	; print guess again
	PrintGuessAgain:
		mov edx, offset v_guessAgain
		call WriteString
	ret

	; print guess
	PrintGuess:
		mov edx, offset v_guessValue
		call WriteDec
		;call WriteString
	ret

	; print semester info
	PrintSemesterInfo:
		mov dh, 4 ; row
		mov dl, 0 ; col
		call gotoxy ; uses dh and dl to move cursor to (dh, dl) in console; uses Irvine assembly helper lib "http://asmirvine.com/gettingStartedVS2017/Irvine.zip"; must unzip to c:\
		mov edx, offset v_semester ; store pointer for v_semester => edx
		call WriteString ; Irvine helper method to print value of pointer in edx to console
	ret

	; print title
	PrintTitle:
		mov dh, 5
		mov dl, 0
		call gotoxy ; clears values in both dh & dl
		mov edx, offset v_title
		call WriteString
	ret

	; print name
	PrintName:
		mov dh, 6
		mov dl, 0
		call gotoxy
		mov edx, offset v_name
		call WriteString
		
		; setup for inital print instruction line
		mov dh, 8
		mov dl, 0
		call gotoxy
	ret

	; print instruction
	PrintInstruction:
		mov edx, offset v_instruction
		call WriteString
	ret

	; read the decimal input
	ReadInput:
		call ReadDec ; decimal input gets saved to register EAX.
		mov v_guessValue, ax
	ret

	Finish:
	xor ecx, ecx ; next two lines are equivalent of ReadLine(), waits for action before closing
	exit

main ENDP

END main