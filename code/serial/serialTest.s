	include "serial.i"

	section serialTestCodeP,CODE_P

start:
	; ---------------------------------
	; ----- tests for subroutines -----
	; ---------------------------------

	; print title
	
	move.w	#(subroutinesTestStrEnd-subroutinesTestStr),d2
	move.b	#1,d3
	lea		subroutinesTestStr,a0
	bsr		_logString

	; print hex number $b16b00b5 ("big bobs" :D)
	
	move.l	#$b16b00b5,d1
	move.w	#8,d2
	move.b	#1,d3
	lea		hexNumberStr,a0
	bsr		_logHexNumber

	; print string "Hello world"

	move.w	#(helloWorldStrEnd-helloWorldStr),d2
	move.b	#1,d3
	lea		helloWorldStr,a0
	bsr		_logString

	; print chars for carriage return and line feed

	move.b	#CHR_CARRIAGE_RETURN,d1
	bsr		_logChar
	move.b	#CHR_LINE_FEED,d1
	bsr		_logChar

	; ----------------------------
	; ----- tests for macros -----
	; ----------------------------

	; print title

	LOG_STR macrosTestStr,#(macrosTestStrEnd-macrosTestStr),#1

	; print hex number $b16b00b5 ("big bobs" :D)

	LOG_HEX	#$b16b00b5,#8,#1,hexNumberStr
	
	; print string "Hello world"

	LOG_STR helloWorldStr,#(helloWorldStrEnd-helloWorldStr),#1
	
	; print chars for carriage return and line feed

	LOG_CHR	#CHR_CARRIAGE_RETURN
	LOG_CHR	#CHR_LINE_FEED

	moveq	#0,d0
	rts

	section serialTestDataP,DATA_P

macrosTestStr:
	dc.b "Testing macros..."
macrosTestStrEnd:
	EVEN

subroutinesTestStr:
	dc.b "Testing subroutines..."
subroutinesTestStrEnd:
	EVEN

helloWorldStr: 
	dc.b "Hello world"
helloWorldStrEnd:
	EVEN

hexNumberStr:
	blk.b	8,0
	EVEN
