%{
#include <iostream>
#include "defines.h"
%}

%option noyywrap
NUM     [0-9]*((\.|(e|E)(\+|\-)?)[0-9]+)?
char    [a-zA-Z_]
nchar   [a-zA-Z_0-9]

%%
{NUM}           { yylval.sval = new std::string(yytext);
                  return NUM;   }
"+"             { return PLUS;  }
"-"             { return MINUS; }
"*"             { return MULT;  }
"/"             { return DIV;   }
"let"           { return LET;   }
"\n"            { return NL;    }
"^"             { return POW;   }
"print"         { return PRINT; }
"read"          { return READ;  }
{char}{nchar}*  { yylval.sval = new std::string(yytext);
                    return ID;  }
"("             { return LPAR;  }
")"             { return RPAR;  }
[ \t]*          {/* Do nothing*/}
":q"            { return EXIT;  }
%%
