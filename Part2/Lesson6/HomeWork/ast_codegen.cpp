#include "ast.hpp"
#include <iostream>

Function* mainFunction;
Function* printFunction;

BasicBlock* BlockASTNode::codegen() const
{
  BasicBlock *bb = BasicBlock::Create(getGlobalContext(), "bb", mainFunction);
  builder.SetInsertPoint(bb);
  for (Container::const_iterator it = nodesList_.begin();
       it != nodesList_.end();
       ++it)
    (*it)->codegen();
  return bb;
}

Value* NumberASTNode::codegen() const
{
  return ConstantFP::get(getGlobalContext(), APFloat(val_));
}

Value* VariableASTNode::codegen() const
{
  Value* v = namedValues[name_];
  return v ? v : errorV((std::string("Unknown variable name: ") + name_).c_str());
}

Value* BinaryOpASTNode::codegen() const
{
  Value* l;
  if (op_ != '=')
    l = lhs_->codegen();
  Value* r = rhs_->codegen();
  if (r == 0 || (op_ != '=' && l == 0)) return 0;

  if (op_ == '+')
    return builder.CreateFAdd(l, r, "addtmp");
  else if (op_ == '-')
    return builder.CreateFSub(l, r, "subtmp");
  else if (op_ == '*')
    return builder.CreateFMul(l, r, "multmp");
  else if (op_ == '/')
    return builder.CreateFDiv(l, r, "divtmp");
  else if (op_ == '=') {
    std::string varName(static_cast<const VariableASTNode*>(lhs_)->getName());
    AllocaInst* l_var = builder.CreateAlloca(
        Type::getDoubleTy(getGlobalContext()), 0, "alloca_" + varName); 
    builder.CreateStore(r, l_var);
    namedValues[varName] = builder.CreateLoad(l_var, "var_" + varName); 
    return namedValues[varName];
  } else
    return errorV("invalid binary operator");
}

Value* PrintCallASTNode::codegen() const
{
  std::vector<Value*> args(1, param_->codegen());
  return builder.CreateCall(printFunction, args);
}

Module* UnitASTNode::codegen() const
{
  Module* theModule = new Module("myModule", getGlobalContext());

  {
    std::vector<Type*> params(1, Type::getDoubleTy(getGlobalContext()));
    FunctionType* functionType = FunctionType::get(Type::getVoidTy(getGlobalContext()), params, false);
    printFunction = Function::Create(functionType, Function::ExternalLinkage, "print",
                                     theModule);
  }

  {
    std::vector<Type*> params;
    FunctionType* functionType =
        FunctionType::get(Type::getInt32Ty(getGlobalContext()), params, false);
    mainFunction = Function::Create(functionType, Function::ExternalLinkage, "main",
                                    theModule);
  }

  statements_->codegen();

  builder.SetInsertPoint(&mainFunction->back());
  Value* res = ConstantInt::get(getGlobalContext(), APInt(32, 0)); 
  builder.CreateRet(res);
  theModule->dump();
  return theModule;
}
