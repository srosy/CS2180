TITLE CS2810-A2

; Student Name: Spencer Rosenvall
; Assignment Due Date: 11/7/2020

INCLUDE Irvine32.inc
.data
	; FIELDS ---------------------------------------------------
	v_semester byte "CS2810 Fall Semester 2020",0
	v_title byte "Assembler Assignment #2",0
	v_name byte "Spencer Rosenvall",0
	
	v_instruction byte "Input time in hex: ",0
	v_result byte "The result is: ",0
	v_time byte "--:--:--",0
.code
main PROC
	; CODE ------------------------------------------------------
	
	call clrscr ; clear the console
	
	; use dx reg (dh (8bits) + dl (8bits) = dx (16 bits, 1 byte))
	; ';' is used for comments
	; assembler in vs is not case-sensitive

	; print semester info
	mov dh, 15 ; store 15 for row 15 in dh
	mov dl, 20 ; store 20 for column in dl
	call gotoxy ; uses dh and dl to move cursor to (dh, dl) in console; uses Irvine assembly helper lib "http://asmirvine.com/gettingStartedVS2017/Irvine.zip"; must unzip to c:\
	mov edx, offset v_semester ; store pointer for v_semester => edx
	call WriteString ; Irvine helper method to print value of pointer in edx to console

	; print title
	mov dh, 16
	mov dl, 20
	call gotoxy ; clears values in both dh & dl
	mov edx, offset v_title
	call WriteString

	; print name
	mov dh, 17
	mov dl, 20
	call gotoxy
	mov edx, offset v_name
	call WriteString

	; print instruction
	mov dh, 19
	mov dl, 20
	call gotoxy
	mov edx, offset v_instruction
	call WriteString

	; read the hex input
	call ReadHex ; input gets saved to register EAX. Ex 0154 => 10:32:02
	ror ax, 8 ; endian reverse
	mov ecx, eax ; copy vals of ecx just in case

	; get hours
	and ax, 1111100000000000b ; b indicates binary value
	shr ax, 11 ; shift right by 11, which cuts off the 11 trailing 0's
	mov bh, 10 ; move 10 into bh (h is half)
	div bh ; divide 10 into -> 00000000|00000001 (already endian format, as pc expects)
	add ax, 3030h ; converts to ASCII, essentially adds 30
	mov word ptr [v_time+0], ax ; +0 is an offset of char position to store, moving ax into specified position

	mov eax, ecx ; reset field to handle minutes next

	; get minutes
	and ax, 0000011111100000b ; b indicates binary value
	shr ax, 5 ; shift right by 5, which cuts off the 5 trailing 0's
	mov bh, 10
	div bh
	add ax, 3030h
	mov word ptr [v_time+3], ax

	mov eax, ecx ; reset field to handle minutes next

	; get seconds
	; SHL shifts left, since base 2 it multiplies
	and ax, 0000000000011111b ; b indicates binary value
	shl ax, 1 ; shift left once to multiply by 2 since binary is base 2
	mov bh, 10
	div bh
	add ax, 3030h
	mov word ptr [v_time+6], ax

	; print time
	mov dh, 20
	mov dl, 20
	call gotoxy
	mov edx, offset v_result
	call WriteString
	mov edx, offset v_time
	call WriteString

	xor ecx, ecx ; next two lines are equivalent of ReadLine(), waits for action before closing
	call ReadChar
	exit
main ENDP

END main