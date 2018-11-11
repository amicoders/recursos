    IFND    SERIAL_I
SERIAL_I SET 1

; ---------------------
; ----- CONSTANTS -----
; ---------------------

CHR_LINE_FEED		equ	$0a
CHR_CARRIAGE_RETURN	equ	$0d
CHR_SPACE			equ $20
CHR_TAB				equ $09

; ------------------
; ----- MACROS -----
; ------------------

; ----------------------------------------------------------------------------- 
; NAME:	LOG_HEX
;																				
; DESC:	logs the hex representation of a number, optionally appending a new line
;																				
; IN:	\1.l = number to be logged as a string of hex digits
; 		\2.w = number of hex digits
;		\3.b = if <> 0 then feed a new line after the string
;		\4.l = pointer to output string
; -----------------------------------------------------------------------------	
LOG_HEX macro number,numberLen,feedNewLine,strPtr
	movem.l	d0-d3/a0,-(a7)

	; ----- load input parameters -----
	
	move.l	\1,d1			; d1 = hex number
	move.w	\2,d2			; d2 = number of digits
	move.b	\3,d3			; d3 = feed a new line?

	; ----- store ascii representation of the number -----

	lea		\4,a0			; a0 = pointer to aux digit list
	add.l	d2,a0			; move pointer to last string position
	sub.w	#1,d2	 		
.nextDigit\@:
	move.b	d1,d0			
	and.b	#$0f,d0			; d0 = current hex digit
	cmp.b	#$0a,d0
	bge		.isLetter\@
.isDigit\@:
	add.b	#$30,d0			; number char codes start at $30
	bra		.storeDigit\@
.isLetter\@:
	add.b	#$37,d0			; letter char codes start at $41
.storeDigit\@:
	move.b	d0,-(a0)		; store ascii code in string
	lsr.l	#4,d1			; move next hex digit to less significant nibble
	dbf		d2,.nextDigit\@

	; ----- send string to serial port -----

	LOG_STR \4,\2,\3

.logHexNumberEnd\@:
	movem.l	(a7)+,d0-d3/a0
endm

; ----------------------------------------------------------------------------- 
; NAME:	LOG_STR
;																				
; DESC:	logs a string of the given length, optionally appending a new line
;																				
; IN:	\1.l = pointer to string
; 		\2.w = string length in bytes
;		\3.b = if <> 0 then feed a new line after the string
; -----------------------------------------------------------------------------	
LOG_STR macro strPtr,strLen,feedNewLine
	movem.l	d2/d3/a0,-(a7)

	; load input parameters
	lea		\1,a0			; a0 = pointer to string
	move.w	\2,d2			; d2 = string length
	move.b	\3,d3			; d3 = feed a new line?

	sub.w	#1,d2	 		; d2 = number of hex digits
.logChar\@:
	LOG_CHR (a0)+
	dbf		d2,.logChar\@

	tst.b	d3				; feed a new line if requested
	beq		.logStringEnd\@
	LOG_CHR #CHR_CARRIAGE_RETURN
	LOG_CHR #CHR_LINE_FEED

.logStringEnd\@:
	movem.l	(a7)+,d2/d3/a0
endm

; ----------------------------------------------------------------------------- 
; NAME:	LOG_CHR
;																				
; DESC:	logs a char
;																				
; IN:	\1.b = char to be logged
; -----------------------------------------------------------------------------	
LOG_CHR macro char
	move.l	d0,-(a7)

	move.w	#$0100,d0		; d0 = byte to be sent + bit 9 (stop bit)
	move.b	\1,d0			
	move.w	d0,$dff030		; send byte to serial port
.waitTBE\@:
	btst	#13,$dff018		; wait until TBE (transmit buffer empty)
	beq		.waitTBE\@

.logCharEnd\@:
	movem.l	(a7)+,d0
endm

; ----------------------------
; ----- PUBLIC FUNCTIONS -----
; ----------------------------

	xref _logHexNumber
	xref _logString
	xref _logChar

	ENDC	; SERIAL_I
