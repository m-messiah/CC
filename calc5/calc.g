grammar calc;

options {
	output =  template;
}

input	: (ls+=line NL)+ EOF -> lines(ls={$ls})
	;

line	: VAR '=' s1=sum -> create(v1={$VAR.text}, s1={$s1.st}) 
	| PRINT s=sum -> print(s={$s.st})
	| s=sum -> calculate(s={$s.st})
	| NL
	;

sum	: m1=multip ( PLUS  m2=sum | MINUS m3=sum)? -> sum(m1={$m1.st},m2={$m2.st},m3={$m3.st})
 	;

multip	: p+=power ( MULT p+=power )* -> multip(p={$p})
	;

power	: f1=factor (POW p2=power )? -> power(f1={$f1.st},p2={$p2.st})
 	;

factor	: PLUS f1=factor -> {$f1.st}
	| MINUS f2=factor -> negat(f={$f2.st}) 
	| a=atom -> atom(a={$a.st})
	;

atom	: INT -> number(n={$INT.text})
	| FLOAT -> number(n={$FLOAT.text})
	| VAR -> get(v={$VAR.text})
	| LPAR sum RPAR -> {$sum.st}
	;


PRINT	: 'p''r''i''n''t'
	;

VAR	: ('A'..'Z' | 'a'..'z' | '_' | '$' ) ('A'..'Z' | 'a'..'z' | '0'..'9' | '_' )*
	;
 
INT	: '0'..'9'+ ;

FLOAT	: ('0'..'9')+ '.' ('0'..'9')* EXPONENT?
	| '.' ('0'..'9')+ EXPONENT?
	| ('0'..'9')+ EXPONENT
	;

EXPONENT : ('e'|'E') ('+'|'-')? ('0'..'9')+
	; 

PLUS	: '+'
	;

MINUS	: '-'
	;

MULT	: '*'
	;

DIV	: '/'
	;

POW	: '^'
	;

LPAR    : '('
	;

RPAR    : ')'
	;

NL	: '\r' | '\n'
	;

WHITESPACE : ('\t'|' '|'\u000C')+ { $channel = HIDDEN; }
	;
