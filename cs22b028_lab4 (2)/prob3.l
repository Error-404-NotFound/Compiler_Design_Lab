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
a [aA]
b [bB]
c [cC]

%%
[ \t\n]+                    { /* Ignore whitespace and newline */ }
{a}                         {printf("%s",yytext);yylval.str=strdup(yytext);return A_token;}
{b}                         {printf("%s",yytext);yylval.str=strdup(yytext);return B_token;}
{c}                         {printf("%s",yytext);yylval.str=strdup(yytext);return C_token;}
";"                         {printf("%s",yytext);return SEMICOLON;}
.                           {printf("%s",yytext);return yytext[0];}
%%
