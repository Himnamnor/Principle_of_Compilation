%{
#include <stdio.h>
#include "lexical.h"
extern int yylineno;
void yyerror(const char *s);
int yycolumn=1;
#define YY_USER_ACTION \
    yylloc.first_line=yylloc.last_line=yylineno;    \
    yylloc.first_column=yycolumn;                   \
    yylloc.last_column=yycolumn+yyleng-1;           \
    yycolumn+=yyleng;
%}
%debug
%union{
    int type_int;
    float type_float;
    double type_double;
}


%token <type_int> INT
%token <type_float> FLOAT

%token SEMI COMMA ASSIGNOP RELOP PLUS MINUS STAR DIV AND OR DOT NOT TYPE LP RP LB RB LC RC STRUCT RETURN IF ELSE WHILE

%left ADD SUB
%left MUL DIV
%right NEG

%type <type_double> Exp Factor Term

%%

Calc:
    |Calc Exp SEMI{printf("=%lf\n", $2);}
    ;

Exp:
    Exp ADD Factor   { $$ = $1 + $3; }
    | Exp SUB Factor   { $$ = $1 - $3; }
    | SUB Exp %prec NEG { $$ = -$2; }  
    | Factor
    ;

Factor:
    Factor MUL Term { $$ = $1 * $3; }
    | Factor DIV Term { $$ = $1 / $3; }
    | Term
    ;

Term:
    LP Exp RP     { $$ = $2; }
    |INT            { $$ = (double)$1; }
    |FLOAT         { $$=(double)$1;}
    ;

%%
void yyerror(const char* s){
    fprintf(stderr,"Syntax error at Line: %d, Column: %d, %s\n",yylineno,yycolumn,s);
}