TITLE CS2810-A1

; Student Name: Spencer Rosenvall
; Assignment Due Date: 11/1/2020

INCLUDE Irvine32.inc
.data
	;--------- Enter Data Here
	v_semester byte "CS2810 Fall Semester 2020",0
	v_title byte "Assembler Assignment #1",0
	v_name byte "Spencer Rosenvall",0

.code
main PROC
	;--------- Enter Code Below Here
	
	call clrscr ;clear the console
	
	; use dx reg (dh (8bits) + dl (8bits) = dx (16 bits, 1 byte))
	; ';' is used for comments
	; assembler in vs is not case-sensitive

	mov dh, 2 ; store 2 for row 2 in dh
	mov dl, 12 ; store 12 for column in dl
	call gotoxy ; uses dh and dl to move cursor to (dh, dl) in console; uses Irvine assembly helper lib "http://asmirvine.com/gettingStartedVS2017/Irvine.zip"; must unzip to c:\
	mov edx, offset v_semester ; store pointer for v_semester => edx
	call WriteString ; Irvine helper method to print value of pointer in edx to console

	mov dh, 3
	mov dl, 12
	call gotoxy ; clears values in both dh & dl
	mov edx, offset v_title
	call WriteString

	mov dh, 4
	mov dl, 12
	call gotoxy
	mov edx, offset v_name
	call WriteString
	
	xor ecx, ecx ; next two lines are equivalent of ReadLine(), waits for action before closing
	call ReadChar
	exit
main ENDP

END main