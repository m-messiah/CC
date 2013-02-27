tree grammar calcTree;

options {
    tokenVocab=calc;
    ASTLabelType=CommonTree;
    output=template;
}

@header {
    import java.util.Hashtable;
}

@members {
    Hashtable<String,Integer> variables = new Hashtable<String,Integer>();
    int inc=3;
    int index = 0;
    int stack = 0;
    int s=0;
}

calc
    : (e+=expr)+ -> calc(e={$e},i={inc},s={s})
    ;

expr 
    : ^(PLUS e1=expr (e2=expr {stack-=2;})?) -> add(e1={$e1.st},e2={$e2.st})
    | ^(MINUS e1=expr (e2=expr {stack-=2;})?) -> sub(e1={$e1.st},e2={$e2.st})
    | ^(MULT e1=expr e2=expr {stack-=2;}) -> mul(e1={$e1.st},e2={$e2.st})
    | ^(DIV e1=expr e2=expr {stack-=2;}) -> div(e1={$e1.st},e2={$e2.st})
    | ^(POW e1=expr e2=expr {stack-=2;}) -> pow(e1={$e1.st},e2={$e2.st})
    | FLOAT {stack+=2; if(stack>=s) s=stack;} -> number(n={$FLOAT.text})
    | INT {stack+=2; if(stack>=s) s=stack;}-> inumber(n={$INT.text})
    | ^(EQ VAR e2=expr)    { if (variables.containsKey($VAR.text)) {
                index=variables.get($VAR.text);
                variables.put($VAR.text,index);
            }
            else {
                variables.put($VAR.text,inc);
                index=inc;
                inc+=2;
            } stack-=2;} -> set(i={index}, e={$e2.st},v={$VAR.text})
    | ^(PRINT{stack+=1; if (stack>=s) s=stack;} e=expr) -> print(e={$e.st})
    | READ    {stack+=2;if (stack>=s) s=stack;} -> read()
    | VAR {if (variables.containsKey($VAR.text)) 
                        {index=variables.get($VAR.text); stack+=2;if (stack>=s) s=stack;}
                        else index=-1;
                } -> get(i={index},v={$VAR.text})
    ;
