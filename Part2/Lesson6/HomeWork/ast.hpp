#ifndef AST_H
#define AST_H

#include <ostream>
#include <sstream>
#include <vector>
#include <map>

#include "llvm/DerivedTypes.h"
#include "llvm/LLVMContext.h"
#include "llvm/Module.h"
#include "llvm/Analysis/Verifier.h"
#include "llvm/IRBuilder.h"

#include "llvm/Analysis/ProfileInfo.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

Value* errorV(const char *str);
Function* errorF(const char *str);

static IRBuilder<> builder(getGlobalContext());
static std::map<std::string, Value*> namedValues;

class HasToString
{
  virtual std::string toString() const = 0;

 public:
  friend std::ostream& operator<<(std::ostream& os, const HasToString& o)
  {
    os << o.toString();
    return os;
  }
};

class ValueNode
{
 public:
  virtual Value* codegen() const = 0;
};

class BasicBlockNode
{
 public:
  virtual BasicBlock* codegen() const = 0;
};

class ASTNode : public HasToString, public ValueNode
{
 public:
  virtual ~ASTNode() {}
};

class BlockASTNode : public ASTNode, public BasicBlockNode
{
  typedef std::vector<ASTNode*> Container;
  Container nodesList_;
 public:
  void append(ASTNode* node)
  {
    nodesList_.push_back(node);
  }

  size_t size() const
  {
    return nodesList_.size();
  }

  const ASTNode* operator[](size_t i) const
  {
    return nodesList_[i];
  }

  virtual ~BlockASTNode()
  {
    for (Container::const_iterator it = nodesList_.begin(); it != nodesList_.end(); ++it)
      delete *it; 
  }

  virtual std::string toString() const;
  virtual BasicBlock* codegen() const;
};

class NumberASTNode : public ASTNode, public ValueNode
{
  const double val_;
 public:
  NumberASTNode(double val) : val_(val) {}

  virtual std::string toString() const;
  virtual Value* codegen() const;
};

class VariableASTNode : public ASTNode, public ValueNode
{
  const std::string name_;
 public:
  VariableASTNode(const std::string& name) : name_(name) {}

  std::string getName() const
  {
    return name_;
  }

  virtual std::string toString() const;
  virtual Value* codegen() const;
};

class BinaryOpASTNode : public ASTNode, public ValueNode
{
  const char op_;
  const ASTNode* lhs_;
  const ASTNode* rhs_;
 public:
  BinaryOpASTNode(const char op, const ASTNode* lhs, const ASTNode* rhs) :
      op_(op),
      lhs_(lhs),
      rhs_(rhs)
  {
  }

  virtual ~BinaryOpASTNode()
  {
    delete lhs_;
    delete rhs_;
  }

  virtual std::string toString() const;
  virtual Value* codegen() const;
};

class PrintCallASTNode : public ASTNode, public ValueNode
{
  const ASTNode* param_;
 public:
  PrintCallASTNode(const ASTNode* param):
      param_(param)
  {
  }

  virtual ~PrintCallASTNode()
  {
    delete param_;
  }

  virtual std::string toString() const;
  virtual Value* codegen() const;
};

class UnitASTNode: public HasToString
{
  const BlockASTNode* statements_;
 public:
  UnitASTNode(const BlockASTNode* statements):
      statements_(statements)
  {
  }

  virtual ~UnitASTNode()
  {
    delete statements_;
  }

  virtual std::string toString() const;
  virtual Module* codegen() const;
};

#endif
