%code requires {
#include <string>
}

%code {
#include <iostream>
#include <cstdio>
#include <map>

int yylex(void);
void yyerror(char const *);

std::map<std::string, double> variables;
}

%defines "calc_defines.h"

%union {
    double dval; 
    std::string* sval;
}

%token PLUS
%token MINUS
%token MULT
%token DIV
%token NL
%token EQ
%token <sval> ID
%token <dval> NUM
%type <dval> exp

%%

input   : /* empty */
        | input line
        ;

line    : NL
        | exp NL { std::cout << "result = " << $1 << std::endl; }
        | assign NL
        ;

assign  : ID EQ NUM { variables[*$1] = $3; delete $1; }
        ;

exp     : ID { $$ = variables[*$1]; delete $1; }
        | NUM { $$ = $1; }
        | exp exp PLUS { $$ = $1 + $2; }
        | exp exp MINUS { $$ = $1 - $2; }
        ;

%%

void yyerror(char const *s)
{
    fprintf(stderr, "%s\n", s);
}

int main(void)
{
    return yyparse();
}
