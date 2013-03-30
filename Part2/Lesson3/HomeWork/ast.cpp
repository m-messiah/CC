#include <iostream>
#include "ast.hpp"

ASTNode::ASTNode()
{
    Type = Undefined;
    Value = 0;
    Left = NULL;
    Right = NULL;
}

ASTNode::~ASTNode()
{
    delete Left;
    delete Right;
}

std::ostream &operator<<(std::ostream &fo, ASTNode* &N) {
    if (N->Type == NumberValue){
        fo << N->Value;
    }
    else {
        fo <<"(";
        switch (N->Type) {
            case OperatorPlus: 
                fo << "+ " << N->Left << " " << N->Right;
                break;
            case OperatorMinus:
                fo << "- " << N->Left << " " << N->Right;
                break;
            case OperatorMul:
                fo << "* " << N->Left << " " << N->Right;
                break;
            case OperatorDiv:
                fo << "/ " << N->Left << " " << N->Right;
                break;
            case UnaryMinus:
                fo << "- " << N->Left;
                break;
         }
        fo << ")";
    }
    return fo;
}

/*
int main() {
    ASTNode* A = new ASTNode;
    A->Type = NumberValue;
    A->Value = 3.0;
    ASTNode* B = new ASTNode;
    B->Type = NumberValue;
    B->Value = 4.0;
    ASTNode* MUL = new ASTNode;
    MUL->Type = OperatorMul;
    MUL->Left = A;
    MUL->Right = B;
    ASTNode* C = new ASTNode;
    C->Type = NumberValue;
    C->Value = 5;
    ASTNode* AST = new ASTNode;
    AST->Type = OperatorPlus;
    AST->Left = C;
    AST->Right = MUL;

    std::cout << AST << std::endl;
    return 0; 
}*/
