%{
#include<stdio.h>
#include<stdlib.h>
#include<stdbool.h>
#include<string.h>

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

%token<num>INT
%token<lexeme>ID
%token SEMICOLON EQUAL LB RB

%right EQUAL

%%
slist:
	stmt SEMICOLON {
		// printf("%d", eflag);
		switch(eflag){
			case 0:
				printf("\t\tAccepted\n");
				break;
			case 1:
				printf("\t\tError2: Invalid Syntax\n");
				break;
			case 2:
				printf("\t\tError3: Invalid Syntax\n");
				break;
			case 3:
				printf("\t\tError4: Number or Identifier is Expected\n");
				break;
			case 4:
				printf("\t\tError5: Extra [\n");
				break;
			case 5:
				printf("\t\tError6: Extra ]\n");
				break;
		}
		eflag=0;
	} slist
	| error SEMICOLON {
		printf("\t\tError1: Invalid Syntax\n");
		eflag=0;
	} slist
	| { printf("------Done------\n"); }
	;

stmt:
	ID EQUAL E {if(!eflag) eflag=0;}
	| ID EQUAL ID {if(!eflag) eflag=0;}
	| E EQUAL ID {if(!eflag) eflag=0;}
	| E EQUAL INT {if(!eflag) eflag=0;}
	| E EQUAL E {if(!eflag) eflag=0;}
	| E error {
		//printf("\t\tError2: Invalid Syntax\n");
		eflag=1;
	}
	;

E:
	ID BRACKETS {if(!eflag) eflag=0;}
	| ID error {
		//printf("\t\tError3: Invalid Syntax\n");
		eflag=2;
	}
	;

BRACKETS:
	LB ID RB {if(!eflag) eflag=0;}
	| LB INT RB {if(!eflag) eflag=0;}
	| LB ID RB BRACKETS {if(!eflag) eflag=0;}
	| LB INT RB BRACKETS {if(!eflag) eflag=0;}
	| LB error RB {
		// printf("\t\tError4: Number or Identifier is expected\n");
		// printf("here\n");
		eflag=3;
	}
	| LB LB error RB {
		eflag=4;
	}
	| error RB {
		eflag=5;
	}
	;
%%

int yyerror(char *s){
    eflag = 0;
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
