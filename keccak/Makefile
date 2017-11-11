msvc:
    yasm -fwin32 k800x.asm
    yasm -DBIN -fbin k800x.asm -ok800x.bin
		cl /nologo /O2 /Ot /DTEST k800.c k800x.obj
gnu:
		gcc -DTEST -Wall -O2 k800.c -otest	 
clang:
		clang -DTEST -Wall -O2 k800.c -otest	    