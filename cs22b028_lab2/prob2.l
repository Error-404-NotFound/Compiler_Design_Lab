%{
#include<stdio.h>
FILE *yyin;
%}

bin [01]
ws [ \t\n]
digit [0-9]
letter [A-Za-z]
letter_ [A-Za-z_]
alphanumeric [A-Za-z0-9]
space [ \t]

%%

{ws}+ ;

("int"){space}*{letter}{alphanumeric}*{space}*"="{space}*{digit}+(","{space}*{letter}{alphanumeric}*{space}*"="{space}*{digit}+)*{space}*";" { printf("Accepted: %s\n", yytext); }
("float"){space}*{letter}{alphanumeric}*{space}*"="{space}*({digit}+("."{digit}+)?)(","{space}*{letter}{alphanumeric}*{space}*"="{space}*({digit}+("."{digit}+)?))*{space}*";" { printf("Accepted: %s\n", yytext); }

.+ ; printf("Rejected: %s\n",yytext);

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
	fclose(yyin);
	return 0;
}
