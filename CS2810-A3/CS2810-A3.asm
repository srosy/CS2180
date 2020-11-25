TITLE CS2810-A3

; Student Name: Spencer Rosenvall
; Assignment Due Date: 11/15/2020

INCLUDE Irvine32.inc
.data
	; FIELDS ---------------------------------------------------
	v_semester byte "CS2810 Fall Semester 2020",0
	v_title byte "Assembler Assignment #3",0
	v_name byte "Spencer Rosenvall",0
	
	v_instruction byte "Input MP3 frame header in hex",0
	v_result byte "The result is: ",0

	v_mpeg25 byte "MPEG Version 2.5",0
	v_mpeg20 byte "MPEG Version 2.0",0
	v_mpeg10 byte "MPEG Version 1.0",0
	v_mpegRE byte "MPEG Version Reserved",0

	v_layer1 byte "Layer Version I",0
	v_layer2 byte "Layer Version II",0
	v_layer3 byte "Layer Version III",0
	v_layerR byte "Layer Version Reserved",0

	v_MPEG100 byte "Sampling Rate 44100 Hz",0
	v_MPEG200 byte "Sampling Rate 22050 Hz",0
	v_MPEG2500 byte "Sampling Rate 11025 Hz",0

	v_MPEG101 byte "Sampling Rate 48000 Hz",0
	v_MPEG201 byte "Sampling Rate 24000 Hz",0
	v_MPEG2501 byte "Sampling Rate 12000 Hz",0

	v_MPEG110 byte "Sampling Rate 32000 Hz",0
	v_MPEG210 byte "Sampling Rate 16000 Hz",0
	v_MPEG2510 byte "Sampling Rate 8000 Hz",0

	v_SampleRateR byte "Sampling Rate Reserved",0

	v_MPEG_Format sword 00b,0
.code
main PROC
	; CODE ------------------------------------------------------
	
	call clrscr ; clear the console
	call PrintSemesterInfo
	call PrintTitle
	call PrintName
	call PrintInstruction
	call ReadInput
	call DisplayVersion
	call LayerDescription
	call SamplingRate
	call Finish

	; reset EAX from stored ECX value
	ResetEAX:
		;AAAA AAAA AAAB BCCD EEEE FFGH IIJJ KLMM - mp3 format
		;mov eax, 0FFFBA040h ; mpeg V1, Layer 3, 44100Hz - test
		;mov eax, 0FFF240C0h ; mpeg V2, Layer 3, 22050Hz - test
		;mov eax, 0FFFB9264h ; mpeg V1, Layer 3, 44100Hz - test
		;mov eax, 0FFFC9C64h ; mpeg V1, Layer 2, reserved - test
		mov eax, ecx ; reset field to handle minutes next 
	ret;

	; get the SamplingRate
	SamplingRate:
		call  ResetEAX
		mov dh, 17
		mov dl, 12
		call gotoxy

		and eax, 00000000000000000000110000000000b ; b is for binary data
		shr eax, 10 ; shift the bits to put 11 on the end and all 0's before

		; conditional if statements
		cmp eax, 11b ; reserved
			jz mpegR

		cmp eax, 00b
			jz is00b

		cmp eax, 01b
			jz is01b

		cmp eax, 10b
			jz is10b

		is00b:
			cmp v_MPEG_Format, 00b ; v2.5
				jz mpeg2500
			cmp v_MPEG_Format, 10b ; v2
				jz mpeg200
			cmp v_MPEG_Format, 11b ; v1
				jz mpeg100
		ret

		is01b:
			cmp v_MPEG_Format, 00b ; v2.5
				jz mpeg2501
			cmp v_MPEG_Format, 10b ; v2
				jz mpeg201
			cmp v_MPEG_Format, 11b ; v1
				jz mpeg101
		ret

		is10b:
			cmp v_MPEG_Format, 00b ; v2.5
				jz mpeg2510
			cmp v_MPEG_Format, 10b ; v2
				jz mpeg210
			cmp v_MPEG_Format, 11b ; v1
				jz mpeg110
		ret
		
		mpegR:
			mov edx, offset v_SampleRateR
			jmp DisplayString
		ret

		mpeg2500:
			mov edx, offset v_MPEG2500
			jmp DisplayString
		ret
		mpeg200:
			mov edx, offset v_MPEG200
			jmp DisplayString
		ret
		mpeg100:
			mov edx, offset v_MPEG100
			jmp DisplayString
		ret

		mpeg2501:
			mov edx, offset v_MPEG2501
			jmp DisplayString
		ret
		mpeg201:
			mov edx, offset v_MPEG201
			jmp DisplayString
		ret
		mpeg101:
			mov edx, offset v_MPEG101
			jmp DisplayString
		ret

		mpeg2510:
			mov edx, offset v_MPEG2510
			jmp DisplayString
		ret
		mpeg210:
			mov edx, offset v_MPEG210
			jmp DisplayString
		ret
		mpeg110:
			mov edx, offset v_MPEG110
			jmp DisplayString
		ret
	ret

	; get the layer description
	LayerDescription:
		call ResetEAX
		mov dh, 16
		mov dl, 12
		call gotoxy

		and eax, 00000000000001100000000000000000b ; b is for binary data
		shr eax, 17 ; shift the bits to put 11 on the end and all 0's before

		; conditional if statements
		cmp eax, 01b 
			jz vL3
		cmp eax, 10b
			jz vL2
		cmp eax, 11b
			jz vL1
		jmp vLR

		vLR:
			mov edx, offset v_layerR
			jmp DisplayString
		ret
		vL1:
			mov edx, offset v_layer1
			jmp DisplayString
		ret
		vL2:
			mov edx, offset v_layer2
			jmp DisplayString
		ret
		vL3:
			mov edx, offset v_layer3
			jmp DisplayString
		ret
	ret

	; print the display version
	DisplayVersion:
		call ResetEAX
		mov dh, 15
		mov dl, 12
		call gotoxy

		and eax, 00000000000110000000000000000000b ; b is for binary data
		shr eax, 19 ; shift the bits to put 11 on the end and all 0's before
		mov [v_MPEG_Format], ax

		; conditional if statements
		cmp eax, 00b ; performs a sudo subtraction. If numbers are the same
			jz mpeg25
		cmp eax, 01b
			jz mpegRE
		cmp eax, 10b
			jz mpeg20

		mov edx, offset v_mpeg10
		jmp DisplayString

		mpeg25:
			mov edx, offset v_mpeg25
			jmp DisplayString

		mpegRE:
			mov edx, offset v_mpegRE
			jmp DisplayString

		mpeg20:
			mov edx, offset v_mpeg20
			jmp DisplayString
	ret;

	DisplayString:
		call WriteString
	ret;

	; print semester info
	PrintSemesterInfo:
		mov dh, 10 ; store 10 for row 10 in dh
		mov dl, 12 ; store 12 for column in dl
		call gotoxy ; uses dh and dl to move cursor to (dh, dl) in console; uses Irvine assembly helper lib "http://asmirvine.com/gettingStartedVS2017/Irvine.zip"; must unzip to c:\
		mov edx, offset v_semester ; store pointer for v_semester => edx
		call WriteString ; Irvine helper method to print value of pointer in edx to console
	ret

	; print title
	PrintTitle:
		mov dh, 11
		mov dl, 12
		call gotoxy ; clears values in both dh & dl
		mov edx, offset v_title
		call WriteString
	ret

	; print name
	PrintName:
		mov dh, 12
		mov dl, 12
		call gotoxy
		mov edx, offset v_name
		call WriteString
	ret

	; print instruction
	PrintInstruction:
		mov dh, 13
		mov dl, 12
		call gotoxy
		mov edx, offset v_instruction
		call WriteString
	ret

	; read the hex input
	ReadInput:
		mov dh, 14
		mov dl, 12
		call gotoxy
		call ReadHex ; input gets saved to register EAX. Ex 0154 => 10:32:02
		;ror ax, 8 ; endian reverse
		mov ecx, eax ; copy vals of ecx just in case
	ret

	Finish:
	xor ecx, ecx ; next two lines are equivalent of ReadLine(), waits for action before closing
	call ReadChar
	exit

main ENDP

END main