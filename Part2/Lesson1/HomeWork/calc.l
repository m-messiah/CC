%{
#include <iostream>
#include "calc.tab.h"
#define YYSTYPE double
#define YY_DECL extern "C" int yylex(void)
%}
%option noyywrap

NUM     [0-9]*(\.[0-9]+)?

%%
{NUM} {   int c;
    while ((c = getchar()) == ' ' || c == '\t');
    if (c == '.' || isdigit(c)) {
        ungetc(c, stdin);
        scanf("%lf", &yylval);
        return NUM;
    }
    if (c == EOF)
        return 0.0;
    return c;
}
%%
