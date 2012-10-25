grammar calc;

calc	: lines EOF ;

lines	: summ NL {System.out.println();} (lines)? ;

summ	: mult (op=(PLUS | MINUS)mult {System.out.print($op.text+" ");} )* ;

mult	: power (op=(MULT | DIV) power {System.out.print($op.text+" ");} )* 	;

power 	: factor (op=POW power {System.out.print($op.text+" ");} )? ;

factor	: op=(PLUS | MINUS) {System.out.print($op.text);} factor | atom ;

atom	: num=(INT | FLOAT) {System.out.print($num.text+" "); } | LPAR summ RPAR ;

INT	: '0'..'9'+ ;

FLOAT :   ('0'..'9')+ '.' ('0'..'9')* EXPONENT?    |   '.' ('0'..'9')+ EXPONENT?    |   ('0'..'9')+ EXPONENT    ;

EXPONENT : ('e'|'E') ('+'|'-')? ('0'..'9')+ ; 

PLUS	: '+'	;

MINUS	: '-'	;

MULT	: '*'	;

DIV	: '/'	;

POW	: '^'	;

LPAR    : '('    ;

RPAR    : ')'    ;

NL	: '\r'? '\n'	;

WHITESPACE	: ('\t'|' '|'\u000C')+ { $channel = HIDDEN; }	;
