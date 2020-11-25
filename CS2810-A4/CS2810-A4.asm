TITLE CS2810-A3

; Student Name: Spencer Rosenvall
; Assignment Due Date: 11/22/2020

INCLUDE Irvine32.inc
.data
	; FIELDS ---------------------------------------------------
	v_semester byte "CS2810 Fall Semester 2020",0
	v_title byte "Assembler Assignment #4",0
	v_name byte "Spencer Rosenvall",0
	v_instruction byte "Input the FAT16 file date in hex (hhhh): ",0
	v_result byte "The result is: ",0
	
	v_day_raw byte "31",0
	v_day byte "31",0

	v_month_raw byte "12",0
	v_month byte "December",0

	v_Year byte "2020",0

	v_th byte "th",0
	v_st byte "st",0
	v_nd byte "nd",0
	v_rd byte "rd",0

	v_months byte "January",0,"  "
			 byte "February",0," "
			 byte "March",0,"    "
			 byte "April",0,"    "
			 byte "May",0,"      "
			 byte "June",0,"     "
			 byte "July",0,"     "
			 byte "August",0,"   "
			 byte "September",0
			 byte "October",0,"  "
			 byte "November",0," "
			 byte "December",0," "

	v_space byte " ",0
	v_comma_space byte ", ",0
.code
main PROC
	; [Main CODE] -------------------------------------------------------------------------------------------------------------------------------
	
	call clrscr
	call PrintSemesterInfo
	call PrintTitle
	call PrintName
	call PrintInstruction
	call ReadInput
	call GetMonth
	call GetDay
	call GetSuffix
	call GetYear
	call Finish

	Write:
		call WriteString
	ret

	GetMonth:
		mov edx, offset v_result
		call WriteString

		mov eax, ecx ; reset the field
		and ax, 0000000111100000b ; b indicates binary value
		shr ax, 5 ; shift right by 5
		sub ax, 1
		mov word ptr [v_month_raw+0], ax

		;add edx, eax
		mov edx, offset [v_months]
		mov bl, 10
		mul bl
		add edx, eax
		call Write
		mov edx, offset [v_space]
		call Write
	ret

	GetYear:
		mov edx, offset [v_comma_space]
		call Write

		mov eax, ecx ; reset the field
		and ax, 1111111000000000b ; b indicates binary value
		shr ax, 9 ; shift right by 9
		add ax, 1980

		xor dx,dx ; clear out dx

		mov bx, 1000 ; isolate the thousands position
		div bx
		add al, 30h ; converts to an ascII char code
		mov byte ptr [v_Year], al

		mov ax,dx ; copy remainder down
		xor dx,dx ; clear out dx

		mov bx, 100 ; isolate the hundredths position
		div bx
		add al, 30h ; converts to an ascII char code
		mov byte ptr [v_Year+1], al

		mov ax,dx
		mov bl, 10

		div bl
		add ax, 3030h
		mov word ptr [v_Year+2], ax

		mov edx, offset [v_Year]
		call WriteString
	ret

	GetDay:
		mov eax, ecx ; reset field to handle minutes next

		and ax, 0000000000011111b ; b indicates binary value
		mov bh, 10 ; move 10 into bh (h is half)
		mov word ptr[v_day_raw+0], ax
		div bh
		add ax, 3030h ; converts to ASCII, essentially adds 30
		mov word ptr [v_day+0], ax

		mov edx, offset v_day
		call Write
	ret

	GetSuffix:
		cmp [v_day_raw],1
			jz _st
		cmp [v_day_raw],2
			jz _nd
		cmp [v_day_raw],3
			jz _rd
		cmp [v_day_raw],21
			jz _st
		cmp [v_day_raw],22
			jz _nd
		cmp [v_day_raw],23
			jz _rd
		cmp [v_day_raw],31
			jz _st

		jz _th

		_th:
			mov edx, offset v_th
			call Write
		ret
		_st:
			mov edx, offset v_st
			call Write
		ret
		_nd:
			mov edx, offset v_nd
			call Write
		ret
		_rd:
			mov edx, offset v_rd
			call Write
		ret
	ret

	; [General Methods] -------------------------------------------------------------------------------------------------------------------------

	; print semester info
	PrintSemesterInfo:
		mov dh, 4 ; row
		mov dl, 33 ; col
		call gotoxy ; uses dh and dl to move cursor to (dh, dl) in console; uses Irvine assembly helper lib "http://asmirvine.com/gettingStartedVS2017/Irvine.zip"; must unzip to c:\
		mov edx, offset v_semester ; store pointer for v_semester => edx
		call WriteString ; Irvine helper method to print value of pointer in edx to console
	ret

	; print title
	PrintTitle:
		mov dh, 5
		mov dl, 33
		call gotoxy ; clears values in both dh & dl
		mov edx, offset v_title
		call WriteString
	ret

	; print name
	PrintName:
		mov dh, 6
		mov dl, 33
		call gotoxy
		mov edx, offset v_name
		call WriteString
	ret

	; print instruction
	PrintInstruction:
		mov dh, 8
		mov dl, 33
		call gotoxy
		mov edx, offset v_instruction
		call WriteString
	ret

	; read the hex input
	ReadInput:
		mov dh, 9
		mov dl, 33
		call gotoxy
		call ReadHex ; input gets saved to register EAX. Ex 0154 => 10:32:02
		ror ax, 8 ; endian reverse
		mov ecx, eax ; copy vals of ecx just in case

		; set cursor for next line for output
		mov dh, 10
		mov dl, 33
		call gotoxy
	ret

	Finish:
	xor ecx, ecx ; next two lines are equivalent of ReadLine(), waits for action before closing
	call ReadChar
	exit

main ENDP

END main