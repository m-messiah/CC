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
	| init
	| IF^ LPAR! orcond RPAR! (NL!)? block ((NL!)? ELSE! block)?
	| WHILE^ LPAR! orcond RPAR! (NL)? block
	| DO^ (NL)? block (NL)? WHILE! LPAR! orcond RPAR!
	| FOR^ LPAR! (init)? SEP! (orcond)? SEP! (init)? RPAR! (NL!)? block
	|
	;

init    :
    VAR ASSIGN^ expr
    | VAR INCR^
    | VAR DECR^
    ;


orcond	:
	andcond (OR^ andcond)*
	;

andcond	:
	onecond (AND^ onecond)*
	;

onecond :
	NOT^ onecond
    | BLPAR orcond BRPAR -> orcond
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
	'print'
	;

READ	: 'read'
	;

IF	: 'if'
	;

ELSE : 'else'
	;

WHILE : 'while'
    ;

DO  : 'do'
    ;

FOR : 'for'
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

DECR    : '--'
    ;

INCR    : '++'
    ;

OR	: '||'
	;

AND	: '&&'
	;

NOT	: '!'
	;

LE	: '<='
	;

LT	: '<'
	;

GE	: '>='
	;

GT	: '>'
	;

EQ	: '=='
	;

ASSIGN  : '='
    ;

NE	: '!='
	;

BLPAR    : '['
	;

BRPAR    : ']'
	;


LPAR    : '('
	;

RPAR    : ')'
	;

BEGIN	: '{'
	;

END	: '}'
	;

SEP : ';'
    ;

NL	: '\r' | '\n'
	;

WHITESPACE : ('\t'|' '|'\u000C')+ { $channel = HIDDEN; }
	;
