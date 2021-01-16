//*******************************************************************************************************
// Program Name	: Project_BinarySearch
// Programmers	: Gregory Gregoriades Stud. ID:999999
//		  Giorgos Achilleos Stud. ID: 999999
// Date  Modif.	: 27 Nov 2017
//*******************************************************************************************************
// Comments: The program is taking a table of sorted numbers until one million and search   
//	     for a number using Binary Search Algorithm.
//*******************************************************************************************************
	.data
message_str:		.string "Give me the number you want to find: "
scanf_str:		.string "%llu"
FileOpenMode: 		.string	"r"
FileName: 		.string	"numbers_1mil.txt"
fscanf_str: 		.string	"%llu"
output_str:		.string "The number is found in place %llu of the table!\n"
error_str:		.string "The number is not found in the table!\n"
//*******************************************************************************************************
	.text
	.global	main

main:
	stp	x29, x30, [sp, -32]!	// Move the stack pointer 32 bytes down and store x29 and x30

	add	x29, sp, 0		// Copy the value of stack pointer to Frame Pointer

	ldr	x23,=4000000            // Load number four million in register x23
	ldr	x24,=1000000		// Load number one million in register x24
	mov	x0, x23			// Move x23 in register x0
	bl	malloc			// Do malloc
	
	str	x0, [x29, 24]		// Store the x0 into stack
	ldr	x0, [x29, 24]		// Move the address of the allocated space
	mov	x22,x24			// Move x24 in register x22
	bl	initTable		// Call function initTable
	ldr	x0, [x29, 24]		// Move the address of the allocated space
	mov	x22,x24			// Move x24 in register x22
	ldr	x0,[x29,24]		// Move the address of the allocated space
	mov	x19,x0			// Move x in register x19

Question:
	adr	x0,message_str		// Load the address of message_str
	bl	printf			// Call printf
	
	add	x1,x29,28		// Set the location to save the state
	adr	x0,scanf_str		// Load the address of scanf_str
	bl	scanf			// Call scanf

	ldr	x25,[x29,28]		// Load the read value in register x25
	ldr	x21,=1000000		// Load number one million in register x21
	mov	x22,0			// Put zero in register x22
	mov	x26,-2			// Put -2 in register x26

        bl	binarySearch		// Call function binarySearch

//****************************************[bb12]**********************************************
	cmp	w26,-1			// Compare w26 with -1
	b.eq	error			// if equal jump in Error
	
	ldp	x29,x30,[sp],32		// Release the stack space
	ret				// Return to loading function

initTable:
	stp	X29, X30, [sp, -32]!	// Move the stack pointer 32 bytes down and store x29 and x30
	add	x29, sp, 0		// Add sp in register x29		
		
	mov	x19,x0			// Move x0 in register x19

 	// Open the File For reading
	adr	x1, FileOpenMode	// FileOpenMode go in register x1
	adr	x0, FileName		// FileName go in register x0
	bl	fopen			// Call fopen
	
	mov 	x20, x0			// Move x0 in register x20

loop_init:
	add	x2,x19, 0		// The Location that fscanf will store the value
	add	x19,x19,4		// x19 = x19 + 4
	adr	x1, fscanf_str		// Put in x1 the scanf value
	mov	x0, x20			// The File pointer
	bl	fscanf			// Call fscanf
	
	add	x22,x22,-1		// x22 = x22 - 1
	cbnz	x22, loop_init		// If x22 != 0 then call loop_init
	
	ldp	x29,x30,[sp],32		// Release the stack space
	ret				// Return to loading function

//****************************************[bb1]**********************************************
binarySearch:
	stp	x29,x30,[sp,-32]!	// Move the stack pointer 32 bytes down and store x29 and x30
	add	x29,sp,0		// Copy the value of stack pointer to Frame Pointer

	
	mov	x1,x21			// Move x21 in register x1
	mov	x0,x22			// Move x22 in register x0
	mov	x2,2			// Move number 2 in register x2

	subs	x1,x1,x0		// x1 = x1 - x0
	sdiv	x1,x1,x2		// x1 = x1/x2
	add	x1,x1,x0		// x1 = x1 + x0
	mov	x24,x1			// Move x1 in register x24
	
	//comparison with arr[mid]
	mov	x2,4			// Move number 4 in register x2
	mul	x1,x1,x2		// x1 = x1*x2
	mov	x0,x19			// Move x19 in register x0
	ldr	w0,[x0,x1]		// Load the value in place x1 of the table
	mov	x1,x25			// Move x25 in register x1
	cmp	x0,x1			// Compares x0 with x1
	b.lt	move_right		// x0 < x1 go to move_right

//****************************************[bb2]**********************************************
	b.gt	move_left		// x0 > x1 go to move_left

//****************************************[bb3]**********************************************
	b.eq	found			// x0 = x1 go to found

//****************************************[bb4]**********************************************
return:
	mov	x0,x21			// Move x21 in register x0
	mov	x1,x25			// Move x25 in register x1

	cmp	w0,w1			// Compares w0 with w1
	b.lt	false_return		// w0 < w1 go to false_return

//****************************************[bb5]**********************************************
	mov	x0,x22			// Move x22 in register x0
	cmp	w0,w1			// Compare w0 with w1
	b.ge	false_return		// w0 >= w1 go to false_return

//****************************************[bb6]**********************************************
check:
	mov	w0,w26			// Move w26 in register w0
	cmp	w0,-2			// Move number -2 in register w0
	b.eq	binarySearch		// w0 = -2 go to binarySearch

	ldp	x29,x30,[sp],32		// Release the stack space
	ret				// Return to loading function


//****************************************[bb7]**********************************************
false_return:
	mov	w26,-1			// Move -1 in register w26

	b	check			// Go back to check

//****************************************[bb8]**********************************************
error:
	adr	x0,error_str		// Load the address of error_str
	bl	printf			// Call printf
		
	ldp	x29,x30,[sp],32		// Release the stack space
	ret				// Return to loading function

//****************************************[bb9]**********************************************
move_right:
	mov	x0,x24			// Move x24 in register x0

	mov	x22,x0			// Move x0 in register x22	

	b	return			// Go back to return

//****************************************[bb10]**********************************************
move_left:
	mov	x0,x24			// Move x24 in register x0		

	mov	x21,x0			// Move x0 in register x21

	b	return			// Go back to return

//****************************************[bb11]**********************************************
found:

	mov	w0,w24			// Move w24 in register w0

	mov	w26,w0			// Move w0 in w26
	mov	w1,w26			// Move w26 in register w1
	adr	x0,output_str		// Load the address of output_str
	bl	printf			// Call printf

	b	check			// Go back to check
