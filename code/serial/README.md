# m68k assembler library for serial port logging
#### Source code:

	All functions are provided both as macros and as subroutines. Feel free to use whichever suits you best.

	All exported subroutines have got a leading underscore, to make them directly accessible to C programs.
	
	Macro list:
	----------

	LOG_HEX: 		logs the hex representation of a number, optionally appending a new line.
	LOG_STR:		logs a string of the given length, optionally appending a new line.
	LOG_CHR:		logs a char.

	For a more detailed description see serial.i.

	Subroutine list:
	---------------

	_logHexNumber: 	logs the hex representation of a number, optionally appending a new line.
	_logString:		logs a string of the given length, optionally appending a new line.
	_logChar:		logs a char.

	For a more detailed description see serial.s.	
	
#### Testing:

	Follow these steps for testing on Windows:

	1) In WinUAE / IO Ports / Serial Port -> tcp://0.0.0.0:1234 (disable Shared)
	2) Open a CMD window and run "telnet 127.0.0.1 1234'
	3) Run serialTest (source is included in serialTest.s) and check results in the CMD window.
