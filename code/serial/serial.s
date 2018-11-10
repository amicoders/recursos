	include	"serial.i"

	section	serialCodeP,CODE_P

; ----------------------------------------------------------------------------- 
; NAME:	_logHexNumber()															
;																				
; DESC:	logs the hex representation of a number, optionally appending a new line
;																				
; IN:	d1.l = number to be logged as a string of hex digits
; 		d2.w = number of hex digits
;		d3.b = if <> 0 then feed a new line after the string
;		a0.l = pointer to output string
; -----------------------------------------------------------------------------	
	xdef _logHexNumber
_logHexNumber:
	movem.l	d0-d2/a0,-(a7)

	; ----- store ascii representation of the number -----

	add.l	d2,a0			; move pointer to last string position
	move.w	d2,-(a7)
	sub.w	#1,d2	 		
.nextDigit:
	move.b	d1,d0			
	and.b	#$0f,d0			; d0 = current hex digit
	cmp.b	#$0a,d0
	bge		.isLetter
.isDigit:
	add.b	#$30,d0			; number char codes start at $30
	bra		.storeDigit
.isLetter:
	add.b	#$37,d0			; letter char codes start at $41
.storeDigit:
	move.b	d0,-(a0)		; store ascii code in string
	lsr.l	#4,d1			; move next hex digit to less significant nibble
	dbf		d2,.nextDigit

	; ----- send string to serial port -----

	; LOG_STR \4,\2,\3
	move.w	(a7)+,d2
	bsr		_logString

.logHexNumberEnd:
	movem.l	(a7)+,d0-d2/a0
	rts
; ----------------------------------------------------------------------------- 
; NAME:	_logString()															
;																				
; DESC:	logs a string
;																				
; IN:	a0.l = pointer to string
; 		d2.w = string length in bytes
;		d3.b = if <> 0 then feed a new line
; -----------------------------------------------------------------------------	
	xdef _logString
_logString:
	movem.l	d2/d3/a0,-(a7)

	sub.w	#1,d2	 		; d2 = number of hex digits
.logChar:
	LOG_CHR (a0)+
	dbf		d2,.logChar

	tst.b	d3				; feed a new line if requested
	beq		.logStringEnd
	LOG_CHR #CHR_CARRIAGE_RETURN
	LOG_CHR #CHR_LINE_FEED

.logStringEnd:
	movem.l	(a7)+,d2/d3/a0
	rts

; ----------------------------------------------------------------------------- 
; NAME:	_logChar()															
;																				
; DESC:	logs a char
;																				
; IN:	d1.b = char to be logged
; -----------------------------------------------------------------------------	
	xdef _logChar
_logChar:
	move.l	d0,-(a7)

	move.w	#$0100,d0		; d0 = byte to be sent + bit 9 (stop bit)
	move.b	d1,d0			
	move.w	d0,$dff030		; send byte to serial port
.waitTBE:
	btst	#13,$dff018		; wait until TBE (transmit buffer empty)
	beq		.waitTBE

.logCharEnd:
	movem.l	(a7)+,d0
	rts
