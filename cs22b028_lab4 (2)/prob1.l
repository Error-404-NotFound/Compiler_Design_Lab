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

%%
[ \t\n]+                    { /* Ignore whitespace and newline */ }
{digit}+                    {printf("%s",yytext);yylval.str=strdup(yytext);return INT_s;}
{digit}+"."{digit}+         {printf("%s",yytext);yylval.str=strdup(yytext);return FLOAT_s;}
"+"                         {printf("%s",yytext);return PLUS;}
"-"                         {printf("%s",yytext);return MINUS;}
"i"                         {printf("%s",yytext);return IOTA;}
";"                         {printf("%s",yytext);return SEMICOLON;}
[^i0-9+-;]+                 {printf("%s",yytext);return ERROR;}
.                           {printf("%s",yytext);return ERRORA;}
<<EOF>>                     {printf("");return END;}
%%
