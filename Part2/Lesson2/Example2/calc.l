%{
#include <cstdlib>
#include "calc_defines.h"
%}

%option noyywrap
%option debug

digit [0-9]
char  [a-zA-Z_]
nchar [a-zA-Z_0-9]
nl    [\r\n]

%%

"+"                     return PLUS;
"-"                     return MINUS;
"="                     return EQ;
{digit}*\.?{digit}+     {
                            yylval.dval = std::atof(yytext); 
                            return NUM;
                        }
{char}{nchar}*          {
                            yylval.sval = new std::string(yytext);
                            return ID;
                        }
{nl}                    return NL;
.                       /* ignore */
