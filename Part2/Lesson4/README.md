LLVM Tools
==========

clang
-----

Что можно сделать с исходником?
(да кучу всего)))

Кодогенерация
-------------

Научимся генерировать код для функции

    double one()
    {
        return 1.0;
    }

А one.cpp - как сгенерировать такую функцию с помощью llvm

Если запустить получившийся исполняемый файл, то выведется:
    ; ModuleID = 'module.1'

    define double @one() {
    entry:
      ret double 1.000000e+00
    }


Теперь рассмотрим более интересную функцию:

    double inc(double x)
    {
        return x + 1.0;
    }

Результат запуска ./inc:
    ; ModuleID = 'module.1'
    
    define double @inc(double %x) {
    entry:
      %addtmp = fadd double %x, 1.000000e+00
      ret double %addtmp
    }

Документация
------------

- [Основной сайт](http://llvm.org)
- [Вся документация](http://llvm.org/docs/)
- [Документация на внутренний язык llvm](http://llvm.org/docs/LangRef.html)
- [Документация для программистов, использующих llvm](http://llvm.org/docs/ProgrammersManual.html)
