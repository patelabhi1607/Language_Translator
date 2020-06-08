%{
#include<stdio.h>
#include "y.tab.h"		
%}
%%
[a-z]   {yylval.id = yytext[0]; return identifier;}
[0-9]+  {yylval.num = atoi(yytext); return NUMBER;}
[=;]     {return yytext[0];}
"print"   {return print;}
"exit"    {return exit_command;}
"ctof"    {return ctof;}
"ktof"    {return ktof;}
"drytemperature"   {return drytemperature;}
"wettemperature"   {return wettemperature;}
[ \t\n]  ;
.       {ECHO; yyerror("uexpected character");}
%%
int yywrap(void){return 1;}
