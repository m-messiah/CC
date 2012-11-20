grammar calc;

options {
	output=AST;
}

calc	: lines EOF!
	;

lines	: line NL! (lines)? 
	;

line	: expr
	| PRINT^ expr
	;

expr	:
	mult ((PLUS^ | MINUS^) mult)*
	| VAR EQ^ expr 
	| NL!
	;

mult	: power ((MULT | DIV)^ power)*
	;

power	: factor (POW^ power)? ;

factor	: 
	(PLUS | MINUS)^ factor
	| atom
	;

atom	: INT 
	| FLOAT
	| VAR
	| LPAR expr RPAR -> ^(expr)
	;


PRINT	: 'p''r''i''n''t'
	;

VAR	: ('A'..'Z' | 'a'..'z' | '_' | '$' ) ('A'..'Z' | 'a'..'z' | '0'..'9' | '_' )*
	;
 
INT	: '0'..'9'+ ;

FLOAT	: ('0'..'9')+ '.' ('0'..'9')* (('e'|'E') ('+'|'-')? ('0'..'9')+)?
	| '.' ('0'..'9')+ (('e'|'E') ('+'|'-')? ('0'..'9')+)?
	| ('0'..'9')+ (('e'|'E') ('+'|'-')? ('0'..'9')+)
	;

EQ	: '='
	| ':''='
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
