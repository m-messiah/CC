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
    std::vector<Type*> params2(2, Type::getDoubleTy(getGlobalContext()));
    FunctionType* functionType =
        FunctionType::get(builder.getVoidTy(), params, false);
    FunctionType* functionType2 =
        FunctionType::get(builder.getVoidTy(), params2, false);
    Function* function = Function::Create(functionType2,
                                          Function::ExternalLinkage, "main",
                                          theModule);
    Function::arg_iterator args = function->arg_begin();
    Value* x = args++;
    x->setName("x");
    Function* print = Function::Create(functionType,
                                          Function::ExternalLinkage, "print",
                                          theModule);
    BasicBlock* entry = BasicBlock::Create(getGlobalContext(), "enter_main",
                                           function);
    BasicBlock* cycle = BasicBlock::Create(getGlobalContext(),
                                                "cycle", function);
    BasicBlock* cycle1 = BasicBlock::Create(getGlobalContext(),
                                                "cycle1", function);
    BasicBlock* cycle2 = BasicBlock::Create(getGlobalContext(),
                                                "cycle2", function);
    BasicBlock* left = BasicBlock::Create(getGlobalContext(),
                                                "left", function);
    BasicBlock* right = BasicBlock::Create(getGlobalContext(),
                                                "right",
                                               function);
    BasicBlock* ret = BasicBlock::Create(getGlobalContext(), "return_main",
                                         function);
    
    builder.SetInsertPoint(entry);
    builder.CreateCall(print, x);
    Value* zero = ConstantFP::get(getGlobalContext(), APFloat(0.0));
    Value* one = ConstantFP::get(getGlobalContext(), APFloat(1.0));
    Value* two = ConstantFP::get(getGlobalContext(), APFloat(2.0));

    Value* l = builder.CreateFSub(x, x, "l"); 
    Value* r = builder.CreateFAdd(x, zero, "r");
    Value* res;
    builder.CreateBr(cycle);

    builder.SetInsertPoint(cycle);
    Value* lLessThanR = builder.CreateFCmpULE(l, r, "cont");
    builder.CreateCondBr(lLessThanR, cycle1, ret);

    builder.SetInsertPoint(cycle1);
    Value* lR = builder.CreateFSub(r, l, "lR");
    Value* lRBig = builder.CreateFCmpULE(zero, lR, "cont1");
    builder.CreateCondBr(lRBig, cycle2, ret);

    builder.SetInsertPoint(cycle2);
    Value* m2 = builder.CreateFAdd(l, r, "m2");
    Value* m = builder.CreateFDiv(m2, two, "m");
    Value* mSquared = builder.CreateFMul(m, m, "mSquared");
    Value* mSqLessThanX = builder.CreateFCmpULE(mSquared, x, "tmp");
    builder.CreateCondBr(mSqLessThanX, left, right);

    builder.SetInsertPoint(left);
    res = builder.CreateFMul(m, one, "res");
    builder.CreateCall(print, res);
    l = builder.CreateFAdd(m, one, "left");
    builder.CreateBr(cycle);

    builder.SetInsertPoint(right);
    res = builder.CreateFMul(m, one, "res");
    builder.CreateCall(print, res);
    r = builder.CreateFSub(m, one, "right");
    builder.CreateBr(cycle);
    
    builder.SetInsertPoint(ret);
    //builder.CreateCall(print, res);
    builder.CreateRetVoid();
    
    
    verifyFunction(*function);
        
    theModule->dump();

    std::string errorString;
    raw_fd_ostream bitcode("bsqrt.bc", errorString, 0);
    WriteBitcodeToFile(theModule, bitcode);
    bitcode.close();

    return 0;
}
