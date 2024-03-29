%{
#include <iostream>
#include "parser.hpp"
#include "driver.hpp"
#include "ast.hpp"

typedef yy::Parser::token token;

#define yyterminate() return token::END
%}

%option noyywrap
%option debug

digit [0-9]
char  [a-zA-Z_]
nchar [a-zA-Z_0-9]
ws    [ \t]
nl    [\r\n]

%%

"+"                 return token::PLUS;     
"-"                 return token::MINUS;    
"*"                 return token::TIMES;    
"/"                 return token::SLASH;    
"^"                 return token::POW;    
"("                 return token::LPAREN;   
")"                 return token::RPAREN;   
"="                 return token::EQUALS;
{char}{nchar}*      {
                        yylval->ast = new AST;
                        yylval->ast->Type = Variable;
                        yylval->ast->Name = yytext;
                        return token::IDENTIFIER;
                    }
{digit}*\.?{digit}+ {
                        yylval->ast = new AST;
                        yylval->ast->Type = NumberValue;
                        yylval->ast->Value = std::atof(yytext);
                        return token::NUMBER;
                    }
({nl}|{ws})+        /* ignore */
.                   { driver.error("invalid character"); }

%%

void Driver::scan_begin()
{
    yy_flex_debug = trace_scanning;
    if (filename == "-")
        yyin = stdin;
    else if (!(yyin = fopen (filename.c_str (), "r")))
    {
        error(std::string ("cannot open ") + filename);
        exit(1);
    }
}

void Driver::scan_end()
{
    fclose(yyin);
}
