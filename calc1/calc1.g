
grammar calc1;

input : expr EOF;

expr : (term) (('+'|'-') term)* ;

term : (power) (('*'|'/') power)* ;

power 	: atom (POW power)?;

factor : ('+' | '-') factor | atom ;

atom : INT | FLOAT | '(' expr ')';

INT : '0'..'9'+ ;

POW 	: '^' ;

WS : ( ' ' | '\t' | '\r' | '\n' ) {$channel=HIDDEN;};//Игнорируй такие токены. то есть распознавай, но ничего не делай

FLOAT :   ('0'..'9')+ '.' ('0'..'9')* EXPONENT?
    |   '.' ('0'..'9')+ EXPONENT?
    |   ('0'..'9')+ EXPONENT
    ;

EXPONENT : ('e'|'E') ('+'|'-')? ('0'..'9')+ ; 

