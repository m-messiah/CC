#include "llvm/LLVMContext.h"
#include "llvm/Module.h"
#include "llvm/Analysis/Verifier.h"
#include "llvm/IRBuilder.h"
#include <vector>

int main(int argc, const char* argv[])
{
    using namespace llvm;

    IRBuilder<> builder(getGlobalContext());
    Module* theModule = new Module("module.1", getGlobalContext());

    std::vector<Type*> params(2, Type::getInt32Ty(getGlobalContext()));
    FunctionType* functionType =
        FunctionType::get(Type::getInt32Ty(getGlobalContext()), params, false);
    Function* function = Function::Create(functionType,
                                          Function::ExternalLinkage, "gcd",
                                          theModule);
    Function::arg_iterator args = function->arg_begin();
    Value* x = args++;
    x->setName("x");
    Value* y = args++;
    y->setName("y");

    BasicBlock* entry = BasicBlock::Create(getGlobalContext(), "bb",
                                           function);
    BasicBlock* ret = BasicBlock::Create(getGlobalContext(), "bb",
                                         function);
    BasicBlock* cond_false = BasicBlock::Create(getGlobalContext(),
                                                "bb", function);
    BasicBlock* cond_true = BasicBlock::Create(getGlobalContext(), "cond_true",
                                               function);
    BasicBlock* cond_false_2 = BasicBlock::Create(getGlobalContext(),
                                                  "cond_false2", function);

    builder.SetInsertPoint(entry);
    Value* xEqualsY = builder.CreateICmpEQ(x, y, "tmp");
    builder.CreateCondBr(xEqualsY, ret, cond_false);

    builder.SetInsertPoint(ret);
    builder.CreateRet(x);

    builder.SetInsertPoint(cond_false);
    Value* xLessThanY = builder.CreateICmpULT(x, y, "tmp");
    builder.CreateCondBr(xLessThanY, cond_true, cond_false_2);

    builder.SetInsertPoint(cond_true);
    Value* yMinusX = builder.CreateSub(y, x, "tmp");
    std::vector<Value*> args1;
    args1.push_back(x);
    args1.push_back(yMinusX);
    Value* recur_1 = builder.CreateCall(function, args1, "tmp");
    builder.CreateRet(recur_1);

    builder.SetInsertPoint(cond_false_2);
    Value* xMinusY = builder.CreateSub(x, y, "tmp");
    std::vector<Value*> args2;
    args2.push_back(xMinusY);
    args2.push_back(y);
    Value* recur_2 = builder.CreateCall(function, args2, "tmp");
    builder.CreateRet(recur_2);

    verifyFunction(*function);

    theModule->dump();

    return 0;
}
