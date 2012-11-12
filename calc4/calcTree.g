tree grammar calcTree;

options {
    tokenVocab=calc;
    ASTLabelType=CommonTree;
}

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

calc
    : ({correct=true;} expr {
			if (correct) {
                		variables.put("\$_", $expr.value);
		                System.out.println(variables.get("\$_"));}
			}
	)+
    ;

expr returns [double value]
    : ^(PLUS e1=expr  {$value = $e1.value;} (e2=expr {$value += $e2.value;})?)
    | ^(MINUS e1=expr {$value = -$e1.value;} (e2=expr {$value = -$value - $e2.value;})?)
    | ^(MULT e1=expr e2=expr)   {$value = $e1.value * $e2.value;}
    | ^(DIV e1=expr e2=expr)    {if ($e2.value!=0) 
					{$value = $e1.value / $e2.value;} 
				else {System.err.println("ERROR: Division by zero");
					correct=false;}
				}
    | ^(POW e1=expr e2=expr)	{$value = Math.pow($e1.value,$e2.value);}
    | FLOAT	{$value = Double.parseDouble($FLOAT.text);}
    | INT	{$value = Integer.parseInt($INT.text);}
    | ^(EQ VAR e2=expr)	{if (correct) {$value=$e2.value; variables.put($VAR.text, $e2.value);} else $value=-1;}
    | VAR {if (variables.containsKey($VAR.text))
                        $value=variables.get($VAR.text);
                else
                {System.err.println("ERROR: Undefined variable '"+$VAR.text+"'"); correct=false;} }
    ;
