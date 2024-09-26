%{
#include<stdio.h>
int check(char *);
%}

ws [ \t\n]
digit [0-9]
letter [A-Za-z]
letter_ [A-Za-z_]
required [x-z]


%%

{ws}+;

{required}+ { if(check(yytext))
		printf("%s is Valid String.\n",yytext);
	else
		printf("%s is Invalid String.\n",yytext);
}

.+ ;

%%

int main()
{
	yylex();
	return 0;
}

int check(char* inp) {
	int x=0,y=0;
	while(*inp){
		if(*inp == 'x') x++; 
		if(*inp == 'y') y++;
		*inp++;
	}
	printf("x=%d y=%d\n",x,y);
	if(x%2 == y%3){return 1;}
	return 0;
}
