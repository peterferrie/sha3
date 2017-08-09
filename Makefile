msvc:
		cl /nologo /O2 /Ot /DTEST test.c sha3.c
gnu:
		gcc -DTEST -Wall -O2 test.c sha3.c -otest	 
clang:
		clang -DTEST -Wall -O2 test.c sha3.c -otest	    