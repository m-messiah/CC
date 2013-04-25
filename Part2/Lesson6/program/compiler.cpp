#include <iostream>
#include "driver.hpp"
#include "llvm/Module.h"
#include "llvm/Bitcode/ReaderWriter.h"

int main(int argc, const char* argv[])
{
  Driver driver;

  for (++argv; argv[0]; ++argv) {
    if (*argv == std::string ("-p"))
      driver.trace_parsing = true;
    else if (*argv == std::string ("-s"))
      driver.trace_scanning = true;
    else if (!driver.parse(*argv)) {
      std::cout << "; AST: " << *driver.result << std::endl;
      Module* theModule = driver.result->codegen();
      std::string errorString;
      raw_fd_ostream bitcode((std::string(*argv) + ".bc").c_str(), errorString, 0);
      WriteBitcodeToFile(theModule, bitcode);
      bitcode.close();
    }
  }

  return 0;
}
