%{
#include<stdio.h>
void isValid(char *);
void isInvalid(char *);
%}

ws [ \t\n]
digit [0-9]
letter [A-Za-z]
letter_ [A-Za-z_]

%%
{ws}+ ;

(1|01)*0?111(01|1)*0?  { isValid(yytext);  }

.+ ; { isInvalid(yytext); }

%% 

int main()
{
	yylex();
	return 0;
}

void isValid(char* inp){
	printf("%s is Valid String.\n", yytext);
}

void isInvalid(char* inp){
	printf("%s is Invalid String.\n", yytext);
}
