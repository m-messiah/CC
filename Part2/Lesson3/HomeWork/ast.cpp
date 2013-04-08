#include <iostream>
#include "ast.hpp"

AST::AST()
{
    Type = Undefined;
    Value = 0;
    Name = "";
    Left = NULL;
    Right = NULL;
}

AST::~AST()
{
    delete Left;
    delete Right;
}

std::ostream &operator<<(std::ostream &fo, AST* &N) {
    if (N) {
    if (N->Type == Tree) {
        fo << N->Left << std::endl;
        if (N->next) fo << N->next;
    }
    else if (N->Type == NumberValue){
        fo << N->Value;
    }
    else if (N->Type == Variable) {
        fo << N->Name;
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
            case OperatorAssign:
                fo << "= " << N->Left << " " << N->Right;
                break;
         }
        fo << ")";
    }
    }
    else {
        fo << "NULL";
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
