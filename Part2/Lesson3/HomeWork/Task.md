Домашнее задание
================

Взяв за основу калькулятор на flex + bison + C++, необходимо построить AST,
которое затем отобразить в строковом виде.

Например, по входу
    a = 1 + 2 * 3
    b = a * 2
    a + b

построить

    ((= a (+ 1 (* 2 3)))
    (= b (* a 2))
    (+ a b)
    )
