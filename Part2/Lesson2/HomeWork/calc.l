%{
#include <iostream>
#include "calc_defines.h"
%}

%option noyywrap

NUM     [0-9]*((\.|(e|E)(\+|\-)?)[0-9]+)?
char    [a-zA-Z_]
nchar   [a-zA-Z_0-9]

%%
{NUM}           { sscanf(yytext,"%lg",&yylval.dval);
                  return NUM;   }
"+"             { return PLUS;  }
"-"             { return MINUS; }
"*"             { return MULT;  }
"/"             { return DIV;   }
"="             { return EQ;    }
"\n"            { return NL;    }
"^"             { return POW;   }
"print"         { return PRINT; }
"read"          { return READ;  }
{char}{nchar}*  {   yylval.sval = new std::string(yytext);
                    return ID;  }
"("             { return LPAR;  }
")"             { return RPAR;  }
[ \t]*          {/* Do nothing*/}
":q"            { return EXIT;  }
%%
