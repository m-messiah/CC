grammar calc;

@header {
import java.lang.Integer;
import java.lang.Double;
import java.lang.Math;
import java.util.Hashtable;
}

@members {
Hashtable<String,Double> variables = new Hashtable<String,Double>();
boolean correct=true;
}

calc	: lines EOF 
	;

lines	: {correct=true;} line NL (lines)? 
	;

line	: VAR '=' summ {if (correct) variables.put($VAR.text, $summ.value);} 
	| PRINT summ {if (correct) System.out.println($summ.value);}
	| summ { if (correct) { 
		variables.put("__RECENT__",$summ.value); 
		System.out.println(variables.get("__RECENT__"));} }

	| NL
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
			{System.err.println("ERROR: Division by zero");
			correct=false;
			}
		} )*
	;

power returns [double value]: 
	f1=factor {$value=$f1.value;} 
	(POW p2=power {$value=Math.pow($value,$p2.value);} )? ;

factor returns [double value]:
	PLUS f1=factor {$value=$f1.value;}
	| MINUS f2=factor {$value=-$f2.value;}
	| atom {$value=$atom.value;}
	;

atom returns [double value]:
	num=(INT | FLOAT) {$value=Double.parseDouble($num.text); }
	| VAR {if (variables.containsKey($VAR.text)) 
			$value=variables.get($VAR.text); 
		else 
		{System.err.println("ERROR: Undefined variable '"+$VAR.text+"'"); correct=false;} }
	| LPAR summ RPAR {$value=$summ.value;}
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
