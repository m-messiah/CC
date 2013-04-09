#include "llvm/DerivedTypes.h"
#include "llvm/BasicBlock.h"
#include "llvm/LLVMContext.h"
#include "llvm/Module.h"
#include "llvm/Analysis/Verifier.h"
#include "llvm/IRBuilder.h"
#include <string>
#include <vector>
#include <iostream>

int main(int argc, const char* argv[])
{
    using namespace llvm;

    IRBuilder<> builder(getGlobalContext());
    Module* module = new Module("module.1", getGlobalContext());

    std::vector<Type*> doubles(1, Type::getDoubleTy(getGlobalContext()));
    FunctionType* functionType = 
        FunctionType::get(Type::getDoubleTy(getGlobalContext()), doubles, false);
    Function* function = 
        Function::Create(functionType, Function::ExternalLinkage, "inc", module);
    function->arg_begin()->setName("x");

    BasicBlock* bb = BasicBlock::Create(getGlobalContext(), "entry", function);
    builder.SetInsertPoint(bb);
    Value* d = ConstantFP::get(getGlobalContext(), APFloat(1.0)); 
    Value* inc = builder.CreateFAdd(function->arg_begin(), d, "addtmp");
    builder.CreateRet(inc);

    verifyFunction(*function);

    verifyModule(*module);

    module->dump();

    return 0;
}
