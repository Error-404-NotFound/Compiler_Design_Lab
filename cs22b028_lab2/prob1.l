%{
#include<stdio.h>
FILE *yyin;
int check(char *);
int strlength(char *);
%}

bin [01]
ws [ \t\n]
digit [0-9]
letter [A-Za-z]
letter_ [A-Za-z_]

%%

{ws}+ ;

{bin}* {  if(check(yytext))
			printf("Accepted: %s\n", yytext);
		else
			printf("Rejected: %s\n",yytext);
		}

.+ ;

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

int strlength(char* str){
	int i=0;
	while(str[i]!='\0'){
		i++;
	}
	return i;
}

int check(char* inp){
	int znum=0;
	int size=strlength(inp);
	for(int i=0;i<size/2;i++){
		if(inp[i]!=inp[size-i-1]){
			return 0;
		}
		if(inp[i]=='0'){
			znum++;
		}
	}
	if(znum%2==0)
		return 1;
	else
		return 0;
}
