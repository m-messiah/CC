/*
%{
Prologue
%}

Bison declarations

%%
Grammar rules
%%
Epilogue
*/

%{
    #include <stdio.h>
    #include <ctype.h>
    #define YYSTYPE double

    int yylex(void);
    void yyerror(char const *);
%}

%token NUM

%%

input   : /* empty */
        | input line
        ;

line    : '\n'
        | exp '\n' { printf("%g\n", $1); }
        ;

exp     : NUM
        | exp exp '+' { $$ = $1 + $2; }
        | exp exp '-' { $$ = $1 - $2; }
        | exp exp '*' { $$ = $1 * $2; }
        | exp exp '/' { $$ = $1 / $2; }
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
