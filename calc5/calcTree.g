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
	int inc=-2;
	int index = 0;
}

calc
    : (e+=expr)+ -> calc(e={$e},i={inc})
    ;

expr 
    : ^(PLUS e1=expr (e2=expr)?) -> add(e1={$e1.st},e2={$e2.st})
    | ^(MINUS e1=expr (e2=expr)?) -> sub(e1={$e1.st},e2={$e2.st})
    | ^(MULT e1=expr e2=expr) -> mul(e1={$e1.st},e2={$e2.st})
    | ^(DIV e1=expr e2=expr) -> div(e1={$e1.st},e2={$e2.st})
    | ^(POW e1=expr e2=expr) -> pow(e1={$e1.st},e2={$e2.st})
	| FLOAT	-> number(n={$FLOAT.text})
    | INT -> inumber(n={$INT.text})
    | ^(EQ VAR e2=expr)	{ if (variables.containsKey($VAR.text)) {
				index=variables.get($VAR.text);
				variables.put($VAR.text,index);
			}
			else {
				inc+=2;
				variables.put($VAR.text,inc);
			} } -> set(i1={index},i2={inc}, e={$e2.st},v={$VAR.text})
	| ^(PRINT e=expr) -> print(e={$e.st})
    | VAR {if (variables.containsKey($VAR.text))
                        index=variables.get($VAR.text); } -> get(i={index},v={$VAR.text})
    ;
