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

    std::vector<Type*> params(1, Type::getDoubleTy(getGlobalContext()));
    FunctionType* functionType =
        FunctionType::get(builder.getVoidTy(), params, false);
    Function* function = Function::Create(functionType,
                                          Function::ExternalLinkage, "main",
                                          theModule);
    Function::arg_iterator args = function->arg_begin();
    Value* x = args++;
    x->setName("x");
    Function* function2 = Function::Create(functionType,
                                          Function::ExternalLinkage, "print",
                                          theModule);
    BasicBlock* entry = BasicBlock::Create(getGlobalContext(), "enter_main",
                                           function);
    BasicBlock* ret = BasicBlock::Create(getGlobalContext(), "return_main",
                                         function);
    BasicBlock* cycle = BasicBlock::Create(getGlobalContext(),
                                                "cycle", function);
    BasicBlock* cycle1 = BasicBlock::Create(getGlobalContext(),
                                                "cycle1", function);
    BasicBlock* left = BasicBlock::Create(getGlobalContext(),
                                                "left", function);
    BasicBlock* right = BasicBlock::Create(getGlobalContext(),
                                                "right",
                                               function);
    
    builder.SetInsertPoint(entry);
    Value* one = ConstantFP::get(getGlobalContext(), APFloat(1.0));
    Value* two = ConstantFP::get(getGlobalContext(), APFloat(2.0));
    Value* l = builder.CreateFMul(one, one, "l"); 
    Value* r = builder.CreateFMul(x, one, "r");
    Value* res;

    builder.SetInsertPoint(cycle);
    Value* lLessThanR = builder.CreateFCmpULE(l, r, "cont");
    builder.CreateCondBr(lLessThanR, cycle1, ret);

    builder.SetInsertPoint(cycle1);
    Value* m2 = builder.CreateFAdd(l, r, "m2");
    Value* m = builder.CreateFDiv(m2, two, "m");
    Value* mSquared = builder.CreateFMul(m, m, "mSquared");
    Value* mSqLessThanX = builder.CreateFCmpULE(mSquared, x, "tmp");
    builder.CreateCondBr(mSqLessThanX, left, right);

    builder.SetInsertPoint(left);
    res = builder.CreateFMul(m, one, "res");
    l = builder.CreateFAdd(m, one, "left");
    builder.CreateBr(cycle);

    builder.SetInsertPoint(right);
    r = builder.CreateFSub(m, one, "right");
    builder.CreateBr(cycle);
    
    builder.SetInsertPoint(ret);
    builder.CreateCall(function2, res, "print");
    
    verifyFunction(*function);
        
    theModule->dump();

    std::string errorString;
    raw_fd_ostream bitcode("bsqrt.bc", errorString, 0);
    WriteBitcodeToFile(theModule, bitcode);
    bitcode.close();

    return 0;
}
