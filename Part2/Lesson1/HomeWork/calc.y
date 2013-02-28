%{
    #include <stdio.h>
    #include <ctype.h>
    #define YYSTYPE double

    /*extern "C"*/ int yylex(void);
    /*extern "C"*/ int yyparse(void);
    void yyerror(char const *);
%}

%token NUM

%left '+' '-'
%left '*' '/'
%left NEG
%%

input   : /* empty */
        | input line
        ;

line    : '\n'
        | exp '\n' { printf("%g\n", $1); }
        ;

exp     : NUM
        | exp '+' exp { $$ = $1 + $3; }
        | exp '-' exp { $$ = $1 - $3; }
        | exp '*' exp { $$ = $1 * $3; }
        | exp '/' exp { $$ = $1 / $3; }
        | '-' exp %prec NEG { $$ = - $2;}
        ;

%%

int yylex(void)
{
    int c;
    while ((c = getchar()) == ' ' || c == '\t');
    if (c == '.' || isdigit(c)) {
        ungetc(c, stdin);
        scanf("%lf", &yylval);
        return NUM;
    }
    if (c == EOF)
        return 0;
    return c;
}

void yyerror(char const *s)
{
    fprintf(stderr, "%s\n", s);
}

int main(void)
{
    return yyparse();
}
