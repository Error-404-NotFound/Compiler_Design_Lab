%{
#include<stdio.h>
#include<stdbool.h>
#include<string.h>
#include<stdlib.h>

int yylex();
int yyerror(char*);
int eflag = 0;
extern FILE * yyin;

#define IMAG_MISS 1
%}

%name parser

%union{
    char* str;
}

%token <str> INT_s
%token <str> FLOAT_s
%type <str> INT
%type <str> FLOAT
%type <str> REAL
%type <str> IMAG
%type <str> IMAG_NEW
%token PLUS MINUS IOTA SEMICOLON ERROR ERRORA END

%left PLUS MINUS

%%
slist:
    stmt SEMICOLON { (eflag) ? eflag=0 : printf("\tAccepted\n"); } slist |
    error SEMICOLON { printf("\tRejected: Error: Invalid character\n"); } slist |
    ERROR SEMICOLON { printf("\tRejected\n"); } slist |
    END { exit(0); } |
    error END { printf("\tRejected\n"); exit(0); } |
    ERROR END { printf("\tRejected\n"); exit(0); } |
    stmt END { printf("\tAccepted\n"); exit(0); } |
    ;

stmt:
    REAL operator IMAG {printf("");} |
    IMAG operator REAL {printf("");} |
    REAL operator REAL error {printf("\tRejected: Error: i missing Imaginary part missing.\n"); eflag = 1;} |
    IMAG operator IMAG error {printf("\tRejected: Error: Real part missing.\n"); eflag = 1;} |
    REAL operator IMAG_NEW error {printf("\tRejected: Error: Coefficient of Imag missing.\n"); eflag = 1;} |
    REAL error {printf("\tRejected: Error: Imaginary part missing\n"); eflag = 1;} |
    IMAG error {printf("\tRejected: Error: Real part missing\n"); eflag = 1;} |
    // IMAG_NEW error {printf("\tError: Coefficient of Imag missing\n"); eflag = 1;} |
    ERRORA error {printf("\tRejected: Error: Invalid character\n"); eflag = 1;} |
    ;

REAL:
    INT { $$ = strdup($1); } |
    FLOAT { $$ = strdup($1); } | 
    sign INT { $$ = strdup($2); } |
    sign FLOAT { $$ = strdup($2); }
    ;

IMAG:
    INT IOTA { $$ = strdup($1); } |
    FLOAT IOTA { $$ = strdup($1); } |
    sign INT IOTA { $$ = strdup($2); } |
    sign FLOAT IOTA { $$ = strdup($2); } |
    IOTA INT { $$ = strdup($2); } |
    IOTA FLOAT { $$ = strdup($2); } |
    sign IOTA INT { $$ = strdup($3); } |
    sign IOTA FLOAT { $$ = strdup($3); }
    ;

IMAG_NEW:
    IOTA { printf(""); } |
    sign IOTA { printf(""); } 
    ;

sign:
    PLUS | MINUS |
    ;

operator:
    PLUS | MINUS
    ;

INT: INT_s { $$ = strdup($1); };
FLOAT: FLOAT_s { $$ = strdup($1); };
%%

int yyerror(char *s){
    eflag = 0;
    // fprintf(stderr, "%s\n", s);
    // if (eflag == IMAG_MISS){
    //     // yyerror("Imaginary part missing.");
    //     fprintf(stderr, "Error: Imaginary part missing.\n");
    //     eflag = 0;
    // }
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
