%code requires {
    #include <string>
}

%code{
    #include <stdio.h>
    #include <ctype.h>
    #include <math.h>
    #include <map>
    int yylex(void);
    int yyparse(void);
    void yyerror(char const *);

    std::map<std::string, double> variables;
    char buff[1000];
}

/*%debug
%error-verbose*/

%defines "defines.h"

%union {
    double dval;
    std::string* sval;
}

%token <sval> NUM
%token <sval> ID
%type  <sval> exp adds mults assign
%token PLUS MINUS MULT DIV POW
%token NL LPAR RPAR LET READ PRINT EXIT

%left PLUS MINUS
%left MULT DIV
%left NEG
%right POW
%%
file    : input { printf("\treturn 0;\n}\n");}
        ;

input   : /* empty */ { printf("#include <stdio.h>\n\nint main() {\n");}
        | input line 
        ;

line    : NL 
        | exp NL { printf("%s\n", $1->c_str()); }
        | EXIT {   printf("%s\n","Recieved EXIT signal"); return 0; }
        ;

assign  : LPAR ID exp RPAR {sprintf(buff,"\tdouble %s =%s;\n", $2->c_str(), $3->c_str()); $$ = new std::string(buff);}
        | assign LPAR ID exp RPAR {sprintf(buff, "%s\tdouble %s =%s;\n", $1->c_str(), $3->c_str(), $4->c_str()); $$ = new std::string(buff);}
        ;

adds    : exp exp { sprintf(buff," %s + %s", $1->c_str(), $2->c_str()); $$ = new std::string(buff);}
        | adds exp { sprintf(buff," %s + %s", $1->c_str(), $2->c_str()); $$ = new std::string(buff); }
        ;

mults   : exp exp { sprintf(buff, " %s * %s", $1->c_str(), $2->c_str()); $$ = new std::string(buff); }
        | mults exp { sprintf(buff, " %s * %s", $1->c_str(), $2->c_str()); $$ = new std::string(buff); }
        ;

exp     : NUM {sprintf(buff, "%s", $1->c_str()); $$ = new std::string(buff); } 
        | ID {sprintf(buff, "%s", $1->c_str()); $$ = new std::string(buff); } 
        | LPAR READ ID RPAR { sprintf(buff, "\tdouble %s;\n\tscanf(\"%%g\", %s);\n", $3->c_str(), $3->c_str()); $$ = new std::string(buff); }
        | LPAR exp RPAR { sprintf(buff, "%s", $2->c_str()); $$ = new std::string(buff); }
        | LPAR LET assign exp RPAR { sprintf(buff, "%s %s", $3->c_str(), $4->c_str()); $$ = new std::string(buff); }
        | LPAR PLUS adds RPAR { sprintf(buff, "%s", $3->c_str()); $$ = new std::string(buff); }
        | LPAR MINUS exp %prec NEG RPAR { sprintf(buff, "-%s", $3->c_str()); $$ = new std::string(buff); }
        | LPAR MINUS exp exp RPAR { sprintf(buff, " %s - %s", $3->c_str(), $4->c_str()); $$ = new std::string(buff); }
        | LPAR MULT mults RPAR { sprintf(buff, "%s", $3->c_str()); $$ = new std::string(buff); }
        | LPAR DIV exp exp RPAR { sprintf(buff, " %s / %s", $3->c_str(), $4->c_str()); $$ = new std::string(buff); }
        | LPAR POW exp exp RPAR { sprintf(buff," pow(%s,%s)", $3->c_str(), $4->c_str()); $$ = new std::string(buff); }
        | LPAR PRINT exp RPAR { sprintf(buff, "\tprintf(\"%%g\\n\",%s);\n", $3->c_str()); $$ = new std::string(buff); }
        ;
%%

void yyerror(char const *s)
{
    fprintf(stderr, "%s\n", s);
}

int main(void)
{
    return yyparse();
}
