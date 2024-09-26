%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<stdbool.h>

int yylex();
int yyerror(char *);
int yyparse();
extern FILE *yyin;
int eflag=0;
%}

%name parser

%union{
	int num;
	char* lexeme;
}

%token<lexeme>ID
%token<num>INT
%token EQUAL SEMICOLON LP RP ADD SUB MUL DIV COMMA

%right EQUAL
%left ADD SUB
%left MUL DIV

%%
slist:
	stmt SEMICOLON {
		switch(eflag) {
			case 0:
				printf("\t\tAccepted\n");
				break;
			case 1:
				printf("\t\tError1: Function Declaration Wrong\n");
				break;
			case 21:
				printf("\t\tError21: Extra (\n");
				break;
			case 2:
				printf("\t\tError2: Extra )\n");
				break;
			case 3:
				printf("\t\tError3: Arguments syntax is wrong\n");
				break;
			case 4:
				printf("\t\tError4: Argument Operand Error\n");
				break;
			case 5:
				printf("\t\tError5: Invalid Term\n");
				break;
			case 61:
				printf("\t\tError61: ) missing\n");
				break;
			case 6:
				printf("\t\tError6: ( missing\n");
				break;
			case 7:
				printf("\t\tError7: Invalid Factor\n");
				break;
		}
	} slist
	| error SEMICOLON {
		printf("\t\tError0: Invaild Syntax\n");
		eflag=0;
	} slist
	| { printf("------Done------\n"); }
	;

stmt:
	ID EQUAL FUNCTION {if(!eflag) eflag=0;}
	| FUNCTION {if(!eflag) eflag=0;}
	| error {eflag=1;}
	;

FUNCTION:
	ID LP FUNCTION RP {if(!eflag) eflag=0;}
	| ID LP RP {if(!eflag) eflag=0;}
	| ID LP EXPRS RP {if(!eflag) eflag=0;}
	| ID LP LP error RP {eflag=21}
	| ID LP error RP RP{eflag=2;}
	;

EXPRS:
	ID {if(!eflag) eflag=0;}
	| ID COMMA EXPRS {if(!eflag) eflag=0;}
	| E {if(!eflag) eflag=0;}
	| EXPRS COMMA E {if(!eflag) eflag=0;}
	| error {eflag=3;}
	;

E:
	E ADD T {if(!eflag) eflag=0;}
	| E SUB T {if(!eflag) eflag=0;}
	| T {if(!eflag) eflag=0;}
	| E error T {eflag=4;}
	;

T:
	T MUL F {if(!eflag) eflag=0;}
	| T DIV F {if(!eflag) eflag=0;}
	| F {if(!eflag) eflag=0;}
	| error {eflag=5;}
	;

F: 	LP E RP {if(!eflag) eflag=0;}
	| LP E error {eflag=61;}
	| error RP {eflag=6;}
	| INT {if(!eflag) eflag=0;}
	| ID {if(!eflag) eflag=0;}
	| error {eflag=7;}
	;
%%

int yyerror(char* s) {
	eflag=0;
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
