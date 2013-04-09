%skeleton "lalr1.cc"   
%require "2.5"
%defines
%define parser_class_name "Parser"

%code requires {
#include <string>
class Driver;
class AST;
}

%parse-param { Driver& driver }
%lex-param   { Driver& driver }

%debug
%error-verbose

%union {
    AST* ast;
}

%code {
#include "driver.hpp"
#include "ast.hpp"
}

%token END 0 "end of file"
%token PLUS
%token MINUS
%token TIMES
%token SLASH
%token LPAREN
%token RPAREN
%token EQUALS
%token SEMICOLON
%token DEF
%token EXTERN
%token <ast> IDENTIFIER "identifier"
%token <ast> NUMBER "number"
%type <ast> expr exprs assign
%%
%start unit;
unit    : exprs {   AST* tree = new AST;
                        tree->Left = $1;
                        tree->Type = Tree;
                        tree->next = driver.ast;
                        driver.ast = tree;
                    };

exprs   : exprs expr {AST* tree = new AST;
                        tree->Left = $2;
                        tree->Type = Tree;
                        tree->next = driver.ast;
                        driver.ast = tree;
                    }
        | exprs assign { AST* tree = new AST;
                        tree->Left = $2;
                        tree->Type = Tree;
                        tree->next = driver.ast;
                        driver.ast = tree;
                }
        | expr {}
        | assign {} 
        ;

%left PLUS MINUS;
%left TIMES SLASH;
assign:  IDENTIFIER EQUALS expr
            { AST* node = new AST;
              node->Type = OperatorAssign;
              node->Left=$1;
              node->Right=$3;
              $$ = node; }
 
expr    : expr PLUS expr    { 
                            AST* node = new AST;
                            node->Type = OperatorPlus;
                            node->Left=$1;
                            node->Right=$3;
                            $$ = node;
                            }
        | expr MINUS expr   { AST* node = new AST;
                            node->Type = OperatorMinus;
                            node->Left=$1;
                            node->Right=$3;
                            $$ = node; }
        | expr TIMES expr   { AST* node = new AST;
                            node->Type = OperatorMul;
                            node->Left=$1;
                            node->Right=$3;
                            $$ = node; }
        | expr SLASH expr   { AST* node = new AST;
                            node->Type = OperatorDiv;
                            node->Left=$1;
                            node->Right=$3;
                            $$ = node; }
        | NUMBER            { $$ = $1; }
        | IDENTIFIER        { $$ = $1; }
        ;
%%

void yy::Parser::error(const yy::location& l, const std::string& m)
{
    driver.error(m);
}
