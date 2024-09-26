%{
#include<stdio.h>
#include<stdbool.h>
#include<string.h>
#include<stdlib.h>
#include<limits.h>
#include<float.h>

int yylex();
int yyerror(char*);
int yyparse();
extern FILE * yyin;
int errorFlag = 0;
int eflag = 0;
int temp_int = INT_MIN;
float temp_float = FLT_MIN;
%}

%name parser

%union{
    int num;
    float fnum;
    char* lexeme;
}

%token <num> INT
%token <fnum> FLOAT
%token <lexeme> ID
%token INCREMENT DECREMENT ADD SUB MUL DIV MOD LP RP ASSIGN SEMICOLON

%right ASSIGN
%left ADD SUB
%left MUL DIV MOD
%right INCREMENT DECREMENT
%right UMINUS

%type <num> E T F 

%%
slist: 
    stmt SEMICOLON
    | slist stmt SEMICOLON
    ;

stmt:
    ID ASSIGN E {
        if(errorFlag == 0){
            printf("\t\tAccepted.\n");
        }
        errorFlag = 0;
    }
    | error { 
        printf("\t\tError: Syntax error.\n"); 
        errorFlag = 1; 
    }
    ;

E: 
    E ADD T { $$ = $1 + $3; }
    | E SUB T { $$ = $1 - $3; }
    | T { $$ = $1; }
    | E error T { 
        printf("\t\tError: Operand missing.\n");
        errorFlag = 1; 
    }
    // | LP E RP { $$ = $2; }
    ;

T:
    T MUL F { $$ = $1 * $3; }
    | T DIV F { 
        if (temp_int == 0){
            printf("\t\tError: Division by zero.\n");
            errorFlag = 1;
            temp_int = INT_MIN;
        }
        else{
            $$ = $1 / $3;
        }
    }
    | T MOD F { 
        if (temp_float!=FLT_MIN){
            printf("\t\tError: MOD by float.\n");
            errorFlag = 1;
            temp_float = FLT_MIN;
        }
        else{
            $$ = $1 % $3;
        }
    }
    | F { $$ = $1; }
    | error {
        printf("\t\tError: Invalid Term.\n");
        errorFlag = 1;
    }
    ;

F:
    LP E RP { $$ = $2; }
    | LP E error{
        printf("\t\tError: ')' missing.\n");
        errorFlag = 1;
    }
    | error RP {
        printf("\t\tError: '(' missing.\n");
        errorFlag = 1;
        $$ = 0;
    }
    | SUB F %prec UMINUS { $$ = -$2; }
    | INT { $$ = $1; temp_int = $1; }
    | FLOAT { $$ = $1; temp_float = $1; temp_int = $1; }
    | ID { $$ = $1; }
    | error { 
        printf("\t\tError: Invalid Factor.\n"); 
        errorFlag = 1; 
    }
    ;
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
