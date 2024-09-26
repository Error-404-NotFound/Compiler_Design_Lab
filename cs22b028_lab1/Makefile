lex.yy.c: ${fname}.l
	lex ${fname}.l

lexer: lex.yy.c
	gcc -o lexer lex.yy.c -ll

all: lexer ${input}.txt
	lex ${fname}.l
	gcc -o lexer lex.yy.c -ll
	./lexer < ${input}.txt