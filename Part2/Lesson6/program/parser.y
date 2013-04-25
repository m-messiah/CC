%skeleton "lalr1.cc"   
%require "2.5"
%defines
%define parser_class_name "Parser"

%code requires {
#include <string>
#include "ast.hpp"
class Driver;
}

%parse-param { Driver& driver }
%lex-param   { Driver& driver }

%debug
%error-verbose

%union {
    double dval;
    std::string* sval;
    ASTNode* ast;
    NumberASTNode* num;
    VariableASTNode* var;
    BlockASTNode* block;
    BinaryOpASTNode* binOp;
    UnitASTNode* unit;
}

%code {
#include "driver.hpp"
}

%token END 0 "end of file"
%token PRINT
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
%token <sval> IDENTIFIER "identifier"
%token <dval> NUMBER "number"
%type <ast> expr
%type <ast> print
%type <ast> statement
%type <ast> assignment
%type <block> statements
%type <unit> unit

%%
%start program;

program 
    : unit { driver.result = $1; }
    ;

unit    
    : statements { $$ = new UnitASTNode($1); } 
    ;

statements
    : statements statement      { $$ = $1; $$->append($2); }  
    | /* Blackjack and girls */ { $$ = new BlockASTNode(); }
    ;

statement
    : assignment 
    | print      
    ;

assignment
    : IDENTIFIER EQUALS expr 
      { $$ = new BinaryOpASTNode('=', new VariableASTNode(*$1), $3); }
    ;

print 
    : PRINT expr { $$ = new PrintCallASTNode($2); }
    ;

%left PLUS MINUS;
%left TIMES SLASH;
expr 
    : expr PLUS expr    { $$ = new BinaryOpASTNode('+', $1, $3); }
    | expr MINUS expr   { $$ = new BinaryOpASTNode('-', $1, $3); }
    | expr TIMES expr   { $$ = new BinaryOpASTNode('*', $1, $3); }
    | expr SLASH expr   { $$ = new BinaryOpASTNode('/', $1, $3); }
    | IDENTIFIER        { $$ = new VariableASTNode(*$1); }
    | NUMBER            { $$ = new NumberASTNode($1); }
    ;
%%

void yy::Parser::error(const yy::location& l, const std::string& m)
{
    driver.error(m);
}
