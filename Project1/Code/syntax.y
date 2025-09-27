%{
#include "Tree.h"
#include <stdio.h>
#include "lexical.h"
extern int yylineno;
extern TreeNode* root;
extern int has_error;
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
    TreeNode* node;
}

%token <node> INT
%token <node> FLOAT
%token <node> ID
%type <node> Program ExtDefList ExtDef Specifier StructSpecifier
%type <node> OptTag Tag VarDec FunDec VarList ParamDec CompSt StmtList Stmt
%type <node> DefList Def DecList Dec
%type <node> Exp PrimaryExp PostfixExp UnaryExp MultiplicativeExp AdditiveExp
%type <node> RelationalExp LogicalAndExp LogicalOrExp AssignmentExp
%token <node>SEMI COMMA ASSIGNOP RELOP PLUS MINUS STAR DIV AND OR DOT NOT TYPE LP RP LB RB LC RC STRUCT RETURN IF ELSE WHILE

%right ASSIGNOP
%left OR
%left AND
%left RELOP
%left PLUS MINUS
%left STAR DIV
%right NOT UMINUS 
%left DOT LB RB LP RP



%%


Program: ExtDefList 
    {
        $$=newNonTerminalNode("Program",yylineno);
        addChildren($$,1,$1);
        root=$$;
    }
    ;

ExtDefList: {$$=NULL;}
    | ExtDef ExtDefList
    {
        $$=newNonTerminalNode("ExtDefList",yylineno);
        addChildren($$,2,$1,$2);
    }
    ;

ExtDef: 
    Specifier FunDec CompSt
    {
        $$=newNonTerminalNode("ExtDef",yylineno);
        addChildren($$,3,$1,$2,$3);
    }
    | Specifier SEMI
    {
        $$=newNonTerminalNode("ExtDef",yylineno);
        addChildren($$,2,$1,$2);
    }
    | Specifier DecList SEMI
    {
        $$=newNonTerminalNode("ExtDef",yylineno);
        addChildren($$,3,$1,$2,$3);
    }
    | error SEMI
    {
        yyerrok;
    }
    ;
    ;





Specifier:
    TYPE
    {
        $$=newNonTerminalNode("Specifier",yylineno);
        addChildren($$,1,$1);
    }
    | StructSpecifier
    {
        $$=newNonTerminalNode("Specifier",yylineno);
        addChildren($$,1,$1);
    }
    ;

StructSpecifier:
    STRUCT Tag
    {
        $$=newNonTerminalNode("StructSpecifier",yylineno);
        addChildren($$,2,$1,$2);
    }
    | STRUCT OptTag LC DefList RC
    {
        $$=newNonTerminalNode("StructSpecifier",yylineno);
        addChildren($$,5,$1,$2,$3,$4,$5);
    }
    ;

OptTag: { $$ = NULL; }
    | ID
    {
        $$=newNonTerminalNode("OptTag",yylineno);
        addChildren($$,1,$1);
    }
    ;

Tag:
    ID
    {
        $$=newNonTerminalNode("Tag",yylineno);
        addChildren($$,1,$1);
    }
    ;


VarDec:
    ID
    {
        $$=newNonTerminalNode("VarDec",yylineno);
        addChildren($$,1,$1);
    }
    | VarDec LB INT RB
    {
        $$=newNonTerminalNode("VarDec",yylineno);
        addChildren($$,4,$1,$2,$3,$4);
    }
    ;

FunDec:
    ID LP RP
    {
        $$=newNonTerminalNode("FunDec",yylineno);
        addChildren($$,3,$1,$2,$3);
    }
    | ID LP VarList RP
    {
        $$=newNonTerminalNode("FunDec",yylineno);
        addChildren($$,4,$1,$2,$3,$4);
    }
    ;

VarList:
    ParamDec COMMA VarList
    {
        $$=newNonTerminalNode("VarDec",yylineno);
        addChildren($$,3,$1,$2,$3);
    }
    | ParamDec
    {
        $$=newNonTerminalNode("VarDec",yylineno);
        addChildren($$,1,$1);
    }
    ;

ParamDec:
    Specifier VarDec
    {
        $$=newNonTerminalNode("ParamDec",yylineno);
        addChildren($$,2,$1,$2);
    }
    ;


CompSt:
    LC DefList StmtList RC
    {
        $$=newNonTerminalNode("CompSt",yylineno);
        addChildren($$,4,$1,$2,$3,$4);
    }
    ;



DefList: { $$ = NULL; }
    | Def DefList
    {
        $$=newNonTerminalNode("DefList",yylineno);
        addChildren($$,2,$1,$2);
    }
    ;

Def:
    Specifier DecList SEMI
    {
        $$=newNonTerminalNode("Def",yylineno);
        addChildren($$,3,$1,$2,$3);
    }
    | error SEMI
    {
        yyerrok;
    }
    ;
    ;

StmtList: { $$ = NULL; }
    | Stmt StmtList
    {
        $$=newNonTerminalNode("StmtList",yylineno);
        addChildren($$,2,$1,$2);
    }
    ;

Stmt:
    Exp SEMI
    {
        $$=newNonTerminalNode("Stmt",yylineno);
        addChildren($$,2,$1,$2);
    }
    | CompSt
    {
        $$=newNonTerminalNode("Stmt",yylineno);
        addChildren($$,1,$1);
    }
    | RETURN Exp SEMI
    {
        $$=newNonTerminalNode("Stmt",yylineno);
        addChildren($$,3,$1,$2,$3);
    }
    | IF LP Exp RP Stmt
    {
        $$=newNonTerminalNode("Stmt",yylineno);
        addChildren($$,5,$1,$2,$3,$4,$5);
    }
    | IF LP Exp RP ELSE Stmt
    {
        $$=newNonTerminalNode("Stmt",yylineno);
        addChildren($$,6,$1,$2,$3,$4,$5,$6);
    }
    | WHILE LP Exp RP Stmt
    {
        $$=newNonTerminalNode("Stmt",yylineno);
        addChildren($$,5,$1,$2,$3,$4,$5);
    }
    | error SEMI
    {
        yyerrok;
    }
    ;
    ;


DecList:
    Dec
    {
        $$=newNonTerminalNode("DecList",yylineno);
        addChildren($$,1,$1);
    }
    | Dec COMMA DecList
    {
        $$=newNonTerminalNode("DecList",yylineno);
        addChildren($$,3,$1,$2,$3);
    }
    ;

Dec:
    VarDec
    {
        $$=newNonTerminalNode("Dec",yylineno);
        addChildren($$,1,$1);
    }
    | VarDec ASSIGNOP Exp
    {
        $$=newNonTerminalNode("Dec",yylineno);
        addChildren($$,3,$1,$2,$3);
    }
    ;


PrimaryExp:
    ID 
    { $$ = $1; }
    | INT
    { $$ = $1; }
    | FLOAT
    { $$ = $1; }
    | LP Exp RP
    { $$ = $2; } 
    ;


PostfixExp:
    PrimaryExp
    { $$ = $1; }
    | PostfixExp LB AssignmentExp RB
    { $$ = newNonTerminalNode("PostfixExp", yylineno); addChildren($$, 4, $1, $2, $3, $4); }
    | PostfixExp LP RP
    { $$ = newNonTerminalNode("PostfixExp", yylineno); addChildren($$, 3, $1, $2, $3); }
    | PostfixExp LP Exp RP
    { $$ = newNonTerminalNode("PostfixExp", yylineno); addChildren($$, 4, $1, $2, $3, $4); }
    | PostfixExp DOT ID
    { $$ = newNonTerminalNode("PostfixExp", yylineno); addChildren($$, 3, $1, $2, $3); }
    ;

UnaryExp:
    PostfixExp
    { $$ = $1; }
    | MINUS UnaryExp %prec UMINUS
    { $$ = newNonTerminalNode("UnaryExp", yylineno); addChildren($$, 2, $1, $2); }
    | NOT UnaryExp
    { $$ = newNonTerminalNode("UnaryExp", yylineno); addChildren($$, 2, $1, $2); }
    ;

MultiplicativeExp:
    UnaryExp
    { $$ = $1; }
    | MultiplicativeExp STAR UnaryExp
    { $$ = newNonTerminalNode("MultiplicativeExp", yylineno); addChildren($$, 3, $1, $2, $3); }
    | MultiplicativeExp DIV UnaryExp
    { $$ = newNonTerminalNode("MultiplicativeExp", yylineno); addChildren($$, 3, $1, $2, $3); }
    ;

AdditiveExp:
    MultiplicativeExp
    { $$ = $1; }
    | AdditiveExp PLUS MultiplicativeExp
    { $$ = newNonTerminalNode("AdditiveExp", yylineno); addChildren($$, 3, $1, $2, $3); }
    | AdditiveExp MINUS MultiplicativeExp
    { $$ = newNonTerminalNode("AdditiveExp", yylineno); addChildren($$, 3, $1, $2, $3); }
    ;

RelationalExp:
    AdditiveExp
    { $$ = $1; }
    | RelationalExp RELOP AdditiveExp
    { $$ = newNonTerminalNode("RelationalExp", yylineno); addChildren($$, 3, $1, $2, $3); }
    ;

LogicalAndExp:
    RelationalExp
    { $$ = $1; }
    | LogicalAndExp AND RelationalExp
    { $$ = newNonTerminalNode("LogicalAndExp", yylineno); addChildren($$, 3, $1, $2, $3); }
    ;

LogicalOrExp:
    LogicalAndExp
    { $$ = $1; }
    | LogicalOrExp OR LogicalAndExp
    { $$ = newNonTerminalNode("LogicalOrExp", yylineno); addChildren($$, 3, $1, $2, $3); }
    ;

AssignmentExp:
    LogicalOrExp
    { $$ = $1; }
    | LogicalOrExp ASSIGNOP AssignmentExp
    { $$ = newNonTerminalNode("AssignmentExp", yylineno); addChildren($$, 3, $1, $2, $3); }
    ;

Exp:
    AssignmentExp
    {
        if ($1->nodeKind != NODE_NONTERMINAL) {
            $$ = newNonTerminalNode("Exp", yylineno);
            addChildren($$, 1, $1);
        } else {
            $$ = $1;
        }
    }
    | Exp COMMA AssignmentExp
    { $$ = newNonTerminalNode("Exp", yylineno); addChildren($$, 3, $1, $2, $3); }
    ;



%%
void yyerror(const char* s){
    has_error=1;
    printf("Error type B at Line %d: %s\n",yylineno,s);
}