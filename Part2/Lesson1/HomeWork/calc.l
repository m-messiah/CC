%{
#include <iostream>
#include "calc.tab.h"
%}
%option noyywrap

NUM     [0-9]*((\.|(e|E)(\+|\-)?)[0-9]+)?
%%
{NUM}   { sscanf(yytext,"%lg",&yylval);
          return NUM;   }
"+"     { return PLUS;  }
"-"     { return MINUS; }
"*"     { return MULT;  }
"/"     { return DIV;   }
"\n"    { return NL;    }
"^"     { return POW;   }
"("     { return LPAR;  }
")"     { return RPAR;  }
[ \t]*  {/* Do nothing*/}
":q"    { return EXIT;  }
%%
