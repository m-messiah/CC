#ifndef AST_H
#define AST_H

#include <iostream>

enum ASTNodeType 
{
    Undefined,
    OperatorPlus,
    OperatorMinus,
    OperatorMul,
    OperatorDiv,
    UnaryMinus,
    NumberValue
};

class ASTNode
{
public:
    ASTNodeType Type;
    double      Value;
    ASTNode*    Left;
    ASTNode*    Right;

    ASTNode();

    ~ASTNode();

    friend std::ostream &operator<<(std::ostream &fo, ASTNode* &N); 

};
#endif
