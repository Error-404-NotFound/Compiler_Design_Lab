%{
#include<stdio.h>
int check(char *);
%}

ws [ \t\n]
digit [0-9]
letter [A-Za-z]
letter_ [A-Za-z_]
letterdot [A-Za-z.]
letterdash [A-Za-z_-]
alphanumeric [A-Za-z0-9]


%%

{ws}+;

"mailto:"{alphanumeric}+"@"{letterdot}+{letter}+ {printf("%s is Valid mailto URL String.\n",yytext);}
"file:///"{letter}+":"?"/"({letter}+"/")*{alphanumeric}+"."{letter}+ {printf("%s is Valid file URL String.\n",yytext);}
"ftp://"({alphanumeric}+":"{alphanumeric}+"@")?({letter}+"."?)+(":"{digit}+)?("/"{letter}+)*({alphanumeric}+"."{letter}+)? {printf("%s is Valid ftp URL String.\n",yytext);}
("https://"|"http://")({letter}+"."?)+(":"{digit}+)?("/"{letter}+)*({alphanumeric}+"."{letter}+)?({letter}+"?"{alphanumeric}+"="{alphanumeric}+)?("&"{alphanumeric}+"="{alphanumeric}+)* {printf("%s is Valid http/https URL String.\n",yytext);}

.+ ; {printf("%s is Invalid URL String.\n",yytext);}

%%


int main()
{
	yylex();
	return 0;
}
