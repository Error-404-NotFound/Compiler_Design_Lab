CC = gcc
CFLAGS = -g -DDEBUG

# Only build parser if both .y and .l files exist
ifeq ($(wildcard ${fname}.y),${fname}.y)
parser: y.tab.c y.tab.h lex.yy.c
	${CC} -w y.tab.c lex.yy.c -ll -o parser

y.tab.c: ${fname}.y
	yacc -v -d -t ${fname}.y
endif

lexer: lex.yy.c
	${CC} ${CFLAGS} lex.yy.c -ll -o lexer

lex.yy.c: ${fname}.l
	lex ${fname}.l

clean:
	rm -f parser y.tab.c y.tab.h lex.yy.c lexer y.output *.out *.txt *.exe

