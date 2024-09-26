%{
#include<stdio.h>
#include<stdbool.h>
#include<string.h>
#include<stdlib.h>

int yylex();
int yyerror(char*);
int eflag = 0;
extern FILE * yyin;

bool checkLeapYear(int year);
bool checkDate(int day, const char *month, int year);
bool checkMonth(const char *month);
bool Check(int day, char *month, int year);

bool monthFlag = false;
bool dateFlag = false;
bool flag = false;
%}

%name parser

%union {
    int num;
    char *str;
}

%token <num> DD_token
%token <str> MON_token
%token <num> YYYY_token
%token SEMICOLON HYPHEN

%type <num> DD
%type <str> MON
%type <num> YYYY
%type <str> date

%%


sdate: 
    date { if(!eflag) printf(""); else eflag = 0; } sdate | {printf("Done\n");} |
    error { 
        if(!flag){
            printf("Rejected: Invalid date format\n");
            flag = 1;
            dateFlag = false;
            monthFlag = false;
        }
        eflag = 0;
    } SEMICOLON {flag=0;} sdate |
    // END { exit(0); } |
    // ERROR END { printf("Rejected\n"); exit(0); } |
    // date END { printf("Accepted\n"); exit(0); } |
    // error END { printf("Rejected: Invalid date format\n"); exit(0); } |
    ;

date: 
    DD HYPHEN MON HYPHEN YYYY SEMICOLON{
        // printf("%s\n", $3);
        if(Check($1, $3, $5)) {
            printf("Accepted: %d %s %d\n", $1, $3, $5);
            // printf("%s\n", $3);
        } else {
            if(!dateFlag){
                printf("Rejected: Date out of range\n");
                dateFlag = false;
            }
            else if(!monthFlag){
                printf("Rejected: Invalid month\n");
                monthFlag = false;
            }
            else{
                printf("Rejected: Invalid date format\n");
                dateFlag = false;
                monthFlag = false;
            }
        }
    } | 
    { 
        printf("Rejected: Invalid date format\n"); 
        dateFlag = false;
        monthFlag = false;
    }
    ;

DD: DD_token { $$ = $1; }
MON: MON_token { $$ = strdup($1); }
YYYY: YYYY_token { $$ = $1; }


%%

int yyerror(char *s){
    eflag = 1;
    // eflag = 0;
    // fprintf(stderr, "%s\n", s);
    // if(s[0]!='s')
    // printf("Rejected : %s \n", s);
    return 0;
}

int main(int argc, char *argv[]){
    if(argc != 2){
        fprintf(stderr, "Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if(yyin == NULL){
        fprintf(stderr, "Error opening the input file.\n");
        return 1;
    }
    yyparse();
    fclose(yyin);
    return 0;
}

bool checkLeapYear(int year) {
    return (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
}

bool checkMonth(const char *month) {
    if(!strcmp(month, "Jan") || !strcmp(month, "Feb") || !strcmp(month, "Mar") || !strcmp(month, "Apr") || !strcmp(month, "May") || !strcmp(month, "Jun") || !strcmp(month, "Jul") || !strcmp(month, "Aug") || !strcmp(month, "Sep") || !strcmp(month, "Oct") || !strcmp(month, "Nov") || !strcmp(month, "Dec")) {
        return true;
    }
    return false;
}

bool checkDate(int day, const char *month, int year) {
    if(day<1 || day>31) return false;
    if(!strcmp(month, "Feb")) {
        if(checkLeapYear(year)) {
            return day<=29;
        } else {
            return day<=28;
        }
    }
    if(!strcmp(month, "Apr") || !strcmp(month, "Jun") || !strcmp(month, "Sep") || !strcmp(month, "Nov")) {
        return day <= 30;
    }
    return day <= 31;
}

bool Check(int day, char *month, int year){
    char *mon = month;
    dateFlag = checkDate(day, mon, year);
    monthFlag = checkMonth(mon);
    // printf("%b %b\n", dateFlag, monthFlag);
    return dateFlag && monthFlag;
}

