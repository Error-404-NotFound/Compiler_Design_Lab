%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
FILE *yyin;
FILE *file;
typedef struct{
    char *lexeme;
    char *token;
} SymbolTable;

int table_size = 0;
SymbolTable *table;

void Insert_Value(char *lexeme, char *token){
	table = (SymbolTable *)realloc(table, (table_size + 1) * sizeof(SymbolTable));
	table[table_size].lexeme = (char *)malloc(strlen(lexeme) + 1);
	table[table_size].token = (char *)malloc(strlen(token) + 1);
	strcpy(table[table_size].lexeme, lexeme);
	strcpy(table[table_size].token, token);
	table_size++;
}

void Make_SymbolTable();
%}

bin [01]
ws [ \t\n]
digit [0-9]
letter [A-Za-z]
letter_ [A-Za-z_]
alphanumeric [A-Za-z0-9]
space [ \t]
variable {letter_}({alphanumeric})*
number {digit}+
string \"([^\n]|\\n)*\"
comment "//".*

%%

{comment} ;
[\t\ ]+ ;
[\n] ;

("#"(\ )*"include"|"#"(\ )*"define"|"if"|"else"|"while"|"for"|"break"|"continue"|"return"|"int"|"char"|"float"|"double"|"void"|"struct"|"enum"|"typedef"|"sizeof"|"auto"|"static"|"register"|"extern"|"const"|"volatile"|"signed"|"unsigned"|"short"|"long"|"switch"|"case"|"default"|"goto"|"do"|"union"|"printf"|"scanf")  {Insert_Value(yytext, "Keyword"); printf("Lexeme: %s \t\t\t Token: Keyword\n",yytext);}
("<stdio.h>"|"<stdlib.h>"|"<string.h>"|"<math.h>"|"<ctype.h>"|"<time.h>"|"<stdbool.h>")  {Insert_Value(yytext, "Header"); printf("Lexeme: %s \t\t\t Token: Header\n",yytext);}
({variable}{space}*"()") 						{Insert_Value(yytext, "Function"); printf("Lexeme: %s \t\t\t Token: Function\n",yytext);}
({variable}|\&{variable}) 						{Insert_Value(yytext, "Identifier"); printf("Lexeme: %s \t\t\t Token: Identifier\n",yytext);}
{variable}\[{digit}+\] 							{Insert_Value(yytext, "Array Declaration"); printf("Lexeme: %s \t\t\t Token: Array Declaration\n",yytext);}
\{|\} 											{Insert_Value(yytext, "Braces"); printf("Lexeme: %s \t\t\t Token: Braces\n",yytext);}
\;|\,|\(|\) 									{Insert_Value(yytext, "Separator"); printf("Lexeme: %s \t\t\t Token: Separator\n",yytext);}
"=" 											{Insert_Value(yytext, "Assignment Operator"); printf("Lexeme: %s \t\t\t Token: Assignment Operator\n",yytext);}
"=="|">"|"<"|">="|"<="|"!=" 					{Insert_Value(yytext, "Relational Operator"); printf("Lexeme: %s \t\t\t Token: Relational Operator\n",yytext);}
"&&"|"||" 										{Insert_Value(yytext, "Logical Operator"); printf("Lexeme: %s \t\t\t Token: Logical Operator\n",yytext);}
"+"|"-"|"*"|"/" 								{Insert_Value(yytext, "Arithmetic Operator"); printf("Lexeme: %s \t\t\t Token: Arithmetic Operator\n",yytext);}
"++"|"--" 										{Insert_Value(yytext, "Increment/Decrement Operator"); printf("Lexeme: %s \t\t\t Token: Increment/Decrement Operator\n",yytext);}
{number} 										{Insert_Value(yytext, "Integer Constant"); printf("Lexeme: %s \t\t\t Token: Integer Constant\n",yytext);}
{number}\.{number}+ 							{Insert_Value(yytext, "Float Constant"); printf("Lexeme: %s \t\t\t Token: Float Constant\n",yytext);}
{string} 										{Insert_Value(yytext, "String Constant"); printf("Lexeme: %s \t\t\t Token: String Constant\n",yytext);}
\'{letter}\' 									{Insert_Value(yytext, "Character Constant"); printf("Lexeme: %s \t\t\t Token: Character Constant\n",yytext);}


%%

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
	yylex();
	Make_SymbolTable();
	fclose(yyin);
	return 0;
}

void Make_SymbolTable(){
	file = fopen("SymbolTable.txt", "w");
	if(file == NULL){
		printf("Error opening file.\n");
		exit(1);
	}
	for(int i = 0; i < table_size; i++){
		fprintf(file, "Lexeme: %s \t\t\t Token: %s \n", table[i].lexeme, table[i].token);
	}
	fclose(file);
}
