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
[ \t\n]+                        { /* Ignore whitespace and newline */ }
{digit}{digit}?                 {yylval.num=atoi(yytext);return DD_token;}
{letter}+                       {yylval.str=strdup(yytext);return MON_token;}
{digit}{digit}{digit}{digit}    {yylval.num=atoi(yytext);return YYYY_token;}
"-"                             {return HYPHEN;}
";"                             {return SEMICOLON;}
.                               {return yytext[0];}
%%