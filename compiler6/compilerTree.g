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
	 | ^(ASSIGN VAR e2=orcond) { if (variables.containsKey($VAR.text)) {
                    index=variables.get($VAR.text);
                    variables.put($VAR.text,index);
                }
                else {
                    variables.put($VAR.text,inc);
                    index=inc;
                    inc+=2;
                } stack-=2;
            } -> set(i={index}, e={$e2.st},v={$VAR.text})
    | ^(PRINT e=orcond {stack+=1; if (stack>=s) s=stack;}) -> print(e={$e.st})
	| orcond -> {$orcond.st}   
    ;


orcond	:
	^(OR b1=orcond (b2=orcond)?) -> or(b1={$b1.st},b2={$b2.st})
	| ^(AND b1=orcond b2=orcond) -> and(b1={$b1.st},b2={$b2.st})
	| ^(NOT b1=orcond {stack+=1; if (stack>=s) s=stack;}) -> not(b1={$b1.st})
    | ^(GE b1=orcond b2=orcond) -> ge(b1={$b1.st},b2={$b2.st})
	| ^(GT b1=orcond b2=orcond {lab+=1; stack+=2; if (stack>=s) s=stack;}) -> gt(b1={$b1.st},b2={$b2.st},lab={lab})
	| ^(LE b1=orcond b2=orcond) -> le(b1={$b1.st},b2={$b2.st})
	| ^(LT b1=orcond b2=orcond {lab+=1;}) -> lt(b1={$b1.st},b2={$b2.st},lab={lab})
	| ^(EQ b1=orcond b2=orcond {lab+=1;stack+=1; if (stack>=s) s=stack;}) -> eq(b1={$b1.st},b2={$b2.st},lab={lab})
	| ^(NE b1=orcond b2=orcond {lab+=1;}) -> ne(b1={$b1.st},b2={$b2.st},lab={lab})
	| ^(PLUS  e1=orcond (e2=orcond {stack-=2;})?) -> add(e1={$e1.st},e2={$e2.st})
    | ^(MINUS e1=orcond (e2=orcond {stack-=2;})?) -> sub(e1={$e1.st},e2={$e2.st})
    | ^(MULT  e1=orcond e2=orcond {stack-=2;}) -> mul(e1={$e1.st},e2={$e2.st})
    | ^(DIV   e1=orcond e2=orcond {stack-=2;}) -> div(e1={$e1.st},e2={$e2.st})
    | ^(POW   e1=orcond e2=orcond {stack-=2;}) -> pow(e1={$e1.st},e2={$e2.st})
	| FLOAT {stack+=2; if(stack>=s) s=stack;} -> number(n={$FLOAT.text})
    | INT   {stack+=2; if(stack>=s) s=stack;} -> inumber(n={$INT.text})
	| READ	{stack+=2;if (stack>=s) s=stack;} -> read()
    | VAR   {if (variables.containsKey($VAR.text)) 
                        {index=variables.get($VAR.text); stack+=2;if (stack>=s) s=stack;}
			} -> get(i={index},v={$VAR.text})
	;
