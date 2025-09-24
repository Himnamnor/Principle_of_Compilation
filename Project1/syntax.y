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
%token ID
%token SEMI COMMA ASSIGNOP RELOP PLUS MINUS STAR DIV AND OR DOT NOT TYPE LP RP LB RB LC RC STRUCT RETURN IF ELSE WHILE

%right ASSIGNOP
%left OR
%left AND
%left RELOP
%left PLUS MINUS
%left STAR DIV
%right NOT UMINUS 
%left DOT LB RB LP RP



%%


Program: ExtDefList;

ExtDefList:
    | ExtDef ExtDefList
    ;

ExtDef: 
    Specifier FunDec CompSt
    | Specifier SEMI
    | Specifier DecList SEMI
    ;

ExtDecList:
    VarDec
    | VarDec COMMA ExtDecList
    ;



Specifier:
    TYPE
    | StructSpecifier
    ;

StructSpecifier:
    STRUCT Tag
    | STRUCT OptTag LC DefList RC
    ;

OptTag:
    | ID
    ;

Tag:
    ID
    ;


VarDec:
    ID
    | VarDec LB INT RB
    ;

FunDec:
    ID LP RP
    | ID LP VarList RP

VarList:
    ParamDec COMMA VarList
    | ParamDec
    ;

ParamDec:
    Specifier VarDec
    ;


CompSt:
    LC DefList StmtList RC
    ;

StmtList:
    | Stmt StmtList
    ;

Stmt:
    Exp SEMI
    | CompSt
    | RETURN Exp SEMI
    | IF LP Exp RP Stmt
    | IF LP Exp RP ELSE Stmt
    | WHILE LP Exp RP Stmt
    ;


DefList:
    | Def DefList
    ;

Def:
    Specifier DecList SEMI
    ;

DecList:
    Dec
    | Dec COMMA DecList
    ;

Dec:
    VarDec
    | VarDec ASSIGNOP AssignmentExp
    ;


PrimaryExp:
    ID
    | INT
    | FLOAT
    | LP Exp RP
    ;

PostfixExp:
    PrimaryExp
    | PostfixExp LB Exp RB
    | PostfixExp LP RP
    | PostfixExp LP Exp RP
    | PostfixExp DOT ID
    ;

UnaryExp:
    PostfixExp
    | MINUS UnaryExp %prec UMINUS
    | NOT UnaryExp
    ;

MultiplicativeExp:
    UnaryExp
    | MultiplicativeExp STAR UnaryExp
    | MultiplicativeExp DIV UnaryExp
    ;

AdditiveExp:
    MultiplicativeExp
    | AdditiveExp PLUS MultiplicativeExp
    | AdditiveExp MINUS MultiplicativeExp
    ;

RelationalExp:
    AdditiveExp
    | RelationalExp RELOP AdditiveExp
    ;

LogicalAndExp:
    RelationalExp
    | LogicalAndExp AND RelationalExp
    ;

LogicalOrExp:
    LogicalAndExp
    | LogicalOrExp OR LogicalAndExp
    ;

AssignmentExp:
    LogicalOrExp
    | LogicalOrExp ASSIGNOP AssignmentExp
    ;

Exp:
    AssignmentExp
    | Exp COMMA AssignmentExp
    ;


%%
void yyerror(const char* s){
    fprintf(stderr,"Syntax error at Line: %d, Column: %d, %s\n",yylineno,yycolumn,s);
}