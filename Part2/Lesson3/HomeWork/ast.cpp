#include <iostream>
#include "ast.hpp"

AST::AST()
{
    Type = Undefined;
    Value = 0;
    Name = "";
    Left = NULL;
    Right = NULL;
    next = NULL;
}

AST::~AST()
{
    delete Left;
    delete Right;
}

std::ostream &operator<<(std::ostream &fo, AST* &N) {
    if (N->Type == Tree) {
        fo << "{ " <<N->Left << " }\n";
        if (N->next != NULL) fo << N->next;
    }
    else if (N->Type == NumberValue){
        fo << N->Value;
    }
    else if (N->Type == Variable) {
        fo << N->Name;
    }
    else if (N->Type == Undefined || N->Type > 9) { }
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
    return fo;
}

