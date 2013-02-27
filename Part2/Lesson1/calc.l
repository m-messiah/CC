%{
#include <iostream>
 extern "C"
    {
        int yylex(void);
    }
%}
%option noyywrap

PI  "PI"
E   "E"
INT [0-9]+
PLUS "+"
MINUS "-"
MULT "*"
DIV "/"
NL "\r"|"\n"
%%
{INT} {std::cout << "INT: " << yytext << std::endl; }
{E} {std::cout << "E detected" << std::endl; }
{PI} {std::cout << "PI detected" << std::endl; }
%%
int main()
{
    yylex();
}
