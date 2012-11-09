tree grammar calcTree;

options {
    tokenVocab=calc;
    ASTLabelType=CommonTree;
}

@header {
    import java.lang.Integer;
    import java.lang.Math;
}

calc
    : (expr {System.out.println($expr.value);})+
    ;

expr returns [double value]
    : ^(PLUS e1=expr  {$value = $e1.value;} (e2=expr {$value += $e2.value;})?)
    | ^(MINUS e1=expr {$value = -$e1.value;} (e2=expr {$value = -$value - $e2.value;})?)
    | ^(MULT e1=expr e2=expr)   {$value = $e1.value * $e2.value;}
    | ^(DIV e1=expr e2=expr)    {$value = $e1.value / $e2.value;}
    | INT                    {$value = Integer.parseInt($INT.text);}
    ;
