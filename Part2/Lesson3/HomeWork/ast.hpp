#ifndef AST_H
#define AST_H

#include <iostream>
#include <string>
enum ASTNodeType 
{
    Undefined,
    OperatorPlus,
    OperatorMinus,
    OperatorMul,
    OperatorDiv,
    OperatorPow,
    Parentheses,
    UnaryMinus,
    OperatorAssign,
    Variable,
    NumberValue,
    Tree
};

class AST
{
public:
    ASTNodeType Type;
    double      Value;
    std::string       Name;
    AST*    Left;
    AST*    Right;
    AST* next;

    AST();

    ~AST();

    friend std::ostream &operator<<(std::ostream &fo, AST* &N); 

};
#endif
