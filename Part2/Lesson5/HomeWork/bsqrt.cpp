#include "llvm/LLVMContext.h"
#include "llvm/Module.h"
#include "llvm/Analysis/Verifier.h"
#include "llvm/IRBuilder.h"
#include <vector>
#include <llvm/Support/raw_ostream.h>
#include <llvm/Bitcode/ReaderWriter.h>

int main(int argc, const char* argv[])
{
    using namespace llvm;

    IRBuilder<> builder(getGlobalContext());
    Module* theModule = new Module("module.1", getGlobalContext());

    std::vector<Type*> params(0, Type::getInt32Ty(getGlobalContext()));
    FunctionType* functionType =
        FunctionType::get(Type::getInt32Ty(getGlobalContext()), params, false);
    Function* function = Function::Create(functionType,
                                          Function::ExternalLinkage, "main",
                                          theModule);
    std::vector<Type*> param2(1, Type::getDoubleTy(getGlobalContext()));
    FunctionType* functionType2 =
        FunctionType::get(Type::getDoubleTy(getGlobalContext()), param2, false);
    Function* function2 = Function::Create(functionType,
                                          Function::ExternalLinkage, "bsqrt",
                                          theModule);
    Function::arg_iterator args = function2->arg_begin();
    Value* x = args++;
    x->setName("x");

    BasicBlock* entry = BasicBlock::Create(getGlobalContext(), "enter_main",
                                           function);
    BasicBlock* entry_bsqrt = BasicBlock::Create(getGlobalContext(), "enter_bsqrt",
                                           function2);
    BasicBlock* ret = BasicBlock::Create(getGlobalContext(), "return_main",
                                         function);
    BasicBlock* ret2 = BasicBlock::Create(getGlobalContext(), "return_bsqrt",
                                         function2);
    BasicBlock* cond_false = BasicBlock::Create(getGlobalContext(),
                                                "if_false", function2);
    BasicBlock* cond_true = BasicBlock::Create(getGlobalContext(), "cond_true",
                                               function2);
    BasicBlock* cond_false_2 = BasicBlock::Create(getGlobalContext(),
                                                  "cond_false2", function2);
    BasicBlock* display = BasicBlock::Create(getGlobalContext(), "print", function);

    builder.SetInsertPoint(entry);
    builder.CreateRet(0);
    builder.SetInsertPoint(display);
    std::vector<Value*> args1;
    args1.push_back(x);
    Value* bi_sqrt = builder.CreateCall(function, args1, "bin_bsqrt");
    builder.CreateRet(bi_sqrt);
    /*builder.SetInsertPoint(cond_false);
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
    */
    verifyFunction(*function);
    
    
    theModule->dump();

    std::string errorString;
    raw_fd_ostream bitcode("gcd.bc", errorString, 0);
    WriteBitcodeToFile(theModule, bitcode);
    bitcode.close();

    return 0;
}
