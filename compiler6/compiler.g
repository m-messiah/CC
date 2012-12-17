grammar compiler;

options {
	output=AST;
}

program :
	block NL? EOF!
	;

block	:
	BEGIN lines END^
	;

lines	:
	line NL! (lines)?
	;

line	:
	expr
	| PRINT^ expr
	| VAR EQ^ expr
	| IF^ LPAR! orcond RPAR! (NL!)? block ((NL!)? ELSE! block)?
	|
	;

orcond	:
	andcond (OR^ andcond)*
	;

andcond	:
	onecond (AND^ onecond)*
	;

onecond :
	NOT^ onecond
	| cond
	;

cond	:
	expr ((GE^ | GT^ | LE^ | LT^ | NE^ | EQ^) expr)?
	;

expr	:
	mult ((PLUS^ | MINUS^) mult)*
	| READ
	;

mult	:
	power ((MULT | DIV)^ power)*
	;

power	:
	factor (POW^ power)?
	;

factor	:
	(PLUS | MINUS)^ factor
	| atom
	;

atom	:
	  INT
	| FLOAT
	| VAR
	| LPAR expr RPAR -> expr
	;


PRINT	:
	'p''r''i''n''t'
	;

READ	: 'r''e''a''d'
	;

IF	: 'i''f'
	;

ELSE : 'e''l''s''e'
	;

VAR	: ('A'..'Z' | 'a'..'z' | '_' | '$' ) ('A'..'Z' | 'a'..'z' | '0'..'9' | '_' )*
	;
 
INT	: '0'..'9'+ ;

FLOAT	: ('0'..'9')+ '.' ('0'..'9')* (('e'|'E') ('+'|'-')? ('0'..'9')+)?
	| '.' ('0'..'9')+ (('e'|'E') ('+'|'-')? ('0'..'9')+)?
	| ('0'..'9')+ (('e'|'E') ('+'|'-')? ('0'..'9')+)
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

OR	: '|''|'
	;

AND	: '&''&'
	;

NOT	: '!'
	;

LE	: '<''='
	;

LT	: '<'
	;

GE	: '>''='
	;

GT	: '>'
	;

EQ	: '='
	;

NE	: '!''='
	;

LPAR    : '('
	;

RPAR    : ')'
	;

BEGIN	: '{'
	;

END	: '}'
	;

NL	: '\r' | '\n'
	;

WHITESPACE : ('\t'|' '|'\u000C')+ { $channel = HIDDEN; }
	;
