tree grammar compilerTree;

options {
    tokenVocab=compiler;
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
	int s = 0;
    int lab = 0;
}

program :
	block -> program(e={$block.st},i={inc},s={s})
    ;

block	:
	^(END BEGIN (e+=line)+) -> block(e={$e})
	;

line	:
	   ^(IF orcond thn=block (els=block)? {lab+=1;}) -> iff(cond={$orcond.st},thn={$thn.st},els={$els.st},lab={lab})
	 | ^(EQ VAR e2=expr) { if (variables.containsKey($VAR.text)) {
                    index=variables.get($VAR.text);
                    variables.put($VAR.text,index);
                }
                else {
                    variables.put($VAR.text,inc);
                    index=inc;
                    inc+=2;
                } stack-=2;
            } -> set(i={index}, e={$e2.st},v={$VAR.text})
    | ^(PRINT e=expr {stack+=1; if (stack>=s) s=stack;}) -> print(e={$e.st})
	| expr -> {$expr.st}   
 ;


orcond	:
	^(OR b1=cond (b2=cond)?) -> or(b1={$b1.st},b2={$b2.st})
	| ^(AND b1=cond b2=cond) -> and(b1={$b1.st},b2={$b2.st})
	| ^(NOT b1=cond) -> not(b1={$b1.st})
	;

cond	:
	^(GE b1=expr (b2=expr)?) -> ge(b1={$b1.st},b2={$b2.st})
	| ^(GT b1=expr b2=expr) -> gt(b1={$b1.st},b2={$b2.st})
	| ^(LE b1=expr b2=expr) -> le(b1={$b1.st},b2={$b2.st})
	| ^(LT b1=expr b2=expr) -> lt(b1={$b1.st},b2={$b2.st})
	| ^(EQ b1=expr b2=expr {lab+=1;}) -> eq(b1={$b1.st},b2={$b2.st},lab={lab})
	| ^(NE b1=expr b2=expr {lab+=1;}) -> ne(b1={$b1.st},b2={$b2.st},lab={lab})
	;

expr	:
	 ^(PLUS  e1=expr (e2=expr {stack-=2;})?) -> add(e1={$e1.st},e2={$e2.st})
    | ^(MINUS e1=expr (e2=expr {stack-=2;})?) -> sub(e1={$e1.st},e2={$e2.st})
    | ^(MULT  e1=expr e2=expr {stack-=2;}) -> mul(e1={$e1.st},e2={$e2.st})
    | ^(DIV   e1=expr e2=expr {stack-=2;}) -> div(e1={$e1.st},e2={$e2.st})
    | ^(POW   e1=expr e2=expr {stack-=2;}) -> pow(e1={$e1.st},e2={$e2.st})
	| FLOAT {stack+=2; if(stack>=s) s=stack;} -> number(n={$FLOAT.text})
    | INT   {stack+=2; if(stack>=s) s=stack;} -> inumber(n={$INT.text})
	| READ	{stack+=2;if (stack>=s) s=stack;} -> read()
    | VAR   {if (variables.containsKey($VAR.text)) 
                        {index=variables.get($VAR.text); stack+=2;if (stack>=s) s=stack;}
			} -> get(i={index},v={$VAR.text})
	;
