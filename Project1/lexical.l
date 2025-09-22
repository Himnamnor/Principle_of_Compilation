%option header-file="lexical.h"
%option yylineno noyywrap

%x COMMENT

digit           [0-9]
letter          [a-zA-Z]
decimalint      [+-]?(0|([1-9][0-9]*))
octint          "0"[0-7]*
hexint          (0[xX])[0-9A-Fa-f]+
int             {decimalint}|{octint}|{hexint}
float           ({decimalint}\.[0-9]+)([eE]{decimalint})?
reserved        (auto|double|break|long|switch|case|enum|register|typedef|char|extern|union|const|short|unsigned|continue|for|signed|void|default|goto|sizeof|volatile|do|static|_Bool|_Complex|_Imaginary|inline|restrict)                             
type            (int|float)
if              (if)
else            (else)
struct          (struct)
return          (return)
while           (while)
id              [_a-zA-Z]+[0-9_a-zA-Z]*




%%

[ \t\r\n]       {}

"//"[^\n]*      { printf("Line %d: single-line comment\n", yylineno); }

"/*"            { BEGIN(COMMENT);
                  printf("Line %d: multi-line comment starts\n", yylineno); }

<COMMENT>"*/"   { BEGIN(INITIAL);
                  printf("Line %d: multi-line comment ends\n", yylineno); }

<COMMENT>\n     { /* yylineno 自动 ++ */ }
<COMMENT>.      { /* 注释内其他字符忽略 */ }

;               {printf("Line %d: a semi\n",yylineno);}
,               {printf("Line %d: a coma\n",yylineno);}
=               {printf("Line %d: a assignop\n",yylineno);}
>|<|>=|<=|==|!= {printf("Line %d: a relop\n",yylineno);}
\+              {printf("Line %d: a plus\n",yylineno);}
\-              {printf("Line %d: a minus\n",yylineno);}
\*              {printf("Line %d: a star\n",yylineno);}
\/              {printf("Line %d: a div\n",yylineno);}
&&              {printf("Line %d: a and\n",yylineno);}
\|\|            {printf("Line %d: a or\n",yylineno);}
\.              {printf("Line %d: a dot\n",yylineno);}
!               {printf("Line %d: a not\n",yylineno);}
{type}          {printf("Line %d: a type\n",yylineno);}
\(              {printf("Line %d: a lp\n",yylineno);}
\)              {printf("Line %d: a rp\n",yylineno);}
\[              {printf("Line %d: a lb\n",yylineno);}
\]              {printf("Line %d: a rb\n",yylineno);}
\{              {printf("Line %d: a lc\n",yylineno);}
\}              {printf("Line %d: a rc\n",yylineno);}

{reserved}      { printf("Line %d: a reserved word: %s\n",yylineno,yytext); }

{struct}        {printf("Line %d: a struct\n",yylineno);}
{return}        {printf("Line %d: a return\n",yylineno);}
{if}            {printf("Line %d: a if\n",yylineno);}
{else}          {printf("Line %d: a else\n",yylineno);}
{while}         {printf("Line %d: a while\n",yylineno);}

{id}            {printf("Line %d: an identifier: %s\n",yylineno,yytext);}
[0-9]+[a-zA-Z_][a-zA-Z_]*      {printf("Error type A at Line %d: identifier can't start with digit!\n",yylineno);}

{int}               { printf("Line %d: an Integer: %d\n",yylineno,(int)strtol(yytext,NULL,0)); }
0[0-7]*[89][0-9]*   { printf("Line %d: invalid octal literal %s\n", yylineno, yytext); }
0[xX][A-Za-z0-9]*   { printf("Line %d: invalid hex literal %s\n", yylineno, yytext); }

{float}         {printf("Line %d: a float: %lf\n", yylineno,strtof(yytext,NULL));}

.               { printf("Error type A at Line %d: You made a mistake \'%s\' like an idiot!\n",yylineno,yytext);}



%%
