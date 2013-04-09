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

    std::vector<Type*> noParams;
    FunctionType* functionType = 
        FunctionType::get(Type::getDoubleTy(getGlobalContext()), noParams, false);
    Function* function = 
        Function::Create(functionType, Function::ExternalLinkage, "one", theModule);

    BasicBlock* bb = BasicBlock::Create(getGlobalContext(), "entry", function);
    builder.SetInsertPoint(bb);
    Value* d = ConstantFP::get(getGlobalContext(), APFloat(1.0)); 
    builder.CreateRet(d);

    verifyFunction(*function);

    theModule->dump();

    return 0;
}
