@============================================================================
@ *lab4_1.s*
@ Description: Given two strings, check whether the second string is a 
@              substring of the Nirst one.
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
@ Logic: (1) Sanity check if the substring STRING is zero or not. If zero, end.
@        (2) Sanity check if the string STRING is zero or not. If zero, end.
@        (3) Sanity check if the substring STRING is greater than string STRING.
@            If yes, end.
@        (3) Initialize index to 0. Also a counter for the loop.
@        (4) Read the addresses of strings into registers and compare one byte
@            at a time. If match/equal, set PRESENT to counter+1 value.
@        (5) Continue comparing until the substring STRING exhausts.
@            If all characters/bytes match from substring then counter provides 
@            the index from where the substring begins. Set PRESENT to 
@            counter + 1. Else clear the PRESENT.
@ 
@------------------------------------------------------------------------------

_PROG_DATA:
.data

    PRESENT: 
           .word 0

@ At the time of running, one of the TEST portion below should be uncommented.
@ If multiple such TEST portions are uncommented then last one in order will take
@ effect.

@TEST 1 : Here both strings are same, so PRESENT will be set to 1.
    STRING: 
           .asciz "BYTE"
    SUBSTR: 
           .asciz "BYTE"

@TEST 2 : Here as string is smaller than substring, sanity should fail.
@    STRING: 
@           .asciz "BYTE"
@    SUBSTR: 
@           .asciz "TYPEST"

@TEST 3 : Here as PE is present in TYPE, PRESENT will be set to 3.
@    STRING: 
@           .asciz "TYPE"
@    SUBSTR: 
@           .asciz "PE"
           
@TEST 4 : Here, BEL is not present in string TYPE, PRESENT will set to 0.
@    STRING: 
@           .asciz "TYPE"
@    SUBSTR: 
@           .asciz "BEL"

@TEST 5 : Here as PE is present in TYPE, PRESENT will be set to 4.
@    STRING: 
@           .asciz "TYPE"
@    SUBSTR: 
@           .asciz "E"

.text
.align 2
.global _MAIN
.global _END
.global _STR_LEN_LOOP
.global _SUBSTR_LEN_LOOP
.global _SUBSTR_LOOP
.global _LOOP
.global _COMPARE_SUBSTR_LEN
.global _PRESENT_CHECK

@ Program starts here
    _MAIN: 
          LDR   R1, =STRING       @ Read STRING address into R1.
          LDR   R2, =SUBSTR       @ Read SUBSTR address into R2.
          EOR   R3, R3, R3        @ Clear R3. It will be used for length of string.
          EOR   R4, R4, R4        @ Clear R4. It will be used for length of substring.
          
    _STR_LEN_LOOP:
          LDRB  R5, [R1], #1      @ Load the byte from string into R5
          ADD   R3, R3, #1        @ Increment length of string by 1.
          CMP   R5, #0            @ Compare if the null character (string ending) is read.
          BNE   _STR_LEN_LOOP     @ If not equal, then continue reading. 
          
    _SUBSTR_LEN_LOOP:
          LDRB  R5, [R2], #1      @ Load the byte from sub string into R5
          ADD   R4, R4, #1        @ Increment length of sub string by 1.
          CMP   R5, #0            @ Compare if the null character (string ending) is read.
          BNE   _SUBSTR_LEN_LOOP  @ If not equal, then continue reading.
          
          SUB   R3, R3, #1        @ This is required to remove counting '\0' as one byte in length.
          SUB   R4, R4, #1        @ This is required to remove counting '\0' as one byte in length.
          
    @ As we are here, we have both the lengths - string length in R3 and substring length in R4.
    @ Let us proceed for sanity checks.
    
          CMP R3, #0
          BEQ _END
          
          CMP R4, #0
          BEQ _END
          
          CMP R4, R3
          BGT _END
     
     @ As we are here, sanity check passed. 
     @ Let us execute the main program logic now.
     @ R4 contains the length of substring and R3 length of string.
     
          EOR   R5, R5, R5       @ Clear R5. 
          EOR   R0, R0, R0       @ Clear R0. Used as loop counter.
          EOR   R9, R9, R9       @ Clear R9. Used as loop counter.
          EOR   R8, R8, R8       @ Clear R8. Used as test variable.
          LDR   R1, =STRING      @ Read STRING address into R1.
          LDR   R2, =SUBSTR      @ Read SUBSTR address into R2.
          
   _SUBSTR_LOOP:      
          LDRB   R6, [R2], #1    @ Get the byte (value) from substring into R6.
          ADD    R9, R9, #1      @ Increment counter (for substring length)
          
    _LOOP:           
          LDRB   R5, [R1], #1    @ Get the byte (value) from string into R5.
          ADD    R0, R0, #1      @ Increment counter.
          
          CMP    R0, R3          @ Check if loop counter and length of string match.
          BGT    _PRESENT_CHECK  @ If equal or greater, end the program.  
          
          CMP    R5, R6          @ Compare values.
          BNE    _LOOP           @ Not equal, loop again. 
          
          
          
    @ If equal, we have found at least first byte from substring that is present in string.
 
          CMP    R8, #0
          BNE    _COMPARE_SUBSTR_LEN
          MOV    R8, R0          @ Store Index. One time only. This needs to be optimized.
          
    _COMPARE_SUBSTR_LEN:
          CMP    R9, R4          @ Check if counter is equal to substring length
          BLT    _SUBSTR_LOOP
    
    _PRESENT_CHECK:
          CMP   R9, R4           @ Compare to check if R9 is equal to R4 (length of substring)
          BNE   _END             @ If not equal then substring is not present else present.
          
          LDR   R7, =PRESENT     @ Get the address of PRESENT into R7
          STR   R8, [R7]         @ Store value in R8 into address pointed by R7
  
    _END:                        @ Program Ends with below directive.
        .end
        