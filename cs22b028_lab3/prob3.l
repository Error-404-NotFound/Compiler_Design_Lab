%{
#include<stdio.h>
#include<stdlib.h>
#include "y.tab.h"    
%}

bin [01]
ws [ \t\n]
digit [0-9]
letter [A-Za-z]
letter_ [A-Za-z_]

%%

{digit}{digit}?    { yylval =atoi(yytext);return DD;}
"Jan"|"jan"                      return JAN;
"Feb"|"feb"                      return FEB;
"Mar"|"mar"                      return MAR;
"Apr"|"apr"                      return APR;
"May"|"may"                      return MAY;
"Jun"|"jun"                      return JUN;
"Jul"|"jul"                      return JUL;
"Aug"|"aug"                      return AUG;
"Sep"|"sep"                      return SEP;
"Oct"|"oct"                      return OCT;
"Nov"|"nov"                      return NOV;
"Dec"|"dec"                      return DEC;
"-"                              return HYPHEN;
";"                              return SEMICOLON;
{digit}{digit}{digit}{digit}                        { yylval =atoi(yytext);return YYYY;}
[ \t\n]+                      ;

. { return yytext[0]; } ;

%%