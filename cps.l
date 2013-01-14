
%{
//Definitions
//name subsitute
%}

%pointer
%{
// or %array, refers to type of 'yytext'
%}
%{
#include <stdio.h>
%}

%%

--[^\n]* printf("Comment");
[^ \t\n]+  printf("Symbol");
^[ \t]+  printf("Indent");
[ \t\n]+   /* ignore */

%%

int main(int argc, char *argv[])
{
	yylex();
}

int yywrap(void)
{
	return 1;
}
