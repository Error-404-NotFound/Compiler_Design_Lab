%{
#include<stdio.h>
#include<stdbool.h>
int yylex();
int yyerror(char*);
extern FILE * yyin;
%}
%name parse
%token INT FLOAT PLUS MINUS IOTA SEMICOLON ERROR END
 
%%
 
slist:
    stmt SEMICOLON{printf("\tAccepted\n");}slist | 
    error SEMICOLON {printf("\tRejected\n");}slist |
    ERROR SEMICOLON {printf("\tRejected\n");}slist |
    END {exit(0);}|
    error END {printf("\tRejected\n");exit(0);} |
    ERROR END {printf("\tRejected\n");exit(0);} |
    stmt END {printf("\tAccepted\n");exit(0);} |
    ;
stmt:
    REAL operator IMAG |
    IMAG operator REAL |
    ;
REAL:
    INT | FLOAT | sign INT | sign FLOAT
    ;
IMAG:
    INT IOTA | FLOAT IOTA | sign INT IOTA | sign FLOAT IOTA | IOTA INT | IOTA FLOAT | sign IOTA INT | sign IOTA FLOAT
sign:
    PLUS | MINUS |
    ;
operator:
    PLUS|MINUS
    ;
%%
 
int yyerror(char *s){
    // fprintf(stderr,"%s\n",s);
    return 0;
}
 
int main(int argc,char *argv[]){
	if(argc!=2){
		fprintf(stderr,"Usage: %s <input_file>\n",argv[0]);
		return 1;
	}

	yyin=fopen(argv[1],"r");
	if(yyin==NULL){
		fprintf(stderr,"Error opening the input file.\n");
		return 1;
	}
	yyparse();
	fclose(yyin);
	return 0;
}