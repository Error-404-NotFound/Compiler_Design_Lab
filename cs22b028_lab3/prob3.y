%{
#include<stdio.h>
#include<stdlib.h>
int yylex();
extern FILE *yyin;
int eflag = 0;
int yyerror(char*);
int year;
int date;
%}

%token DD JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV DEC HYPHEN YYYY SEMICOLON

%%

slist : stmt
   ;
 stmt: DD HYPHEN MONTH31 HYPHEN YYYY SEMICOLON {date=$1;  if(date<=31) {printf("Accepted\n");} else {printf("Rejected\n");}} stmt
   | DD HYPHEN MONTH30 HYPHEN YYYY SEMICOLON {date=$1;  if(date<=30) {printf("Accepted\n");} else {printf("Rejected\n");}} stmt
   | DD HYPHEN FEB HYPHEN YYYY SEMICOLON {date=$1; year=$5; if(date<=28) {printf("Accepted\n");} else if(date==29 && year%4==0) {printf("Accepted\n");} else {printf("Rejected\n");}} stmt
   | error SEMICOLON {printf("Rejected\n");} stmt
   | {printf("");}
    ;
MONTH30 : APR
   | JUN
   | SEP
   | NOV
   ;
MONTH31 : JAN
   | MAR
   | MAY
   | JUL
   | AUG
   | OCT
   | DEC
   ;
%%

int yyerror(char *s){
    // fprintf(stderr,"%s\n",s);
    return 0;
}

int main(int argc, char *argv[]) {
    if (argc > 1)
    {
        yyin = fopen(argv[1], "r");
        if (!yyin)
            return 1;
        yyparse();
    }
    return 0;
}