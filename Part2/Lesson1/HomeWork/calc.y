%{
    #include <stdio.h>
    #include <ctype.h>
    #include <math.h>
    #define YYSTYPE double
    int yylex(void);
    int yyparse(void);
    void yyerror(char const *);
%}

%token NUM
%token PLUS MINUS MULT DIV POW
%token NL LPAR RPAR EXIT

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
        ;

exp     : NUM
        | exp PLUS exp { $$ = $1 + $3; }
        | exp MINUS exp { $$ = $1 - $3; }
        | exp MULT exp { $$ = $1 * $3; }
        | exp DIV exp { $$ = $1 / $3; }
        | MINUS exp %prec NEG { $$ = - $2;}
        | LPAR exp RPAR { $$ = $2; }
        | exp POW exp { $$ = pow($1,$3); }
        | EXIT  {   printf("%s\n","Recieved EXIT signal"); return 0; }
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
