%{
#include "Tree.h"
#include <stdio.h>
#include "lexical.h"
extern int yylineno;
extern TreeNode* root;
extern int has_error;
void yyerror(const char *s);
int yycolumn=1;

%}
%debug
%locations
%union{
    TreeNode* node;
}

%token <node> INT
%token <node> FLOAT
%token <node> ID
%type <node> Program ExtDefList ExtDef ExtDecList Specifier StructSpecifier
%type <node> OptTag Tag VarDec FunDec VarList ParamDec CompSt StmtList Stmt
%type <node> DefList Def DecList Dec
%type <node> Exp PrimaryExp PostfixExp UnaryExp MultiplicativeExp AdditiveExp
%type <node> RelationalExp LogicalAndExp LogicalOrExp AssignmentExp Args
%token <node>SEMI COMMA ASSIGNOP RELOP PLUS MINUS STAR DIV AND OR DOT NOT TYPE LP RP LB RB LC RC STRUCT RETURN IF ELSE WHILE

%right ASSIGNOP
%left OR
%left AND
%left RELOP
%left PLUS MINUS
%left STAR DIV
%right NOT UMINUS 
%left DOT LB RB LP RP
%nonassoc LOWER_THAN_ELSE



%%


Program: ExtDefList 
    {
        $$=newNonTerminalNode("Program",@$.first_line);
        addChildren($$,1,$1);
        root=$$;
    }
    ;

ExtDefList: {$$=NULL;}
    | ExtDef ExtDefList
    {
        $$=newNonTerminalNode("ExtDefList",@$.first_line);
        addChildren($$,2,$1,$2);
    }
    ;

ExtDef: 
    Specifier FunDec CompSt
    {
        $$=newNonTerminalNode("ExtDef",@$.first_line);
        addChildren($$,3,$1,$2,$3);
    }
    | Specifier SEMI
    {
        $$=newNonTerminalNode("ExtDef",@$.first_line);
        addChildren($$,2,$1,$2);
    }
    | Specifier ExtDecList SEMI
    {
        $$=newNonTerminalNode("ExtDef",@$.first_line);
        addChildren($$,3,$1,$2,$3);
    }
    | error SEMI
    {
        yyerrok;
    }
    ;
    ;


ExtDecList:
    VarDec
    {
        $$=newNonTerminalNode("ExtDecList",@$.first_line);
        addChildren($$,1,$1);
    }
    | VarDec COMMA ExtDecList
    {
        $$=newNonTerminalNode("ExtDecList",@$.first_line);
        addChildren($$,3,$1,$2,$3);
    }


Specifier:
    TYPE
    {
        $$=newNonTerminalNode("Specifier",@$.first_line);
        addChildren($$,1,$1);
    }
    | StructSpecifier
    {
        $$=newNonTerminalNode("Specifier",@$.first_line);
        addChildren($$,1,$1);
    }
    ;

StructSpecifier:
    STRUCT Tag
    {
        $$=newNonTerminalNode("StructSpecifier",@$.first_line);
        addChildren($$,2,$1,$2);
    }
    | STRUCT OptTag LC DefList RC
    {
        $$=newNonTerminalNode("StructSpecifier",@$.first_line);
        addChildren($$,5,$1,$2,$3,$4,$5);
    }
    ;

OptTag: { $$ = NULL; }
    | ID
    {
        $$=newNonTerminalNode("OptTag",@$.first_line);
        addChildren($$,1,$1);
    }
    ;

Tag:
    ID
    {
        $$=newNonTerminalNode("Tag",@$.first_line);
        addChildren($$,1,$1);
    }
    ;


VarDec:
    ID
    {
        $$=newNonTerminalNode("VarDec",@$.first_line);
        addChildren($$,1,$1);
    }
    | VarDec LB INT RB
    {
        $$=newNonTerminalNode("VarDec",@$.first_line);
        addChildren($$,4,$1,$2,$3,$4);
    }
    ;

FunDec:
    ID LP RP
    {
        $$=newNonTerminalNode("FunDec",@$.first_line);
        addChildren($$,3,$1,$2,$3);
    }
    | ID LP VarList RP
    {
        $$=newNonTerminalNode("FunDec",@$.first_line);
        addChildren($$,4,$1,$2,$3,$4);
    }
    ;

VarList:
    ParamDec COMMA VarList
    {
        $$=newNonTerminalNode("VarList",@$.first_line);
        addChildren($$,3,$1,$2,$3);
    }
    | ParamDec
    {
        $$=newNonTerminalNode("VarList",@$.first_line);
        addChildren($$,1,$1);
    }
    ;

ParamDec:
    Specifier VarDec
    {
        $$=newNonTerminalNode("ParamDec",@$.first_line);
        addChildren($$,2,$1,$2);
    }
    ;


CompSt:
    LC DefList StmtList RC
    {
        $$=newNonTerminalNode("CompSt",@$.first_line);
        addChildren($$,4,$1,$2,$3,$4);
    }
    ;



DefList: { $$ = NULL; }
    | Def DefList
    {
        $$=newNonTerminalNode("DefList",@$.first_line);
        addChildren($$,2,$1,$2);
    }
    ;

Def:
    Specifier DecList SEMI
    {
        $$=newNonTerminalNode("Def",@$.first_line);
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
        $$=newNonTerminalNode("StmtList",@$.first_line);
        addChildren($$,2,$1,$2);
    }
    ;

Stmt:
    Exp SEMI
    {
        $$=newNonTerminalNode("Stmt",@$.first_line);
        addChildren($$,2,$1,$2);
    }
    | CompSt
    {
        $$=newNonTerminalNode("Stmt",@$.first_line);
        addChildren($$,1,$1);
    }
    | RETURN Exp SEMI
    {
        $$=newNonTerminalNode("Stmt",@$.first_line);
        addChildren($$,3,$1,$2,$3);
    }
    | IF LP Exp RP Stmt %prec LOWER_THAN_ELSE
    {
        $$=newNonTerminalNode("Stmt",@$.first_line);
        addChildren($$,5,$1,$2,$3,$4,$5);
    }
    | IF LP Exp RP Stmt ELSE Stmt
    {
        $$=newNonTerminalNode("Stmt",@$.first_line);
        addChildren($$,7,$1,$2,$3,$4,$5,$6,$7);
    }
    | WHILE LP Exp RP Stmt
    {
        $$=newNonTerminalNode("Stmt",@$.first_line);
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
        $$=newNonTerminalNode("DecList",@$.first_line);
        addChildren($$,1,$1);
    }
    | Dec COMMA DecList
    {
        $$=newNonTerminalNode("DecList",@$.first_line);
        addChildren($$,3,$1,$2,$3);
    }
    ;

Dec:
    VarDec
    {
        $$=newNonTerminalNode("Dec",@$.first_line);
        addChildren($$,1,$1);
    }
    | VarDec ASSIGNOP AssignmentExp
    {
        $$=newNonTerminalNode("Dec",@$.first_line);
        addChildren($$,3,$1,$2,$3);
    }
    ;


PrimaryExp:
    ID 
    { $$ = newNonTerminalNode("PrimaryExp", @$.first_line); addChildren($$, 1, $1); }
    | INT
    { $$ = newNonTerminalNode("PrimaryExp", @$.first_line); addChildren($$, 1, $1); }
    | FLOAT
    { $$ = newNonTerminalNode("PrimaryExp", @$.first_line); addChildren($$, 1, $1); }
    | LP Exp RP
    { $$ = newNonTerminalNode("PrimaryExp", @$.first_line); addChildren($$, 3, $1,$2,$3); } 
    ;


PostfixExp:
    PrimaryExp
    { $$ = $1; }
    | PostfixExp LB AssignmentExp RB
    { $$ = newNonTerminalNode("PostfixExp", yylineno); addChildren($$, 4, $1, $2, $3, $4); }
    | ID LP RP
    { $$ = newNonTerminalNode("PostfixExp", yylineno); addChildren($$, 3, $1, $2, $3); }
    | ID LP Args RP
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
            $$ = newNonTerminalNode("Exp", @$.first_line);
            addChildren($$, 1, $1);
        } else {
            $$ = $1;
        }
    }
    | Exp COMMA AssignmentExp
    { $$ = newNonTerminalNode("Exp", @$.first_line); addChildren($$, 3, $1, $2, $3); }
    ;

Args:
    Exp COMMA Args
    {
        $$=newNonTerminalNode("Args",@$.first_line); addChildren($$,3,$1,$2,$3);
    }
    | Exp
    {
        $$=newNonTerminalNode("Args",@$.first_line); addChildren($$,1,$1);
    }



%%
void yyerror(const char* s){
    has_error=1;
    printf("Error type B at Line %d: %s\n",yylineno,s);
}