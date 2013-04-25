#include "ast.hpp"

std::string BlockASTNode::toString() const
{
  std::ostringstream oss;
  oss << "(";
  for (Container::const_iterator it = nodesList_.begin(); it != nodesList_.end(); ++it)
    oss << **it << " ";
  oss << ")";
  return oss.str();
}

std::string NumberASTNode::toString() const
{
  std::ostringstream oss;
  oss << val_;
  return oss.str();
}

std::string VariableASTNode::toString() const
{
  std::ostringstream oss;
  oss << name_;
  return oss.str();
}

std::string BinaryOpASTNode::toString() const
{
  std::ostringstream oss;
  oss << "(" << op_ << " " << *lhs_ << " " << *rhs_ << ")";
  return oss.str();
}

std::string PrintCallASTNode::toString() const
{
  std::ostringstream oss;
  oss << "(print " << *param_ << ")";
  return oss.str();
}

std::string UnitASTNode::toString() const
{
  std::ostringstream oss;
  oss << "(unit " << *statements_ << ")";
  return oss.str();
}
