%{
#include<stdio.h>
int check(char*);
%}


bin [01]
digit [0-9]
letter [A-Za-z]
letter_ [A-Za-z_]
ab [ab]
ws [ \t\n]

%%
{ws}+ ;
{ab}+ { if(check(yytext))
	 printf("Token: %s\n",yytext);
	else
	 printf("Reject\n");
      }
.* ;
%%

int main()
{ 
yylex(); 
printf("\n");
return 0;
}

int check(char *inp){
	int a=0;
	int b=0;
	while(*inp){
		(*inp++ == 'a') ? a++ : b++;
	}
	if(a==b) return 1;
	return 0;
}
