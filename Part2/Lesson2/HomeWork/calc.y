%code requires {
    #include <string>
}

%code{
    #include <stdio.h>
    #include <ctype.h>
    #include <math.h>
    #include <map>
    int yylex(void);
    int yyparse(void);
    void yyerror(char const *);

    std::map<std::string, double> variables;
}

%defines "calc_defines.h"

%union {
    double dval;
    std::string* sval;
}

%token <dval> NUM
%token <sval> ID
%type  <dval> exp
%token PLUS MINUS MULT DIV POW
%token NL LPAR RPAR EQ READ PRINT EXIT

%left PLUS MINUS
%left MULT DIV
%left NEG
%right POW
%%

input   : /* empty */
        | input line
        ;

line    : NL
        | exp NL { printf("%g\n", $1); }
        | PRINT exp NL { printf("Result = %g\n", $2); }
        | assign NL
        | EXIT {   printf("%s\n","Recieved EXIT signal"); return 0; }
        ;

assign  : ID EQ exp { variables[*$1] = $3; delete $1; }

exp     : NUM
        | ID { $$ = variables[*$1]; delete $1; }
        | READ { printf("Please input a number: "); scanf("%lg",&$$); }
        | exp PLUS exp { $$ = $1 + $3; }
        | exp MINUS exp { $$ = $1 - $3; }
        | exp MULT exp { $$ = $1 * $3; }
        | exp DIV exp { $$ = $1 / $3; }
        | MINUS exp %prec NEG { $$ = - $2;}
        | LPAR exp RPAR { $$ = $2; }
        | exp POW exp { $$ = pow($1,$3); }
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
