%option noyywrap
%{
#include<stdio.h>
#include<stdlib.h>
#include"y.tab.h"
%}

bin [01]
ws [ \t\n]
digit [0-9]
letter [A-Za-z]
letter_ [A-Za-z_]
alphanumeric [A-Za-z0-9_]

%%
[ \t\n]+			{ /*Ignore whitespace and newline*/ }
{letter_}{alphanumeric}*	{ printf("%s",yytext);yylval.lexeme=strdup(yytext);return ID; }
{digit}+			{ printf("%s",yytext);yylval.num=atoi(yytext);return INT; }
"="				{ printf("%s",yytext);return EQUAL; }
";"				{ printf("%s",yytext);return SEMICOLON; }
"("				{ printf("%s",yytext);return LP; }
")"				{ printf("%s",yytext);return RP; }
","				{ printf("%s",yytext);return COMMA; }
"+"				{ printf("%s",yytext);return ADD; }
"-"				{ printf("%s",yytext);return SUB; }
"*"				{ printf("%s",yytext);return MUL; }
"/"				{ printf("%s",yytext);return DIV; }
.				{ printf("%s",yytext);return yytext[0]; }
<<EOF>>				{ return 0; }
%%
