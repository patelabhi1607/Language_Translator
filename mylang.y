%{
int yylex();
void yyerror (char *s);
#include <stdio.h>
#include <stdlib.h>
extern FILE *yyin;
int symbols[52];
int symbolVal(char symbol);
void updateSymbolVal(char symbol, int val);
%}

%union {int num; char id;}
%start line
%token print
%token exit_command
%token ctof
%token ktof
%token drytemperature
%token wettemperature
%token <num> NUMBER 
%token <id> identifier
%type <num> line exp term
%type <id> assignment

%%
line : assignment        
     | exit_command       {exit(EXIT_SUCCESS);}
     | print exp          {printf("printing %d \n", $2);}
     | line assignment    
     | line print exp     {printf("printing %d \n", $3);}
     | line exit_command  {exit(EXIT_SUCCESS);}
     ;
     
assignment : identifier '=' exp { updateSymbolVal($1,$3); }
	     ;
	     
exp : term                                       {$$ = $1;}
    | NUMBER ctof                                {$$=(int)(($1*9/5)+32);}
    | NUMBER ktof                                {$$=(int)((($1-273)*9/5)+32);}
    | drytemperature term wettemperature term    {$$=(98.4-(($2-$4)*300)/$2);} 
    ;
term : NUMBER     {$$ = $1;}
     | identifier {$$ = symbolVal($1);}
     ; 
%%

int computeSymbolIndex(char token)
{
	int idx = -1;
	if(islower(token)){
		idx = token - 'a' + 26;
	}
	else if(isupper(token)){
		idx = token - 'A';
	}
	return idx;
}

int symbolVal(char symbol)
{	
	int bucket = computeSymbolIndex(symbol);
	return symbols[bucket];
}
    
void updateSymbolVal(char symbol, int val)
{
	int bucket = computeSymbolIndex(symbol);
	symbols[bucket] = val;
} 

int main(int argc,char *argv[]) {
	yyin=fopen(argv[1],"r");
	int i;
	for(i=0 ; i<52 ; i++){
		symbols[i] = 0;
	}
	for(i=1;i<=6;i++){
		yyparse();
	}
	fclose(yyin);
}
void yyerror(char *s) {fprintf(stderr ,"%s\n" , s);}
