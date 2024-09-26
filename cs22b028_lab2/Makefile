CFLAGS = -g -DDEBUG
CC = gcc

lexer: lex.yy.c
	$(CC) $(CFLAGS) -o lexer lex.yy.c -ll
lex.yy.c: ${fname}.l
	lex ${fname}.l
clean:
	rm lex.yy.c lexer *.out *.txt *.exe
