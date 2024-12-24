;hellocc
 ;using assembly language for turning LED on
.include "/data/data/com.termux/files/home/m328Pdef.inc"
.include "m328Pdef.inc"
start:	ldi r17,0b11000000
	out DDRD,r17
	ldi r16,0b00000000
	out DDRB,r16

level:  in r16,PINB
	andi r16,0b00000111       

        ldi r22,0b00000000              ;a,b and c
        ldi r23,0b00000000 
        ldi r24,0b00000000 
        ldi r25,0b00000001              ;temporary value 1 stored in r25
        ldi r26,0b00000000              ;sum
        ldi r27,0b00000000              ;carry
        
li1:    ldi r19,0b00000001
        and r19,r16
        subi r19,0b00000001
        breq l1

li2:    ldi r20,0b00000010
        and r20,r16
        subi r20,0b00000010
        breq l2

li3:    ldi r21,0b00000100
        and r21,r16
        subi r21,0b00000100
        breq l3
        rjmp solver
        
l1:     add r22,r25
        rjmp li2 
l2:     add r23,r25
        rjmp li3
l3:     add r24,r25
       	rjmp solver


solver: add r26,r22
        eor r26,r23 
        eor r26,r24   ;sum calculated a ex-or b ex-or c
	
        add r27,r22
        and r27,r23
        ldi r28,0x00
        add r28,r23
        and r28,r24
        add r27,r28      ;a.b+b.c stored in r27
	andi r27,0b00000001

        ldi r28,0x00
        add r28,r22
        and r28,r24
        add r27,r28      ;a.b+b.c +a.c stored in r27
	andi r27,0b00000001
        
sum:    ldi r28,0x00
        mov r28,r26
        subi r28,0x01
        breq final                      ;if sum==1 then display 1st bit as high 
        ldi r17,0b00000000              ;if sum==0 then display 1st bit as low              

carry:  ldi r28,0x00
        mov r28,r27
        subi r28,0x01
        breq final2                              ;if carry==1 then display 2nd bit as high
        ldi r28,0b00000000                      ;if carry==0 then display 2nd bit as low
        or r17,r28
        rjmp end

final:  ldi r17,0b10000000      
        rjmp carry

final2: ldi r28,0b01000000
        or r17,r28              ;moving sum and carry into r17 as 1st and 2nd bit respectively

end:    out PORTD,r17           ;show output through port d
        rjmp level


delay: 	ldi r29,0xFF
        ldi r30,0x3F
        ldi r31,0x30
inner_loop:	subi r29,0x01
	sbci r30,0x00
	sbci r31,0x00
	brne inner_loop
	ret
