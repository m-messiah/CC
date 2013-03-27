Flex + Bison
=============

Примеры
-------------

1. Example1 - RPN калькулятор на flex+bison+make 
2. Example2 - RPN калькулятор с переменными.
    * calc.l - Добавим два новых токена для переменных и присваивания.
    * calc.y - Добавим словарь variables, возможность сохранения имен переменных в %union, дополнительные токены и обработку переменных в грамматику.
    * Makefile - Добавим в Makefile создание calc.html и calc.xml с подробным описанием сгенерированного bison парсера.

Д/З
-------------

Компилятор из лямбда выражений с +, -, * , /, let, read, print в программу на языке C.

Пример входа (не обязательно делать в точности так, воспринимайте просто как иллюстрацию):
    (let ((a 1)(b (read))) (print (a) ))
    (let ((a (read))(b (+ 1 3 4))) (print (+ a b)))