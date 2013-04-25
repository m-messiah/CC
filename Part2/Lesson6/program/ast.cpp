#include "ast.hpp"
#include <iostream>

Value* errorV(const char *str)
{
  std::cerr << str << std::endl;
  return 0;
}

Function* errorF(const char *str)
{
  std::cerr << str << std::endl;
  return 0;
}
