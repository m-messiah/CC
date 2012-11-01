grammar calc;

@header {
import java.lang.Integer;
import java.lang.Double;
import java.lang.Math;
import java.util.Hashtable;
}

@members {
Hashtable variables = new Hashtable();
double recent=0;
}

calc	: lines EOF 
	;

lines	: line NL {System.out.println();} (lines)? 
	;

line	: summ {System.out.println($summ.value);}
	;

summ returns [double value]: 
	m1=mult {$value=$m1.value;} 
	(PLUS m2=mult {$value+=$m2.value;} 
	| MINUS m2=mult {$value-=$m2.value;} )*
	;

mult returns [double value]:
	p1=power {$value=$p1.value;} 
	(MULT p2=power {$value*=$p2.value;} 
	| DIV p2=power {
		if ($p2.value!=0) 
			$value/=$p2.value; 
		else 
			System.err.println("ERROR: Division by zero");} )*
	;

power returns [double value]: 
	f1=factor {$value=$f1.value;} 
	(POW p2=power {$value=pow($value,$p2.value);} )? ;

factor returns [double value]:
	PLUS f1=factor {$value=$f1.value;}
	| MINUS f2=factor {$value=-$f2.value;}
	| atom {$value=$atom.value;}
	;

atom returns [double value]:
	num=(INT | FLOAT) {$value=Double.parseDouble($num.text); }
	| LPAR summ RPAR {$value=$summ.value;}
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
