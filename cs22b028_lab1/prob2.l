%{
#include<stdio.h>
int check(char *);
%}

ws [ \t\n]
digit [0-9]
letter [A-Za-z]
letter_ [A-Za-z_]
required [a-d]
z [z]

%%

{ws}+;

(({required}+"az"{required}+"a")|({required}+"bz"{required}+"b")|({required}+"cz"{required}+"c")|({required}+"dz"{required}+"d")) {printf("%s is Valid String.\n",yytext);}

.+ ; {printf("%s is Invalid String.\n",yytext);}

%%


int main()
{
	yylex();
	return 0;
}