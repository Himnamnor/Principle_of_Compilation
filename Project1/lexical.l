%option header-file="lexical.h"
%option yylineno noyywrap
%{
    #include"syntax.tab.h"
    extern int yycolumn;
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

"//"[^\n]*      { printf("Line %d: single-line comment\n", yylineno); }

"/*"            { BEGIN(COMMENT);
                  printf("Line %d: multi-line comment starts\n", yylineno); }

<COMMENT>"*/"   { BEGIN(INITIAL);
                  printf("Line %d: multi-line comment ends\n", yylineno); }

<COMMENT>\n     {}
<COMMENT>.      {}

;               {printf("Line %d: a semi\n",yylineno); return SEMI;}
,               {printf("Line %d: a coma\n",yylineno); return COMMA;}
"=="              { printf("Line %d: a relop\n",yylineno); return RELOP; }
"!="              { printf("Line %d: a relop\n",yylineno); return RELOP; }
">="              { printf("Line %d: a relop\n",yylineno); return RELOP; }
"<="              { printf("Line %d: a relop\n",yylineno); return RELOP; }
">"               { printf("Line %d: a relop\n",yylineno); return RELOP; }
"<"               { printf("Line %d: a relop\n",yylineno); return RELOP; }
"="               { printf("Line %d: a assignop\n",yylineno); return ASSIGNOP; }
\+              {printf("Line %d: a plus\n",yylineno);return PLUS;}
\-              {printf("Line %d: a minus\n",yylineno);return MINUS;}
\*              {printf("Line %d: a multiply\n",yylineno);return STAR;}
\/              {printf("Line %d: a division\n",yylineno);return DIV;}
&&              {printf("Line %d: a and\n",yylineno); return AND;}
\|\|            {printf("Line %d: a or\n",yylineno); return OR;}
\.              {printf("Line %d: a dot\n",yylineno); return DOT;}
!               {printf("Line %d: a not\n",yylineno); return NOT;}
{type}          {printf("Line %d: a type\n",yylineno); return TYPE;} 
\(              {printf("Line %d: a lp\n",yylineno); return LP;}
\)              {printf("Line %d: a rp\n",yylineno); return RP;}
\[              {printf("Line %d: a lb\n",yylineno); return LB;}
\]              {printf("Line %d: a rb\n",yylineno); return RB;}
\{              {printf("Line %d: a lc\n",yylineno); return LC;}
\}              {printf("Line %d: a rc\n",yylineno); return RC;}

{reserved}      { printf("Line %d: a reserved word: %s\n",yylineno,yytext); }

{struct}        {printf("Line %d: a struct\n",yylineno); return STRUCT;}
{return}        {printf("Line %d: a return\n",yylineno); return RETURN;}
{if}            {printf("Line %d: a if\n",yylineno); return IF;}
{else}          {printf("Line %d: a else\n",yylineno); return ELSE;}
{while}         {printf("Line %d: a while\n",yylineno); return WHILE;}

{id}            {printf("Line %d: an identifier: %s\n",yylineno,yytext); return ID;}
[0-9]+[a-zA-Z_][a-zA-Z_]*      {printf("Error type A at Line %d: identifier can't start with digit!\n",yylineno);}

{int}               { 
                        yylval.type_int=(int)strtol(yytext,NULL,0);
                        return INT;
                    }
0[0-7]*[89][0-9]*   { printf("Line %d: invalid octal literal %s\n", yylineno, yytext); }
0[xX][A-Za-z0-9]*   { printf("Line %d: invalid hex literal %s\n", yylineno, yytext); }

{float}         {printf("Line %d: a float: %lf\n", yylineno,strtof(yytext,NULL)); return FLOAT;}

.               { printf("Error type A at Line %d: You made a mistake \'%s\' like an idiot!\n",yylineno,yytext);}



%%
