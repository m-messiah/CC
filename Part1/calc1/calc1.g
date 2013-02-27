#Antlr3 grammar
grammar calc1;
# Constracts a tree for given arithmetic expression. 
# Supports addition, substraction, multiplication, division and exponentiation
# Supports integers anf float (in normal form and in exponential form)

input : expr EOF;

expr : (term) (('+'|'-') term)* ;

term : (power) (('*'|'/') power)* ;

power 	: atom (POW power)?;

factor : ('+' | '-') factor | atom ;

atom : INT | FLOAT | '(' expr ')';

INT : '0'..'9'+ ;

POW 	: '^' ;

WS : ( ' ' | '\t' | '\r' | '\n' ) {$channel=HIDDEN;};

FLOAT :   ('0'..'9')+ '.' ('0'..'9')* EXPONENT?
    |   '.' ('0'..'9')+ EXPONENT?
    |   ('0'..'9')+ EXPONENT
    ;

EXPONENT : ('e'|'E') ('+'|'-')? ('0'..'9')+ ; 

