del serialTest
del serial.o
del serialTest.o

vasmm68k_mot.exe -x -quiet -L serial.lst -Fhunk -nowarn=62 -o serial.o serial.s 
vasmm68k_mot.exe -x -quiet -L serialTest.lst -Fhunk -nowarn=62 -o serialTest.o serialTest.s 

vlink.exe -o serialTest serialTest.o serial.o
