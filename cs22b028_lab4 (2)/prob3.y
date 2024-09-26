%{
#include<stdio.h>
#include<stdbool.h>
#include<string.h>
#include<stdlib.h>

int yylex();
int yyerror(char*);
int eflag = 0;
extern FILE * yyin;

int countA = 0;
int countB = 0;
int countC = 0;
%}

%name parser

%union{
    char* str;
}

%token <str> A_token B_token C_token
%token SEMICOLON

%type <str> A B C

%%
slist:
    stmt SEMICOLON { 
        // printf("Counts: A=%d, B=%d, C=%d\n", countA, countB, countC);
        if(countA != countB && countB != countC && countA != countC){
            printf("\t\tAccepted\n");
        } else if(countA == countB){
            printf("\t\tRejected: Equal number of A and B\n");
        } else if(countB == countC){
            printf("\t\tRejected: Equal number of B and C\n");
        } else if(countA == countC){
            printf("\t\tRejected: Equal number of A and C\n");
        } else {
            printf("\t\tRejected: Equal number of A, B and C\n");
        }
        countA = 0;
        countB = 0;
        countC = 0;
     } slist |
    error SEMICOLON { 
        printf("\t\tRejected: Error: Invalid character\n"); 
        eflag = 0;
        countA = 0;
        countB = 0;
        countC = 0;
    } slist |
    { printf("Done\n"); }
    ;

stmt:
    A_seq B_seq C_seq |
   
    ;

A_seq:
    A { countA++; } |
    A { countA++; } A_seq |
    ;

B_seq:
    B { countB++; } |
    B { countB++; } B_seq |
    ;

C_seq:
    C { countC++; } |
    C { countC++; } C_seq |
    ;

A: A_token { $$ = strdup($1); };
B: B_token { $$ = strdup($1); };
C: C_token { $$ = strdup($1); };
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
