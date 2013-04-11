Codegeneration with LLVM
========================

GCD


Домашнее задание
----------------

Написать программу кодогенерации для модуля, состоящего из

- функции вычисления квадратного корня бинарным поиском double bs_sqrt(double);
- функции main: print(bs_sqrt(2)).

Кусочек кода для записи байткода в файл
---------------------------------------

    std::string errorString;
    raw_fd_ostream bitcode("bsqrt.bc", errorString, 0);
    WriteBitcodeToFile(theModule, bitcode);
    bitcode.close();
