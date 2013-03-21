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
%token NL LPAR RPAR LET READ PRINT EXIT

%left PLUS MINUS
%left MULT DIV
%left NEG
%right POW
%%

input   : /* empty */
        | input line
        ;

line    : NL
        | exp NL
        | EXIT {   printf("%s\n","Recieved EXIT signal"); return 0; }
        ;

assign  : LPAR ID exp RPAR {variables[*$2] = $3; delete $2;}
        | assign LPAR ID exp RPAR {variables[*$3] = $4; delete $3;}
        ;

exp     : NUM
        | ID { $$ = variables[*$1]; delete $1; }
        | READ { printf("Please input a number: "); scanf("%lg",&$$); }
        | LPAR exp RPAR { $$ = $2; }
        | LPAR LET LPAR assign RPAR exp RPAR { $$ = $6; }
        | LPAR PLUS exp exp RPAR { $$ = $3 + $4; }
        | LPAR MINUS exp %prec NEG RPAR { $$ = - $3;}
        | LPAR MINUS exp exp RPAR { $$ = $3 - $4; }
        | LPAR MULT exp exp RPAR { $$ = $3 * $4; }
        | LPAR DIV exp exp RPAR { $$ = $3 / $4; }
        | LPAR POW exp exp RPAR { $$ = pow($3,$4); }
        | LPAR PRINT exp RPAR { printf("Result: %g\n", $3); }
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
