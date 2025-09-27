%option header-file="lexical.h"
%option yylineno noyywrap
%{
    #include"Tree.h"
    #include"syntax.tab.h"
    extern int yycolumn;
    extern int has_error;
    //#define printf(...)
%}

%x COMMENT

digit           [0-9]
letter          [a-zA-Z]
decimalint      (0|([1-9][0-9]*))
octint          "0"[0-7]*
hexint          (0[xX])[0-9A-Fa-f]+
int             {decimalint}|{octint}|{hexint}
float           ([0-9]*\.[0-9]+|[0-9]+\.[0-9]*)([eE][+-]?[0-9]+)?
reserved        (auto|double|break|long|switch|case|enum|register|typedef|char|extern|union|const|short|unsigned|continue|for|signed|void|default|goto|sizeof|volatile|do|static|_Bool|_Complex|_Imaginary|inline|restrict)                             
type            (int|float)
if              (if)
else            (else)
struct          (struct)
return          (return)
while           (while)
id              [_a-zA-Z]+[0-9_a-zA-Z]*




%%

[ \t]           {}
[\n\r]          {yycolumn=1;}

"//"[^\n]*      { }

"/*"            { BEGIN(COMMENT); }

<COMMENT>"*/"   { BEGIN(INITIAL);}

<COMMENT>\n     {}
<COMMENT>.      {}


;               {yylval.node=newOtherNode("SEMI"); return SEMI;}
,               {yylval.node=newOtherNode("COMMA"); return COMMA;}
"=="            { yylval.node=newOtherNode("RELOP"); return RELOP; }
">="            { yylval.node=newOtherNode("RELOP"); return RELOP; }
"<="            { yylval.node=newOtherNode("RELOP"); return RELOP; }
">"             { yylval.node=newOtherNode("RELOP"); return RELOP; }
"<"             { yylval.node=newOtherNode("RELOP"); return RELOP; }
"!="            { yylval.node=newOtherNode("RELOP"); return RELOP; }
"="             { yylval.node=newOtherNode("ASSIGNOP"); return ASSIGNOP; }
\+              {yylval.node=newOtherNode("PLUS"); return PLUS;}
\-              {yylval.node=newOtherNode("MINUS"); return MINUS;}
\*              {yylval.node=newOtherNode("STAR"); return STAR;}
\/              {yylval.node=newOtherNode("DIV"); return DIV;}
&&              {yylval.node=newOtherNode("AND"); return AND;}
\|\|            {yylval.node=newOtherNode("OR"); return OR;}
\.              {yylval.node=newOtherNode("DOT"); return DOT;}
!               {yylval.node=newOtherNode("NOT"); return NOT;}
{type}          {yylval.node=newTypeNode(yytext); return TYPE;} 
\(              {yylval.node=newOtherNode("LP"); return LP;}
\)              {yylval.node=newOtherNode("RP"); return RP;}
\[              {yylval.node=newOtherNode("LB"); return LB;}
\]              {yylval.node=newOtherNode("RB"); return RB;}
\{              {yylval.node=newOtherNode("LC"); return LC;}
\}              {yylval.node=newOtherNode("RC"); return RC;}


{reserved}      { /* This is a reserved word, do nothing or handle as needed */ }

{struct}        {yylval.node=newOtherNode("STRUCT"); return STRUCT;}
{return}        {yylval.node=newOtherNode("RETURN"); return RETURN;}
{if}            {yylval.node=newOtherNode("IF"); return IF;}
{else}          {yylval.node=newOtherNode("ELSE"); return ELSE;}
{while}         {yylval.node=newOtherNode("WHILE"); return WHILE;}

{id}            {
                    yylval.node=newIDNode(yytext);    
                    return ID;
                }
[0-9]+[a-zA-Z_][a-zA-Z_]*      {}

{int}               { 
                        yylval.node=newIntNode((int)strtol(yytext,NULL,0));
                        return INT;
                    }
0[0-7]*[89][0-9]*   {}
0[xX][A-Za-z0-9]*   {}

{float}         {
                    yylval.node=newFloatNode(strtof(yytext,NULL));
                    return FLOAT;}


.               { has_error=1; printf("Error type A at Line %d: You made a mistake \'%s\' like an idiot!\n",yylineno,yytext);}



%%
