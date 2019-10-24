@============================================================================
@ *lab4_1.s*
@ Description: Compare two strings of ASCII characters to see which is larger.
@============================================================================
@============================================================================
@
@ EDIT HISTORY FOR MODULE
@
@ $Header: $
@
@ when          who                    what, where, why
@ -----------   -------------------    --------------------------
@ 24 Oct 2019    Swapneel Pimparkar     (Bengaluru) First Draft
@============================================================================

@------------------------------------------------------------------------------
@ Logic: (1) Sanity check if the length is zero or not. If zero, end.
@        (2) Also initialize register with 0. This will be representing GREATER.
@        (3) Initialize counter to zero.
@        (4) Read the addresses of strings into registers and compare one byte
@            at a time.
@        (5) Compare & if first is greater than second then set GREATER as -1.
@            Else, continue until end of length iterations for getting next 
@            bytes compared.
@ Optimization: It will not loop through again if the GREATER is set to -1. 
@------------------------------------------------------------------------------

_PROG_DATA:
.data

    LENGTH: 
           .word 4
    GREATER: 
           .word 0

@ At the time of running, one of the TEST portion below should be uncommented.
@ If multiple such TEST portions are uncommented then last one in order will take
@ effect.

@TEST 1 : Here both strings are same, so GREATER will be set to 0.
    STRING1: 
           .ascii "BYTE"
    STRING2: 
           .ascii "BYTE"

@TEST 2 : Here as T > B, GREATER will be set to -1.
@    STRING1: 
@           .ascii "BYTE"
@    STRING2: 
@           .ascii "TYPE"

@TEST 3 : Here as B < T, GREATER will be set to 0.
@    STRING1: 
@           .ascii "TYPE"
@    STRING2: 
@           .ascii "BYPE"
           
@TEST 4 : Here, as P < T, GREATER will be set as -1.
@    STRING1: 
@           .ascii "TYPE"
@    STRING2: 
@           .ascii "TYTE"
           
.text
.align 2
.global _MAIN
.global _GREATER
.global _END
.global _LOOP

@ Program starts here
    _MAIN: 
          LDR   R6, =LENGTH      @ Read length address into R6
          LDR   R5, [R6]         @ Get the length value into R5
          CMP   R5, #0           @ Check if length is zero or not.
          BEQ   _END             @ If zero, end the program.
          
          @ As we are here, minimum sanity check is complete.
          @ Let us execute the main program logic now.
          
          EOR   R8, R8, R8       @ Clear the R7. We will store greater here in R8.
          LDR   R0, =STRING1     @ Load the string1 in R1.
          LDR   R1, =STRING2     @ Load the string2 in R2.
          MOV   R2, #0           @ R2 will be used as counter. Initialize to 0.
          
    _LOOP:
          LDRB  R3, [R0], #1     @ Get the byte i.e. character into R3 from string 1.
          LDRB  R4, [R1], #1     @ Get the byte i.e. character into R4 from string 2.
          CMP   R3, R4           @ Compare R3 and R4
          BLT   _GREATER         @ Jump to GREATER if R4 byte is greater than R3 byte.
          ADD   R2, R2, #1       @ If not, Increment count by 1 so that we can compare next byte.
          CMP   R2, R5           @ Check if we are exceeding the total count than length.
          BLT   _LOOP            @ If count is less than length then loop through again.
          B     _END             @ Else goto end.
          
    _GREATER:
          MOV   R8, #-1          @ Set R8 to -1 i.e. 0xFFFFFFFF
          LDR   R7, =GREATER     @ Get the address of GREATER into R7
          STR   R8, [R7]         @ Store value in R8 into address pointed by R7
  
    _END:                        @ Program Ends with below directive.
        .end
        